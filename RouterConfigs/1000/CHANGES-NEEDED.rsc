# ============================================================================
# CHANGES NEEDED FOR 1000 SITE ROUTER (VCID Office CCR2004)
# ============================================================================
# Router: CCR2004-1G-12S+2XS
# Connection: 500Mbps
# Current State: HAS port forwarding but with PROBLEMATIC masquerade
# ============================================================================

# BACKUP FIRST!
# /export file=1000-backup-before-changes
# /system backup save name=1000-backup-before-changes

# ============================================================================
# CRITICAL ISSUE: Line 97 - Broad Masquerade Rule
# ============================================================================
# Current config line 97:
# add action=masquerade chain=srcnat out-interface=VLAN3000-Internet

# This masquerades ALL outbound traffic, including forwarded traffic!
# This strips the source IP, replacing it with 10.10.0.1
# Core router then can't mark connections correctly

# REMOVE THIS RULE:
/ip firewall nat
remove [find chain=srcnat and out-interface=VLAN3000-Internet and action=masquerade]

# REPLACE WITH SELECTIVE MASQUERADE:
add chain=srcnat action=masquerade out-interface=VLAN3000-Internet \
    src-address=10.10.0.0/30 \
    comment="Masquerade only router's own traffic (10.10.0.0/30)"

# Explanation:
# OLD: Masqueraded everything (10.11.x.x → 10.10.0.1)
# NEW: Masquerades only router's own traffic from 10.10.0.0/30
# Result: Forwarded traffic keeps original source IP ✓

# ============================================================================
# ISSUE 2: Port Forwards Go Directly to Servers
# ============================================================================
# Current config forwards to specific server IPs:
# Lines 88-96 forward to: 10.11.101.230, 10.10.0.1, 10.11.100.250, 10.11.101.206

# Problem: Bypasses core router's connection marking
# Solution: Forward to core (10.10.0.2), let core route to servers

# REMOVE existing port forward rules:
/ip firewall nat
remove [find chain=dstnat and in-interface=VLAN3000-Internet]

# ADD NEW port forwards (to core):
add chain=dstnat action=dst-nat to-addresses=10.10.0.2 \
    in-interface=VLAN3000-Internet protocol=tcp dst-port=22 \
    comment="Forward SSH to core"

add chain=dstnat action=dst-nat to-addresses=10.10.0.2 \
    in-interface=VLAN3000-Internet protocol=tcp dst-port=6280-6290 \
    comment="Forward ANPR ports to core"

add chain=dstnat action=dst-nat to-addresses=10.10.0.2 \
    in-interface=VLAN3000-Internet protocol=udp dst-port=500,1701,4500 \
    comment="Forward VPN ports to core"

add chain=dstnat action=dst-nat to-addresses=10.10.0.2 \
    in-interface=VLAN3000-Internet protocol=tcp dst-port=80,443,8080,8443 \
    comment="Forward HTTP/HTTPS to core"

add chain=dstnat action=dst-nat to-addresses=10.10.0.2 \
    in-interface=VLAN3000-Internet protocol=tcp dst-port=554 \
    comment="Forward RTSP camera streams to core"

# If you need source-specific forwarding (like your line 90-92):
add chain=dstnat action=dst-nat to-addresses=10.10.0.2 \
    in-interface=VLAN3000-Internet protocol=tcp dst-port=6280,6281 \
    src-address=165.0.77.19 \
    comment="Forward ANPR from specific source to core"

# ============================================================================
# ALREADY GOOD: Routes to Internal Networks
# ============================================================================
# Your lines 107-120 already route private ranges back to core
# These are CORRECT - keep them!

# add dst-address=10.0.0.0/8 gateway=10.11.100.206
# add dst-address=192.168.0.0/16 gateway=10.11.100.206
# etc.

# NOTE: Your gateway is 10.11.100.206 but should be 10.10.0.2 (core)
# Let me check your addressing...
# Line 46: add address=10.11.100.205/30 interface=VLAN1000
# So your connection to core is 10.11.100.205/30
# Gateway should be 10.11.100.206 (the /30 peer) ✓ This is correct!

# Wait - but line 50 shows: add address=10.10.0.1/30 interface=VLAN3000-Internet
# So you have TWO addresses on internet VLAN:
# - 10.10.0.1/30 (connection to core 10.10.0.2)
# - 102.182.242.216/26 (public IP from ISP)

