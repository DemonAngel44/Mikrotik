# ============================================================================
# STEP 5: SITE ROUTER PORT FORWARDING (WITHOUT SOURCE NAT)
# For: Site routers with internet connections
# ============================================================================
# Purpose: Forward ports to core router while preserving source IP
# This configuration goes on the SITE ROUTERS, not the core!
# ============================================================================

# CRITICAL CONCEPT:
# 1. Site router receives connection from internet client (e.g., 8.8.8.8:12345)
# 2. dstnat changes destination to core router or direct to server
# 3. NO srcnat - packet keeps original source IP (8.8.8.8:12345)
# 4. Core router sees real client IP, marks connection
# 5. Server replies to 8.8.8.8
# 6. Core routes reply back through correct WAN (via routing mark)
# 7. Site router's existing connection tracking handles return translation
# 8. Reply goes back to client ✓

# ============================================================================
# SITE ROUTER 1: 1012_INTERNET (VPS School - CCR2004) - 1Gbps PRIMARY
# ============================================================================
# This is your main internet connection for inbound services

## Interface Configuration ##
# WAN interface: ether1 (or whatever connects to ISP)
# LAN to Core: sfpplus1 (10.10.2.1/30)
#   - Core IP: 10.10.2.2
# Internal VLAN: VLAN1012 (192.168.x.x/24 networks)

/interface list
add name=WAN comment="Internet-facing interface"
add name=LAN comment="Internal network to core"

/interface list member
add list=WAN interface=ether1
add list=LAN interface=sfpplus1

# IP addressing
/ip address
add address=10.10.2.1/30 interface=sfpplus1 comment="Connection to core router"
# WAN IP configured by ISP (DHCP or static)

# ----------------------------------------------------------------------------
# Port Forwarding - Method 1: Forward Everything to Core
# ----------------------------------------------------------------------------
# Forward ALL inbound traffic to core, let core route to specific servers
# This is simpler and more flexible

/ip firewall nat
# Forward common service ports to core (core will route to servers)
add chain=dstnat action=dst-nat to-addresses=10.10.2.2 \
    in-interface-list=WAN protocol=tcp dst-port=80,443,8080,8443 \
    comment="Forward HTTP/HTTPS to core"

add chain=dstnat action=dst-nat to-addresses=10.10.2.2 \
    in-interface-list=WAN protocol=tcp dst-port=6280-6290 \
    comment="Forward ANPR ports to core"

add chain=dstnat action=dst-nat to-addresses=10.10.2.2 \
    in-interface-list=WAN protocol=tcp dst-port=22 \
    comment="Forward SSH to core"

add chain=dstnat action=dst-nat to-addresses=10.10.2.2 \
    in-interface-list=WAN protocol=tcp dst-port=3389 \
    comment="Forward RDP to core"

# Add more ports as needed for your services

# CRITICAL: NO srcnat for forwarded traffic!
# DO NOT add rules like: add chain=srcnat action=masquerade out-interface=sfpplus1

# Masquerade ONLY for locally-originated outbound traffic
add chain=srcnat action=masquerade out-interface-list=WAN \
    src-address=10.10.2.0/30 \
    comment="Masquerade only for local router traffic"

# ----------------------------------------------------------------------------
# Port Forwarding - Method 2: Forward Directly to Servers (Alternative)
# ----------------------------------------------------------------------------
# If you want to forward directly to specific servers (bypassing core routing)
# Use this method if core routing adds too much latency

# /ip firewall nat
# add chain=dstnat action=dst-nat to-addresses=10.11.101.206 to-ports=6280 \
#     in-interface-list=WAN protocol=tcp dst-port=6280 \
#     comment="Direct forward to ANPR01"
#
# add chain=dstnat action=dst-nat to-addresses=10.11.101.212 to-ports=80 \
#     in-interface-list=WAN protocol=tcp dst-port=80 \
#     comment="Direct forward to ProxyManager"

# NOTE: With direct forwarding, you still need NO srcnat!
# The routing mark on the core will still handle return path

# ----------------------------------------------------------------------------
# Routing to Core and Internal Networks
# ----------------------------------------------------------------------------
/ip route
# Route to core's server networks
add dst-address=10.11.0.0/16 gateway=10.10.2.2 comment="Route all internal via core"

# Default route via ISP (automatically added by DHCP or add manually)
# add dst-address=0.0.0.0/0 gateway=<ISP-GATEWAY> comment="Default route via ISP"

# ----------------------------------------------------------------------------
# Firewall Rules
# ----------------------------------------------------------------------------
/ip firewall filter
# Allow established/related
add chain=forward action=accept connection-state=established,related

# Allow forwarded traffic from WAN to internal (after dstnat)
add chain=forward action=accept in-interface-list=WAN out-interface-list=LAN \
    connection-state=new dst-address=10.11.0.0/16 \
    comment="Allow inbound to internal servers"

# Allow outbound from internal
add chain=forward action=accept in-interface-list=LAN out-interface-list=WAN

# Drop everything else
add chain=forward action=drop

# Protect router itself
add chain=input action=accept connection-state=established,related
add chain=input action=accept src-address=10.10.2.0/30 comment="Allow from core"
add chain=input action=accept src-address=10.11.0.0/16 comment="Allow from internal"
add chain=input action=drop


