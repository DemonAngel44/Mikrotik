# Network Device Inventory

## Core Infrastructure

### Core Router
- **Device**: CCR1072-1G-8S+ (72-core Tilera)
- **Identity**: `1100_MTIK-CCR1072-THE_CORE`
- **Location**: Central datacenter/rack
- **Management IP**: 10.11.100.250 (VLAN1100)
- **Serial**: 727206808AEA
- **RouterOS**: 7.20.1
- **Software ID**: LYSU-Q66R
- **Purpose**: Central routing hub for all 200+ sites
- **CPU**: 1.3% (80 Gbps capable)
- **Key Interfaces**:
  - sfp-sfpplus2-VPSSwitch1 (to 1012 site)
  - sfp-sfpplus3-8KBS-Switch1 (to 1005 site)
  - sfp-sfpplus4-VCIDOfficeSwitch1 (to 1000 site)
  - sfp-sfpplus7-CameraSwitchNew
  - sfp-sfpplus8-VVGChurch

---

## Site Routers with Internet Connections

### 1000_INTERNET - VCID Office
- **Device**: CCR2004-1G-12S+2XS
- **Suggested Identity**: `1000_VCID-Office-SiteGW`
- **Current Identity**: Unknown (not in config)
- **Serial**: D4F00D081203
- **RouterOS**: 7.20.2
- **Software ID**: BTBI-G6D4
- **Internet Speed**: 500 Mbps
- **Public IP**: 102.182.242.216/26
- **Connection to Core**:
  - VLAN3000-Internet: 10.10.0.1/30 (core is 10.10.0.2)
  - VLAN1000: 10.11.100.205/30 (core is 10.11.100.206)
- **LAN Networks**: 10.11.0.0/24, 192.168.8.0/24
- **Key Interfaces**:
  - ether1 (Internet from ISP)
  - sfp-sfpplus12-WAN (trunk to core)
  - sfp-sfpplus1-Services
  - sfp-sfpplus11-LAN
- **Port Forwarding**: YES (needs fixing - see CHANGES-NEEDED.rsc)
- **Current Issues**:
  - Line 97: Broad masquerade rule (strips source IP)
  - Forwards directly to servers (should forward to core)
- **Risk Level for Changes**: LOW (not your connection point)

### 1012_INTERNET - VPS School (PRIMARY)
- **Device**: CCR2004-1G-12S+2XS
- **Suggested Identity**: `1012_VPS-School-SiteGW`
- **Current Identity**: Unknown (not in config)
- **Serial**: D4F00CDF7E96
- **RouterOS**: 7.20.2
- **Software ID**: ME7A-VS42
- **Internet Speed**: 1 Gbps (PRIMARY - highest bandwidth)
- **Connection to Core**:
  - VLAN3002-Internet: 10.10.2.1/30 (core is 10.10.2.2)
  - VLAN1012-WAN: Connection to core
- **Camera VLANs**:
  - VLAN20-IPCAMERAS: 192.168.107.x (heavy traffic)
  - Multiple camera locations
- **LAN Networks**:
  - VLAN10-LAN: 10.11.12.x
  - VLAN20-IPCAMERAS: 192.168.107.x
  - VLAN30-WIFIAPs
  - VLAN40-IPPhones: 192.168.106.x
  - VLAN50-WIFIClients: 192.168.108.x
  - VLAN51-GuestWIFI: 192.168.112.x
- **Key Interfaces**:
  - ether1-Internet (from ISP)
  - sfp-sfpplus12-WAN (trunk to core)
  - sfp-sfpplus1-G2 through sfp-sfpplus5-LAN (internal switches)
  - sfp-sfpplus11-PHONE
- **CAPsMAN**: Configured (wireless controller)
- **Port Forwarding**: NO (needs adding - see CHANGES-NEEDED.rsc)
- **Current Issues**:
  - No port forwarding configured
  - No routes to internal networks
- **Risk Level for Changes**: LOW (not your connection point)

