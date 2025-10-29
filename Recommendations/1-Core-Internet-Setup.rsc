# ============================================================================
# STEP 1: CORE ROUTER - INTERNET INTERFACE SETUP
# For: 1100_MTIK-CCR1072-THE_CORE
# ============================================================================
# Purpose: Configure 4th internet connection and prepare all WAN interfaces
# ============================================================================

# ----------------------------------------------------------------------------
# VVGChurch Internet Connection (4th WAN)
# ----------------------------------------------------------------------------
# Currently: sfp-sfpplus8-VVGChurch untagged on VLAN3010
# Issue: VLAN3010 is "FRIEND OF GOD" - mixing LAN and WAN is problematic
# Solution: Create dedicated internet VLAN

# Option A: Create new VLAN for VVGChurch Internet (RECOMMENDED)
/interface vlan
add interface=IDNI.CORE-Bridge name="VLAN3004 - VVG_INTERNET" vlan-id=3004 \
    comment="VVGChurch 100Mbps Internet - Outbound Only"

# Configure VLAN on bridge (allow on VVGChurch port)
/interface bridge vlan
add bridge=IDNI.CORE-Bridge tagged=IDNI.CORE-Bridge \
    untagged=sfp-sfpplus8-VVGChurch vlan-ids=3004

# Assign IP address (create /30 subnet like your other WANs)
/ip address
add address=192.168.254.2/30 interface="VLAN3004 - VVG_INTERNET" \
    network=192.168.254.0 comment="VVGChurch Internet Gateway"
# Gateway will be 192.168.254.1 (ISP router)

# NOTE: You'll need to configure the ISP router:
# - LAN IP: 192.168.254.1/30
# - Allow 192.168.254.2 through firewall
# - NAT for 192.168.254.2 going outbound

# Option B: Keep current setup (simpler but less organized)
# Use existing sfp-sfpplus8-VVGChurch with 192.168.1.250/24
# Gateway: 192.168.1.1
# This works but mixes WAN and LAN - not recommended long-term

# ----------------------------------------------------------------------------
# Define Interface Lists for All WANs
# ----------------------------------------------------------------------------
/interface list
add name=WAN_ALL comment="All internet connections"
add name=WAN_WITH_PORTFWD comment="WANs that accept inbound connections"
add name=WAN_OUTBOUND_ONLY comment="WANs for outbound traffic only"
add name=LAN_ALL comment="All internal networks"

# Add WAN interfaces
/interface list member
add list=WAN_ALL interface="VLAN3000 - 1000_INTERNET" comment="500Mbps via 1000"
add list=WAN_ALL interface="VLAN3002 - 1012_INTERNET" comment="1Gbps via 1012 PRIMARY"
add list=WAN_ALL interface="VLAN3003 - 1005_INTERNET" comment="50Mbps via 1005"
add list=WAN_ALL interface="VLAN3004 - VVG_INTERNET" comment="100Mbps via VVG OUTBOUND ONLY"

# WANs with port forwarding capabilities
add list=WAN_WITH_PORTFWD interface="VLAN3000 - 1000_INTERNET"
add list=WAN_WITH_PORTFWD interface="VLAN3002 - 1012_INTERNET"
add list=WAN_WITH_PORTFWD interface="VLAN3003 - 1005_INTERNET"

# Outbound-only WAN
add list=WAN_OUTBOUND_ONLY interface="VLAN3004 - VVG_INTERNET"

# Add ALL internal VLANs to LAN_ALL (examples - add all yours)
/interface list member
add list=LAN_ALL interface="VLAN1000 - VCID OFFICE"
add list=LAN_ALL interface="VLAN1001 - VCID 26 PBS"
add list=LAN_ALL interface="VLAN1005 - VCID 8 KBS"
add list=LAN_ALL interface="VLAN1012 - VCID VPS"
add list=LAN_ALL interface="VLAN1100 - IDNI CORE NETWORKING"
add list=LAN_ALL interface="VLAN1101 - IDNI CORE SERVERS"
# ... ADD ALL YOUR OTHER VLANs HERE ...

# ----------------------------------------------------------------------------
# Gateway Monitoring IPs (for failover detection)
# ----------------------------------------------------------------------------
/ip firewall address-list
add list=GATEWAY_1000 address=10.10.0.1 comment="1000_INTERNET gateway"
add list=GATEWAY_1012 address=10.10.2.1 comment="1012_INTERNET gateway PRIMARY"
add list=GATEWAY_1005 address=10.10.3.1 comment="1005_INTERNET gateway"
add list=GATEWAY_VVG address=192.168.254.1 comment="VVG_INTERNET gateway"

# Public DNS servers for connectivity testing
add list=DNS_MONITOR address=8.8.8.8 comment="Google DNS"
add list=DNS_MONITOR address=1.1.1.1 comment="Cloudflare DNS"

# ----------------------------------------------------------------------------
# Server Address Lists (Servers accessible from internet)
# ----------------------------------------------------------------------------
/ip firewall address-list
# Your main servers that need inbound access
add list=PUBLIC_SERVERS address=10.11.101.206 comment="ANPR01 - Main inbound traffic"
add list=PUBLIC_SERVERS address=10.11.101.212 comment="ProxyManager/Dockers"
add list=PUBLIC_SERVERS address=10.11.101.202 comment="ADDC01"
add list=PUBLIC_SERVERS address=10.11.101.205 comment="MSQL01"
add list=PUBLIC_SERVERS address=10.11.101.201 comment="VMS09-iDrac"
# ADD OTHER SERVERS AS NEEDED

# ----------------------------------------------------------------------------
# Verification Commands
# ----------------------------------------------------------------------------
# After applying, verify:
# /interface list member print
# /interface vlan print where name~"INTERNET"
# /ip address print where interface~"INTERNET"

# Next step: Apply connection and routing marks (see next file)