# ============================================================================
# SITE ROUTER 2: 1000_INTERNET (VCID Office - CCR2004) - 500Mbps
# ============================================================================
# Similar configuration to 1012 but using 10.10.0.x addressing

/interface list
add name=WAN comment="Internet-facing interface"
add name=LAN comment="Internal network to core"

/interface list member
add list=WAN interface=ether1
add list=LAN interface=sfpplus1

/ip address
add address=10.10.0.1/30 interface=sfpplus1 comment="Connection to core router (10.10.0.2)"

# Port forwarding (same as 1012 but adjust IPs)
/ip firewall nat
add chain=dstnat action=dst-nat to-addresses=10.10.0.2 \
    in-interface-list=WAN protocol=tcp dst-port=80,443,8080,8443 \
    comment="Forward HTTP/HTTPS to core"

add chain=dstnat action=dst-nat to-addresses=10.10.0.2 \
    in-interface-list=WAN protocol=tcp dst-port=6280-6290 \
    comment="Forward ANPR ports to core"

# NO srcnat for forwarded traffic!
# Masquerade only for router's own traffic
add chain=srcnat action=masquerade out-interface-list=WAN \
    src-address=10.10.0.0/30 \
    comment="Masquerade only for local router traffic"

# Routing
/ip route
add dst-address=10.11.0.0/16 gateway=10.10.0.2 comment="Route all internal via core"

# Firewall (same as 1012)
/ip firewall filter
add chain=forward action=accept connection-state=established,related
add chain=forward action=accept in-interface-list=WAN out-interface-list=LAN \
    connection-state=new dst-address=10.11.0.0/16
add chain=forward action=accept in-interface-list=LAN out-interface-list=WAN
add chain=forward action=drop

add chain=input action=accept connection-state=established,related
add chain=input action=accept src-address=10.10.0.0/30
add chain=input action=accept src-address=10.11.0.0/16
add chain=input action=drop


# ============================================================================
# SITE ROUTER 3: 1005_INTERNET (8KBS - netPower 16P) - 50Mbps
# ============================================================================
# Similar configuration but using 10.10.3.x addressing
# netPower 16P is less powerful, keep config minimal

/interface list
add name=WAN comment="Internet-facing interface"
add name=LAN comment="Internal network to core"

/interface list member
add list=WAN interface=ether1
add list=LAN interface=sfp1

/ip address
add address=10.10.3.1/30 interface=sfp1 comment="Connection to core router (10.10.3.2)"

# Port forwarding - minimal due to 50Mbps limitation
/ip firewall nat
add chain=dstnat action=dst-nat to-addresses=10.10.3.2 \
    in-interface-list=WAN protocol=tcp dst-port=80,443 \
    comment="Forward HTTP/HTTPS to core"

# NO srcnat for forwarded traffic!
add chain=srcnat action=masquerade out-interface-list=WAN \
    src-address=10.10.3.0/30 \
    comment="Masquerade only for local router traffic"

# Routing
/ip route
add dst-address=10.11.0.0/16 gateway=10.10.3.2 comment="Route all internal via core"

# Minimal firewall
/ip firewall filter
add chain=forward action=accept connection-state=established,related
add chain=forward action=accept in-interface-list=WAN out-interface-list=LAN dst-address=10.11.0.0/16
add chain=forward action=accept in-interface-list=LAN out-interface-list=WAN
add chain=forward action=drop


# ============================================================================
# VERIFICATION AND TROUBLESHOOTING
# ============================================================================

# On site router, verify port forward is working:
# /ip firewall nat print
# /ip firewall nat print stats  # Shows hit counts

# Test connection from internet:
# Connect to site's public IP on forwarded port
# On site router: /ip firewall connection print where dst-address~"10.10"
# You should see: src=<public-ip> dst=10.10.X.2 (core)
# NOT src=10.10.X.1 dst=10.11.101.X (that would mean srcnat is happening)

# Verify routing:
# /ip route print where dst-address=10.11.0.0/16

# Monitor forwarded connections:
# /tool torch interface=sfpplus1
# Should see traffic going to 10.10.X.2 with original source IPs

# Check connection tracking:
# /ip firewall connection print where dst-address~"10.11.101"
# Look at the reply-dst-address - it should match the original src-address


# ============================================================================
# IMPORTANT NOTES
# ============================================================================
# 1. NO srcnat on port-forwarded traffic - This is critical!
#    - Only masquerade the router's own traffic
#    - Forwarded traffic keeps original source IP
#
# 2. Site router must route 10.11.0.0/16 via core
#    - This ensures replies can reach the servers
#
# 3. Core must be the default gateway for all servers
#    - Otherwise servers will reply via their own gateway
#
# 4. Connection tracking handles return NAT automatically
#    - When reply comes back from server to client IP
#    - Site router's conntrack translates it back to public IP
#
# 5. Forwarding to core vs direct to server:
#    - To core: More flexible, easier management
#    - Direct: Slightly lower latency, but harder to manage
#
# 6. For VVGChurch (ISP router):
#    - You may not have full control
#    - Use only for outbound traffic
#    - Configure ISP router to route 10.11.0.0/16 via 192.168.254.2

# Next step: Add performance optimizations (see next file)