### 1005_INTERNET - 8KBS (YOUR CONNECTION!)
- **Device**: CRS318-16P-2S+ (Switch with routing)
- **Suggested Identity**: `1005_8KBS-SiteGW`
- **Current Identity**: Unknown (not in config)
- **Serial**: D55A0F5C3238
- **RouterOS**: 7.20.2
- **Software ID**: V59N-BN1W
- **Internet Speed**: 50 Mbps
- **Connection to Core**:
  - VLAN3003-Internet: 10.10.3.1/30 (core is 10.10.3.2)
  - VLAN1005: 10.11.5.250/24 (YOUR connection via 10.11.5.x)
- **Management IP**: 10.11.5.250/24 ← YOU ARE HERE
- **LAN Network**: 10.11.5.0/24 (DHCP pool: .1-.249)
- **Key Interfaces**:
  - ether1-Internet (from ISP)
  - sfp-sfpplus1-WAN (trunk to core)
  - ether2-AtosLaptop through ether16-OfficeWAP (internal devices)
  - sfp-sfpplus2-Garage
- **WireGuard Tunnels**:
  - WG_M_5065_BBID-Windmeul (10.15.67.251/24)
  - WG_M_5067_CLC-UK
- **CAPsMAN**: Configured (wireless controller)
- **Port Forwarding**: NO
- **Current Issues**: None critical
- **Risk Level for Changes**: ⚠️ **CRITICAL - DO NOT TOUCH WITHOUT BACKUP ACCESS!**

### 3004_INTERNET - VVG Church (Outbound Only)
- **Device**: ISP Router (not Mikrotik)
- **Suggested Identity**: N/A (ISP managed)
- **Connection**: 100 Mbps
- **Interface on Core**: sfp-sfpplus8-VVGChurch
- **Purpose**: Outbound traffic only (no port forwarding capability)
- **Risk Level**: LOW (no management access needed)

---

## Device Naming Recommendations

### Core Router (Already Named)
```
Current: 1100_MTIK-CCR1072-THE_CORE
Recommendation: Keep as-is (already well-named)
```

### Site Routers (Need Naming)
```
1000: 1000_VCID-Office-CCR2004-SiteGW
1005: 1005_8KBS-CRS318-SiteGW
1012: 1012_VPS-School-CCR2004-SiteGW
```

### Naming Convention Format
```
[VLAN-ID]_[Location]-[Model]-[Function]

Examples:
- 1000_VCID-Office-CCR2004-SiteGW
- 1005_8KBS-CRS318-SiteGW
- 1012_VPS-School-CCR2004-SiteGW
```

---

## Safe Configuration Order (ZERO Risk of Lockout)

### Phase 1: 1000 Router (Safest - Not Your Connection)
- ✅ No risk to your access
- ✅ Already has port forwarding (just fixing NAT)
- ✅ Can rollback easily
- ✅ Test before moving to next device

### Phase 2: 1012 Router (Safe - Not Your Connection)
- ✅ No risk to your access
- ✅ Adding new rules (not modifying existing)
- ✅ Can test without affecting production

### Phase 3: Core Router (Medium Risk - Test Carefully)
- ⚠️ Affects ALL traffic routing
- ⚠️ Must test in stages
- ✅ Can access via 1005 even if core routing breaks
- ✅ Connection marking doesn't affect existing routing (just adds)

### Phase 4: 1005 Router (YOUR CONNECTION - DO LAST!)
- ⚠️ **HIGH RISK - Could lock you out**
- ⚠️ Only do if you have:
  - Physical access to router, OR
  - Out-of-band management (IPMI, console server), OR
  - Someone on-site who can reset if needed
- ✅ Actually, we DON'T need to change 1005 for initial testing!

---

## Your Connection Path

```
Your PC (10.11.5.x)
    ↓
1005 Site Router (10.11.5.250)
    ↓ via sfp-sfpplus1-WAN
CORE Router (10.11.5.250 is on VLAN1005)
    ↓ via sfp-sfpplus3-8KBS-Switch1
Core's routing table
    ↓
To any destination you manage
```

### What Affects Your Access:
- ❌ **1005 router config** - DIRECT impact (could lock you out)
- ⚠️ **Core router config** - Could affect routing but unlikely to lock you out
- ✅ **1000 router config** - No impact (different site)
- ✅ **1012 router config** - No impact (different site)