# This is unusual but can work. Let me verify the routing...

# Actually, looking more carefully:
# - VLAN1000 connects to core (10.11.100.205/30, peer is 10.11.100.206)
# - VLAN3000-Internet is the internet connection (10.10.0.1/30, peer is 10.10.0.2 which is core)

# So VLAN3000 is not actually internet - it's the path TO the core!
# This means your port forwards should work as-is (forwarding to core via 10.10.0.2)

# But wait, your routes use gateway=10.11.100.206 (VLAN1000)
# And your NAT uses in-interface=VLAN3000-Internet

# I think there's confusion in the addressing. Let me clarify:

# CORRECT UNDERSTANDING based on your config:
# - ether1 (ISP connection) → untagged VLAN 3000 → 10.10.0.1/30
# - 10.10.0.2 is the CORE router
# - sfp-sfpplus12-WAN connects to core with tagged VLANs including VLAN 1000
# - VLAN1000 has address 10.11.100.205/30 where peer is 10.11.100.206

# So you have TWO connections to core:
# 1. Internet path: ether1 → VLAN3000 (10.10.0.1) → Core (10.10.0.2)
# 2. Internal LAN path: sfp-sfpplus12-WAN → VLAN1000 (10.11.100.205) → Core (10.11.100.206)

# This is UNUSUAL but could be intentional?
# Typically there's one link to core carrying both internet and internal traffic

# FOR THIS SOLUTION TO WORK:
# Your port forwards to 10.10.0.2 are correct (that's the core on internet VLAN)
# But then core needs to route back via same path

# Actually I think I misunderstood your topology. Let me reconsider...

# REVISED UNDERSTANDING:
# You probably have:
# - ether1 (from ISP) → untagged into VLAN3000
# - VLAN3000 is actually your INTERNET connection (102.182.242.216/26)
# - The 10.10.0.1/30 address is ALSO on VLAN3000 for routing to core
# - sfp-sfpplus12-WAN is trunk to core carrying internal traffic
# - VLAN1000 on the trunk is for LAN services

# IN THAT CASE:
# - Port forwards should dst-nat to 10.10.0.2 (core via internet VLAN) ✓
# - But this doesn't match the multi-WAN design where internet VLANs are dedicated
# - This mixes internet ingress with core routing on same VLAN

# Let me check the recommendation files to see what topology was designed...

# Looking at file 1-Core-Internet-Setup.rsc:
# VLAN3000 (1000_INTERNET) should have:
# - Core IP: 10.10.0.2/30
# - Site router IP: 10.10.0.1/30
# This matches your line 50!

# So VLAN3000-Internet is the connection between site router and core
# ISP traffic comes in on ether1, gets tagged with VLAN 3000
# Then goes over sfp-sfpplus12-WAN (trunk) to core

# But your config shows ether1 is untagged pvid=3000 to bridge
# And sfp-sfpplus12-WAN is tagged VLAN 3000 to bridge
# So traffic flows: Internet → ether1 → bridge → sfp-sfpplus12-WAN → core

# This makes sense! VLAN 3000 carries internet traffic between site and core.

# CONCLUSION: Your topology is correct, just need to fix the NAT

# ============================================================================
# VERIFICATION OF ADDRESSING
# ============================================================================

# Your current setup (from config):
# - ether1 (ISP) → untagged VLAN 3000 → Local bridge
# - sfp-sfpplus12-WAN (to core) → tagged VLAN 3000 → Local bridge
# - VLAN3000-Internet interface has two IPs:
#   - 102.182.242.216/26 (ISP public IP, line 47)
#   - 10.10.0.1/30 (connection to core 10.10.0.2, line 50)

# So incoming traffic from ISP arrives with public IP as destination
# dstnat translates it to internal IP (currently to server, should be to core 10.10.0.2)
# Then routes to core via 10.10.0.2 gateway
# Core sees original source IP (if no srcnat happens)

# This should work with the NAT changes above!

# ============================================================================
# FINAL NAT CONFIGURATION
# ============================================================================

# Summary of changes:
# 1. REMOVE broad masquerade
# 2. ADD selective masquerade (only router's own traffic)
# 3. REMOVE direct-to-server port forwards
# 4. ADD port-forwards-to-core

