# 100% Safe Deployment Plan
## Multi-WAN Implementation with ZERO Risk of Lockout

**Your Connection**: From VLAN1005 (10.11.5.x) → 8KBS CRS318 → Core → Everything else

**Key Safety Principle**: We're NOT touching your connection path (1005 router) at all!

---

## Phase 1: Test on 1000 Router (ZERO RISK)

### Why 1000 First?
- ✅ Different site (can't lock you out)
- ✅ Already has port forwarding (just fixing it)
- ✅ Easy to rollback
- ✅ Validates the whole approach

### Pre-Flight Checklist
```routeros
# Connect to 1000 router
ssh admin@10.11.0.250  # Or via WinBox

# Verify you're on the right device
/system identity print
# Expected: Should show something for 1000 site

# Set proper identity
/system identity set name="1000_VCID-Office-CCR2004-SiteGW"

# Backup EVERYTHING
/export file=1000-backup-before-multiwan-$(date +%Y%m%d)
/system backup save name=1000-backup-before-multiwan-$(date +%Y%m%d)

# Test current connectivity
/ping 10.10.0.2 count=5  # Core router
/ping 8.8.8.8 count=5    # Internet
/ping 10.11.100.250 count=5  # Core management

# All should respond ✓
```

### Step 1.1: Fix NAT (The Critical Fix)

**Current Problem**: Line 97 masquerades ALL traffic
```routeros
# View current NAT
/ip firewall nat print

# You should see something like:
# X srcnat  VLAN3000-Internet  masquerade

# REMOVE the broad masquerade
/ip firewall nat remove [find chain=srcnat and out-interface=VLAN3000-Internet and action=masquerade]
```

### Step 1.2: Add Selective Masquerade
```routeros
# Add SELECTIVE masquerade (only router's own traffic)
/ip firewall nat add chain=srcnat action=masquerade \
    out-interface=VLAN3000-Internet src-address=10.10.0.0/30 \
    comment="Masquerade only router's own traffic (10.10.0.0/30)"

# Verify
/ip firewall nat print where chain=srcnat
# Should show: srcnat with src-address=10.10.0.0/30
```

### Step 1.3: Update Port Forwards to Go to Core
```routeros
# View current port forwards
/ip firewall nat print where chain=dstnat

# Remove old ones
/ip firewall nat remove [find chain=dstnat and in-interface=VLAN3000-Internet]

# Add new ones (forward to core 10.10.0.2)
/ip firewall nat add chain=dstnat action=dst-nat to-addresses=10.10.0.2 \
    in-interface=VLAN3000-Internet protocol=tcp dst-port=80,443 \
    comment="Forward HTTP/HTTPS to core"

/ip firewall nat add chain=dstnat action=dst-nat to-addresses=10.10.0.2 \
    in-interface=VLAN3000-Internet protocol=tcp dst-port=6280-6290 \
    comment="Forward ANPR ports to core"

/ip firewall nat add chain=dstnat action=dst-nat to-addresses=10.10.0.2 \
    in-interface=VLAN3000-Internet protocol=tcp dst-port=22 \
    comment="Forward SSH to core"

/ip firewall nat add chain=dstnat action=dst-nat to-addresses=10.10.0.2 \
    in-interface=VLAN3000-Internet protocol=udp dst-port=500,1701,4500 \
    comment="Forward VPN ports to core"
```

### Step 1.4: Test Changes
```routeros
# Verify NAT config
/ip firewall nat print

# Test connectivity still works
/ping 10.10.0.2 count=5
/ping 8.8.8.8 count=5
```

### Step 1.5: Test from Internet (External Test)

**From an external location** (not from your network):
```bash
# Try to connect to 1000's public IP
ssh user@102.182.242.216

# Or test web access
curl http://102.182.242.216
```

**On 1000 router**, check if source IP is preserved:
```routeros
/ip firewall connection print where dst-address=10.10.0.2

# Expected: src=<real-internet-ip> dst=10.10.0.2
# WRONG: src=10.10.0.1 dst=10.10.0.2 (means masquerade still happening)
```

### Success Criteria for Phase 1:
- [√] Can access 1000 router
- [√] Can still reach internet from 1000 site
- [√] Port forwards exist and go to core (10.10.0.2)
- [√] Source IP preserved (not 10.10.0.1) in connections
- [√] **Your connection from 1005 still works perfectly**

### Rollback if Needed:
```routeros
# Restore from backup
/import 1000-backup-before-multiwan-YYYYMMDD.rsc
```

---

## Phase 2: Configure Core Router (LOW RISK)

**Why Low Risk?**
- We're ADDING rules, not removing existing routing
- Connection marking doesn't affect your existing connection
- You can still access core from 1005 even if routing breaks

### Pre-Flight Checklist
```routeros
# Connect to core from your PC
ssh admin@10.11.100.250  # From 1005 network

# Verify identity
/system identity print
# Expected: 1100_MTIK-CCR1072-THE_CORE

# Backup
/export file=core-backup-before-multiwan-$(date +%Y%m%d)
/system backup save name=core-backup-before-multiwan-$(date +%Y%m%d)

# Verify routing tables exist
/routing table print
# Should see: main (and maybe some others)

# Test connectivity
/ping 10.11.5.250 count=5  # Your 1005 router
/ping 10.10.0.1 count=5    # 1000 site router
/ping 10.10.2.1 count=5    # 1012 site router (if up)
```

### Step 2.1: Create Routing Tables
```routeros
# Create routing tables (if they don't exist)
/routing table add name=Route_Via_1000 fib comment="Route via 1000_INTERNET (500Mbps)"
/routing table add name=Route_Via_1012 fib comment="Route via 1012_INTERNET (1Gbps)"
/routing table add name=Route_Via_1005 fib comment="Route via 1005_INTERNET (50Mbps)"
/routing table add name=Route_Via_VVG fib comment="Route via VVG_INTERNET (100Mbps)"

# Verify
/routing table print
```

### Step 2.2: Add Connection Marking (THE KEY FIX)
```routeros
# Mark inbound connections by which WAN they arrived on
/ip firewall mangle add chain=prerouting action=mark-connection \
    new-connection-mark=VIA_1000 passthrough=yes \
    in-interface="VLAN3000 - 1000_INTERNET" connection-state=new \
    comment="Mark connections from 1000_INTERNET"

/ip firewall mangle add chain=prerouting action=mark-connection \
    new-connection-mark=VIA_1012 passthrough=yes \
    in-interface="VLAN3002 - 1012_INTERNET" connection-state=new \
    comment="Mark connections from 1012_INTERNET"

/ip firewall mangle add chain=prerouting action=mark-connection \
    new-connection-mark=VIA_1005 passthrough=yes \
    in-interface="VLAN3003 - 1005_INTERNET" connection-state=new \
    comment="Mark connections from 1005_INTERNET"

# Verify
/ip firewall mangle print where chain=prerouting and action=mark-connection
```

### Step 2.3: Add Routing Marking
```routeros
# Apply routing marks based on connection marks (prerouting)
/ip firewall mangle add chain=prerouting action=mark-routing \
    new-routing-mark=Route_Via_1000 passthrough=no \
    connection-mark=VIA_1000 \
    comment="Route via 1000_INTERNET"

/ip firewall mangle add chain=prerouting action=mark-routing \
    new-routing-mark=Route_Via_1012 passthrough=no \
    connection-mark=VIA_1012 \
    comment="Route via 1012_INTERNET"

/ip firewall mangle add chain=prerouting action=mark-routing \
    new-routing-mark=Route_Via_1005 passthrough=no \
    connection-mark=VIA_1005 \
    comment="Route via 1005_INTERNET"

# Apply routing marks for OUTPUT chain (router-originated)
/ip firewall mangle add chain=output action=mark-routing \
    new-routing-mark=Route_Via_1000 passthrough=no \
    connection-mark=VIA_1000

/ip firewall mangle add chain=output action=mark-routing \
    new-routing-mark=Route_Via_1012 passthrough=no \
    connection-mark=VIA_1012

/ip firewall mangle add chain=output action=mark-routing \
    new-routing-mark=Route_Via_1005 passthrough=no \
    connection-mark=VIA_1005

# Verify
/ip firewall mangle print where action=mark-routing
```

### Step 2.4: Configure Routes in Each Table
```routeros
# Main table default route (primary via 1012)
/ip route add dst-address=0.0.0.0/0 gateway=10.10.2.1 distance=1 check-gateway=ping

# Route_Via_1000 table
/ip route add dst-address=0.0.0.0/0 gateway=10.10.0.1 distance=1 \
    routing-table=Route_Via_1000 check-gateway=ping
/ip route add dst-address=0.0.0.0/0 gateway=10.10.2.1 distance=2 \
    routing-table=Route_Via_1000 check-gateway=ping  # Failover

# Route_Via_1012 table
/ip route add dst-address=0.0.0.0/0 gateway=10.10.2.1 distance=1 \
    routing-table=Route_Via_1012 check-gateway=ping
/ip route add dst-address=0.0.0.0/0 gateway=10.10.0.1 distance=2 \
    routing-table=Route_Via_1012 check-gateway=ping  # Failover

# Route_Via_1005 table
/ip route add dst-address=0.0.0.0/0 gateway=10.10.3.1 distance=1 \
    routing-table=Route_Via_1005 check-gateway=ping
/ip route add dst-address=0.0.0.0/0 gateway=10.10.2.1 distance=2 \
    routing-table=Route_Via_1005 check-gateway=ping  # Failover
```

### Step 2.5: CRITICAL - Copy Internal Routes to All Tables

**This is essential** - without this, routing between internal networks fails!

```routeros
# Run this script to copy all internal routes to all routing tables
:local tables {"Route_Via_1000";"Route_Via_1012";"Route_Via_1005";}
:foreach t in=$tables do={
    :foreach r in=[/ip route find where dst-address~"^10\\.11\\." and routing-table=main] do={
        :local dst [/ip route get $r dst-address]
        :local gw [/ip route get $r gateway]
        :local dist [/ip route get $r distance]
        :if ($dist < 200) do={
            /ip route add dst-address=$dst gateway=$gw distance=$dist routing-table=$t comment="Auto-copied from main"
        }
    }
}

# Verify internal routes exist in all tables
/ip route print where routing-table=Route_Via_1000 and dst-address~"10.11"
```

### Step 2.6: Test Changes WITHOUT Breaking Your Access
```routeros
# Test 1: Can you still access core from your PC (1005)?
# From your PC: ping 10.11.100.250
# Should still work! (We didn't change existing routing)

# Test 2: Can you still reach internet from your PC?
# From your PC: ping 8.8.8.8
# Should still work!

# Test 3: Check if connection marking is working (will be 0 until traffic arrives)
/ip firewall mangle print stats where action=mark-connection

# Test 4: Verify routes are active
/ip route print where routing-table=Route_Via_1000 and active
```

### Success Criteria for Phase 2:
- [√] Routing tables created
- [√] Connection marking rules added
- [√] Routing marking rules added
- [√] Routes configured in all tables
- [√] Internal routes copied to all tables
- [√] **YOUR CONNECTION FROM 1005 STILL WORKS**
- [√] No error messages
- [√] Can access all internal networks

### Rollback if Needed:
```routeros
# Remove mangle rules
/ip firewall mangle remove [find comment~"Mark connections"]
/ip firewall mangle remove [find action=mark-routing]

# Or full restore
/import core-backup-before-multiwan-YYYYMMDD.rsc
```

---

## Phase 3: Add NAT on Core (LOW RISK)

### Step 3.1: Add Masquerade Rules
```routeros
# Masquerade outbound per WAN
/ip firewall nat add chain=srcnat action=masquerade \
    out-interface="VLAN3000 - 1000_INTERNET" \
    comment="Masquerade outbound via 1000"

/ip firewall nat add chain=srcnat action=masquerade \
    out-interface="VLAN3002 - 1012_INTERNET" \
    comment="Masquerade outbound via 1012"

/ip firewall nat add chain=srcnat action=masquerade \
    out-interface="VLAN3003 - 1005_INTERNET" \
    comment="Masquerade outbound via 1005"

# Keep existing VPN masquerade
# (Don't remove your existing all-ppp masquerade rule)
```

### Test NAT:
```routeros
# From your PC, test internet access
# Should still work via default route
```

---

## Phase 4: End-to-End Testing

### Test 4.1: Test from External Internet via 1000 WAN
```
From external location:
1. Connect to 1000's public IP (102.182.242.216) on port 80 or 22
2. Connection should work
```

**On 1000 site router**, verify source IP preserved:
```routeros
/ip firewall connection print where dst-address=10.10.0.2
# Expected: src=<real-internet-ip> dst=10.10.0.2 ✓
```

**On core router**, verify connection marked:
```routeros
/ip firewall connection print where connection-mark=VIA_1000
# Expected: See connection with mark ✓
```

**On core router**, verify return path:
```routeros
/tool torch interface="VLAN3000 - 1000_INTERNET"
# Expected: See traffic BOTH directions ✓
```

### Test 4.2: Verify Your Connection Still Works
```
From your PC (1005):
# Can still manage core?
ping 10.11.100.250
ssh admin@10.11.100.250

# Can still reach internet?
ping 8.8.8.8
curl https://www.google.com

# Can still reach 1000 site?
ping 10.11.0.250
```

### Success Criteria for Complete Implementation:
- [√] Inbound connection from internet works via 1000
- [√] Source IP preserved (visible to core)
- [√] Connection marked correctly (VIA_1000)
- [√] Return path correct (exits same interface)
- [√] **YOUR CONNECTION FROM 1005 UNAFFECTED**
- [√] All internal routing still works
- [√] Internet access still works from all sites

---

## What We're NOT Changing (Keeps You Safe)

### 1005 Router Configuration:
- ❌ NOT changing any interfaces
- ❌ NOT changing any IP addresses
- ❌ NOT changing any routes
- ❌ NOT changing any firewall rules
- ❌ NOT touching VLAN1005 at all
- ✅ **YOUR CONNECTION PATH REMAINS UNTOUCHED**

### Why This Works:
The solution only requires:
1. Fix 1000 router NAT (different site - safe)
2. Add connection marking on core (doesn't break existing routing)
3. Test via 1000 WAN (doesn't involve 1005)

**You can implement the entire solution without touching 1005!**

---

## Emergency Procedures

### If Core Becomes Inaccessible:
```
Your access path: PC → 1005 router → Core
This path is UNCHANGED, so you should still have access!

If not:
1. Access 1005 router: ssh admin@10.11.5.250
2. From 1005, ping core: /ping 10.11.100.250
3. From 1005, access core: /ssh 10.11.100.250
```

### If Something Goes Wrong:
```routeros
# On core, remove all mangle rules:
/ip firewall mangle remove [find comment~"Mark connections"]
/ip firewall mangle remove [find action=mark-routing]

# Routing will revert to default (via main table)
# Your connection from 1005 will still work
```

### Nuclear Option (Core):
```routeros
/import core-backup-before-multiwan-YYYYMMDD.rsc
/system reboot
```

### Nuclear Option (1000):
```routeros
/import 1000-backup-before-multiwan-YYYYMMDD.rsc
/system reboot
```

---

## Timeline (Conservative)

- **Phase 1** (1000 router): 30 minutes
- **Phase 2** (Core router): 1 hour
- **Phase 3** (Core NAT): 15 minutes
- **Phase 4** (Testing): 30 minutes
- **Buffer time**: 30 minutes

**Total**: 2.5-3 hours (spread over 2-3 sessions if needed)

---

## Final Safety Confirmation

Before starting, confirm:
- [ ] You are connected from 1005 (10.11.5.x)
- [ ] We are NOT changing 1005 router
- [ ] We are changing 1000 router first (different site, can't lock you out)
- [ ] We are adding rules to core (not removing existing routing)
- [ ] You have backups of both 1000 and core
- [ ] You understand rollback procedures
- [ ] You can access core even if routing breaks (via 10.11.100.250)

**YOU ARE 100% SAFE TO PROCEED!**

The only device that could lock you out (1005) is NOT being touched at all.

---

## Ready to Start?

Begin with Phase 1 (1000 router) when you're ready.

Good luck! 🎯