### What We're Changing:
1. **1000 router**: NAT rules (no impact on your connection)
2. **1012 router**: Adding port forwards (no impact on your connection)
3. **Core router**: Adding connection marking (doesn't change existing routing)
4. **1005 router**: Nothing initially! (keep you safe)

---

## Emergency Access Plan

### If Core Router Becomes Inaccessible:
```
Your PC → 1005 Router → Core Router (via 10.11.100.250)
```
Even if core routing breaks, you can still access it via its management IP.

### If 1005 Router Becomes Inaccessible:
```
Options:
1. Physical access to console port
2. Via another site router → Core → 1005 (if routing still works)
3. Reset button (last resort)
```

### Emergency Contacts:
- **Site 1005 (your location)**: Your physical location
- **Physical access available?**: [Fill in]
- **Backup access method**: [Fill in]

---

## Safe Mode Feature (Mikrotik Built-in Protection)

When making risky changes, use Safe Mode:

```routeros
# Enable safe mode before making changes
[Ctrl+X] in terminal

# Or type:
/system/reboot

# Terminal shows: [Safe]

# Make your changes...
# If you get disconnected, router auto-reverts after 60 seconds

# When done and tested:
[Ctrl+X] again to commit changes permanently
```

**Recommendation**: Use Safe Mode for ANY changes to 1005 router or core router.

---

## Pre-Flight Checklist (Before Any Changes)

### For ANY Device:
- [ ] Backup current config: `/export file=backup-YYYY-MM-DD`
- [ ] Note current identity: `/system identity print`
- [ ] Test current connectivity: `ping 8.8.8.8`
- [ ] Document current management IP access
- [ ] Have rollback plan ready

### For 1005 Router (Your Connection):
- [ ] **Have physical access available** (in case of lockout)
- [ ] Enable Safe Mode: `[Ctrl+X]`
- [ ] Make one small change at a time
- [ ] Test after EACH change
- [ ] Wait 60 seconds between changes (Safe Mode timeout)

### For Core Router:
- [ ] Backup entire config
- [ ] Note all current routes: `/ip route print`
- [ ] Document current connection marks: None yet (safe to add)
- [ ] Test access from multiple sites after change
- [ ] Verify 1005 connectivity remains stable

---

## Testing Access After Changes

### Test 1: Can You Still Access Core?
```
From your PC: ping 10.11.100.250
From your PC: ssh admin@10.11.100.250
```

### Test 2: Can You Still Access Internet?
```
From your PC: ping 8.8.8.8
From your PC: curl https://www.google.com
```

### Test 3: Can You Access Other Sites?
```
From your PC: ping 10.11.0.250 (1000 site)
From your PC: ping 10.11.12.250 (1012 site - if reachable)
```

### Test 4: Can Other Sites Still Reach You?
```
From core: ping 10.11.5.250
From 1000: ping 10.11.5.250 (if routed via core)
```

---

## Device Summary Table

| Site | Device | Speed | Your Risk | Can Touch? | Priority |
|------|--------|-------|-----------|------------|----------|
| **1000** VCID | CCR2004 | 500M | None | ✅ Yes - Safe | 1st (safest) |
| **1012** VPS | CCR2004 | 1G | None | ✅ Yes - Safe | 2nd (safe) |
| **Core** 1100 | CCR1072 | 80G | Low | ⚠️ Careful | 3rd (test carefully) |
| **1005** 8KBS | CRS318 | 50M | **HIGH** | ❌ Last Resort | 4th (NOT NEEDED initially!) |
| **VVG** Church | ISP | 100M | None | ❌ No access | N/A |

---

## Recommended Naming Commands

Apply these to set proper identities:

### 1000 Router:
```routeros
/system identity set name="1000_VCID-Office-CCR2004-SiteGW"
```

### 1012 Router:
```routeros
/system identity set name="1012_VPS-School-CCR2004-SiteGW"
```

### 1005 Router (Your Connection - Use Safe Mode!):
```routeros
[Ctrl+X]  # Enable Safe Mode first!
/system identity set name="1005_8KBS-CRS318-SiteGW"
[Ctrl+X]  # Commit if successful
```

---

**BOTTOM LINE**:
- You can safely change 1000 and 1012 routers without any risk to your connection
- Core router changes are low risk (we're only adding rules, not changing existing)
- 1005 router should be LEFT ALONE until you have backup access method
- We don't actually need to change 1005 for the solution to work!