# After changes, your NAT should look like:

# /ip firewall nat print
# 0  dstnat  tcp  VLAN3000-Internet  22  10.10.0.2  ; SSH to core
# 1  dstnat  tcp  VLAN3000-Internet  6280-6290  10.10.0.2  ; ANPR to core
# 2  dstnat  udp  VLAN3000-Internet  500,1701,4500  10.10.0.2  ; VPN to core
# 3  dstnat  tcp  VLAN3000-Internet  80,443,8080,8443  10.10.0.2  ; HTTP to core
# 4  srcnat  10.10.0.0/30  VLAN3000-Internet  masquerade  ; Only router traffic

# ============================================================================
# ADD INTERFACE LISTS FOR BETTER ORGANIZATION
# ============================================================================

/interface list
add name=WAN comment="Internet-facing"
add name=LAN comment="Internal networks"

/interface list member
add list=WAN interface=VLAN3000-Internet
add list=LAN interface=VLAN1000
add list=LAN interface=sfp-sfpplus1-Services
add list=LAN interface=sfp-sfpplus11-LAN

# ============================================================================
# IMPROVE FIREWALL (Your current rules are minimal)
# ============================================================================

# Current config only has:
# - Line 84: accept ICMP
# - Line 85-86: drop invalid/new on internet interface

# Add more comprehensive rules:

/ip firewall filter

# Forward chain
add chain=forward action=accept connection-state=established,related \
    place-before=0 comment="Allow established/related"

add chain=forward action=accept in-interface-list=WAN \
    out-interface=sfp-sfpplus12-WAN connection-state=new \
    dst-address=10.10.0.2 \
    comment="Allow inbound to core after dstnat"

add chain=forward action=accept in-interface-list=LAN \
    out-interface-list=WAN comment="Allow outbound"

add chain=forward action=drop connection-state=invalid

add chain=forward action=drop comment="Default drop forward"

# Input chain (your current rules are on lines 84-86, expand them)
add chain=input action=accept connection-state=established,related \
    place-before=0

add chain=input action=accept protocol=icmp limit=5,5:packet
# (Your existing ICMP rule is OK, but add rate limiting)

# Update your existing drop rule (line 85-86)
# Currently drops invalid,new from internet - keep this but improve:
add chain=input action=drop in-interface=VLAN3000-Internet \
    connection-state=invalid comment="Drop invalid from internet"

add chain=input action=accept src-address=10.10.0.0/30 \
    comment="Allow from core router"

add chain=input action=accept src-address=10.11.0.0/16 \
    comment="Allow from internal networks"

add chain=input action=drop comment="Default drop input"

# ============================================================================
# VERIFICATION AFTER CHANGES
# ============================================================================

# 1. Verify NAT rules:
/ip firewall nat print

# Expected:
# - dstnat rules forward to 10.10.0.2 (core)
# - srcnat masquerade only for 10.10.0.0/30

# 2. Test inbound connection from internet:
# Connect to your public IP (102.182.242.216) on forwarded port

# 3. On site router, check connection:
/ip firewall connection print where dst-address=10.10.0.2

# Expected to see:
# src=<real-internet-IP> dst=10.10.0.2 (NOT src=10.10.0.1!)

# If you see src=10.10.0.1, masquerade is still stripping source IP

# 4. Verify routes:
/ip route print where dst-address~"10.11"

# Should show routes via 10.11.100.206 (these are correct)

# ============================================================================
# ROLLBACK IF NEEDED
# ============================================================================

# Restore from backup:
/import 1000-backup-before-changes.rsc

# Or manually revert:
# /ip firewall nat add chain=srcnat action=masquerade out-interface=VLAN3000-Internet
# (to restore old behavior, but this defeats the purpose!)

# ============================================================================
# SUMMARY OF CHANGES
# ============================================================================

# BEFORE:
# ❌ Broad masquerade (strips source IP)
# ❌ Port forwards directly to servers (bypasses core routing)
# ⚠️  Minimal firewall rules

# AFTER:
# ✓ Selective masquerade (preserves source IP for forwarded traffic)
# ✓ Port forwards to core (enables connection marking)
# ✓ Comprehensive firewall rules

# RESULT:
# - Inbound connections work
# - Source IPs preserved
# - Core can mark connections and route replies correctly
# - Better security with proper firewall
