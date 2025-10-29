# ============================================================================
# CHANGES NEEDED FOR 1012 SITE ROUTER (VPS School CCR2004)
# ============================================================================
# Router: CCR2004-1G-12S+2XS
# Connection: 1Gbps (Primary internet for camera traffic)
# Current State: NO port forwarding configured
# ============================================================================

# BACKUP FIRST!
# /export file=1012-backup-before-changes
# /system backup save name=1012-backup-before-changes

# ============================================================================
# ISSUE 1: No Port Forwarding Configured
# ============================================================================
# Currently no dstnat rules exist in your config
# Need to add port forwarding to enable inbound access from internet

/ip firewall nat

# Add port forwarding rules (forward to core, not directly to servers)
add chain=dstnat action=dst-nat to-addresses=10.10.2.2 \
    in-interface=ether1-Internet protocol=tcp dst-port=554 \
    comment="Forward RTSP camera streams to core"

add chain=dstnat action=dst-nat to-addresses=10.10.2.2 \
    in-interface=ether1-Internet protocol=tcp dst-port=80,443,8080,8443 \
    comment="Forward HTTP/HTTPS camera web interfaces to core"

add chain=dstnat action=dst-nat to-addresses=10.10.2.2 \
    in-interface=ether1-Internet protocol=tcp dst-port=6280-6290 \
    comment="Forward ANPR ports to core"

add chain=dstnat action=dst-nat to-addresses=10.10.2.2 \
    in-interface=ether1-Internet protocol=tcp dst-port=22 \
    comment="Forward SSH to core"

add chain=dstnat action=dst-nat to-addresses=10.10.2.2 \
    in-interface=ether1-Internet protocol=udp dst-port=500,1701,4500 \
    comment="Forward VPN ports to core"

# ============================================================================
# ISSUE 2: Need Outbound NAT (But NOT for Inbound Forwarded Traffic!)
# ============================================================================

# Currently NO srcnat rules exist - ADD selective masquerade

# CORRECT: Masquerade ONLY the router's own traffic
add chain=srcnat action=masquerade out-interface=ether1-Internet \
    src-address=10.10.2.0/30 \
    comment="Masquerade only router's own traffic (not forwarded traffic)"

# WRONG - DO NOT ADD THIS:
# add chain=srcnat action=masquerade out-interface=ether1-Internet
# (This would masquerade ALL traffic, breaking source IP preservation)

# ============================================================================
# ISSUE 3: Add Routes to Internal Networks via Core
# ============================================================================

# Your current config is missing routes back to core's internal networks
/ip route

# Route all internal networks via core
add dst-address=10.11.0.0/16 gateway=10.10.2.2 distance=1 \
    comment="All IDNI networks via core"

add dst-address=192.168.0.0/16 gateway=10.10.2.2 distance=1 \
    comment="All camera subnets via core"

# ============================================================================
# ISSUE 4: Add Internet Interface to WAN List (for firewall rules)
# ============================================================================

/interface list
add name=WAN comment="Internet-facing interface"

/interface list member
add list=WAN interface=ether1-Internet

# Update your existing LAN list to include all local VLANs
/interface list member
add list=LAN interface=VLAN10-LAN
add list=LAN interface=VLAN20-IPCAMERAS
add list=LAN interface=VLAN30-WIFIAPs
add list=LAN interface=VLAN40-IPPhones
add list=LAN interface=VLAN50-WIFIClients
add list=LAN interface=VLAN51-GuestWIFIClients
add list=LAN interface=VLAN1012-WAN  # Connection to core

# ============================================================================
# ISSUE 5: Add Firewall Rules for Security
# ============================================================================

/ip firewall filter

# Allow established/related
add chain=forward action=accept connection-state=established,related \
    comment="Allow established/related"

# Allow forwarding from WAN to internal (after dstnat translates to core/servers)
add chain=forward action=accept in-interface-list=WAN out-interface=VLAN1012-WAN \
    connection-state=new dst-address=10.0.0.0/8 \
    comment="Allow inbound to internal networks via core"

# Allow outbound from LAN to internet
add chain=forward action=accept in-interface-list=LAN out-interface-list=WAN \
    comment="Allow outbound internet access"

# Drop invalid
add chain=forward action=drop connection-state=invalid \
    comment="Drop invalid connections"

# Drop all other forward traffic
add chain=forward action=drop comment="Default drop"

# Protect router itself
add chain=input action=accept connection-state=established,related
add chain=input action=accept src-address=10.10.2.0/30 comment="Allow from core"
add chain=input action=accept src-address=10.11.0.0/16 comment="Allow from internal"
add chain=input action=accept protocol=icmp limit=5,5:packet comment="Allow limited ICMP"
add chain=input action=drop comment="Drop all other input"

# ============================================================================
# OPTIONAL: MSS Clamping for Camera Streams
# ============================================================================

/ip firewall mangle
add chain=forward action=change-mss new-mss=clamp-to-pmtu protocol=tcp \
    tcp-flags=syn passthrough=yes comment="Clamp MSS for camera streams"

# ============================================================================
# VERIFICATION COMMANDS
# ============================================================================

# After applying changes, verify:

# 1. Port forwards exist:
# /ip firewall nat print where chain=dstnat

# 2. Masquerade only for router's traffic:
# /ip firewall nat print where chain=srcnat
# Should see: src-address=10.10.2.0/30

# 3. Routes to internal networks:
# /ip route print where dst-address~"10.11"

# 4. Test from internet (connect to public IP on forwarded port):
# /ip firewall connection print where dst-address=10.10.2.2
# Should see: src=<real-client-IP> dst=10.10.2.2 (NOT src=10.10.2.1!)

# 5. Check firewall rules:
# /ip firewall filter print

# ============================================================================
# CONFIGURATION SUMMARY
# ============================================================================

# What these changes do:
# ✓ Add port forwarding for inbound access
# ✓ Forward to CORE (10.10.2.2), not directly to servers
# ✓ Preserve source IP (no srcnat for forwarded traffic)
# ✓ Add routes back to internal networks
# ✓ Add firewall security
# ✓ Optimize MSS for camera streams

# What NOT to do:
# ✗ Do not add broad masquerade rule
# ✗ Do not forward directly to server IPs (forward to core instead)
# ✗ Do not skip firewall rules (security!)

# Expected result:
# - Inbound connections from internet work
# - Source IPs are preserved (visible to servers as real client IPs)
# - Core router can mark connections and route replies correctly
# - Camera streams work smoothly

# ============================================================================
# ROLLBACK (if something goes wrong)
# ============================================================================

# Restore from backup:
# /import 1012-backup-before-changes.rsc

# Or manually remove added rules:
# /ip firewall nat remove [find comment~"Forward.*to core"]
# /ip firewall nat remove [find comment~"Masquerade only router"]
# /ip route remove [find comment~"via core"]
