# ============================================================================
# STEP 4: CORE ROUTER - SITE-SPECIFIC POLICY ROUTING
# For: 1100_MTIK-CCR1072-THE_CORE
# ============================================================================
# Purpose: Control which sites use which internet connection for OUTBOUND traffic
# You requested: "specific option but with backup for some sites"
# ============================================================================

# ----------------------------------------------------------------------------
# Define Site Groups by Internet Connection Preference
# ----------------------------------------------------------------------------
/ip firewall address-list

# === Sites using 1012_INTERNET (1Gbps PRIMARY) ===
# These are your high-bandwidth sites
add list=SITES_USE_1012 address=10.11.12.0/24 comment="VLAN1012 - VPS School (primary user)"
add list=SITES_USE_1012 address=192.168.10.0/24 comment="VPS LAN"
add list=SITES_USE_1012 address=192.168.20.0/24 comment="VPS IP Cameras"
add list=SITES_USE_1012 address=192.168.30.0/24 comment="VPS WiFi APs"
add list=SITES_USE_1012 address=192.168.40.0/24 comment="VPS IP Phones"
add list=SITES_USE_1012 address=192.168.50.0/24 comment="VPS WiFi Clients"
add list=SITES_USE_1012 address=192.168.51.0/24 comment="VPS Guest WiFi"
add list=SITES_USE_1012 address=10.11.8.0/24 comment="VCID VPS MCS"

# === Sites using 1000_INTERNET (500Mbps) ===
# VCID Office and related sites
add list=SITES_USE_1000 address=10.11.0.0/24 comment="VCID Office Network"
add list=SITES_USE_1000 address=10.11.9.0/24 comment="VCID related"
add list=SITES_USE_1000 address=10.11.10.0/24 comment="VCID ECHO 2"
add list=SITES_USE_1000 address=10.11.11.0/24 comment="VCID ECHO 2"
add list=SITES_USE_1000 address=10.11.3.0/24 comment="VCID MAST"
add list=SITES_USE_1000 address=10.11.16.0/24 comment="VCID ECHO 1"
add list=SITES_USE_1000 address=10.11.24.0/24 comment="VCID Garage"
add list=SITES_USE_1000 address=10.11.1.0/24 comment="VCID 26 PBS"
add list=SITES_USE_1000 address=10.11.2.0/24 comment="VCID 26PBS Boundary"
add list=SITES_USE_1000 address=192.168.64.0/24 comment="VCID 26PBSA"
add list=SITES_USE_1000 address=192.168.65.0/24 comment="VCID 26PBSB"
add list=SITES_USE_1000 address=192.168.66.0/24 comment="VCID 26PBSC"
add list=SITES_USE_1000 address=192.168.67.0/24 comment="VCID 26PBS WiFi APs"

# === Sites using 1005_INTERNET (50Mbps) ===
# 8KBS and related
add list=SITES_USE_1005 address=10.11.5.0/24 comment="VLAN1005 - 8KBS"
add list=SITES_USE_1005 address=10.20.41.0/24 comment="8KBS Cameras"

# === Sites using VVG_INTERNET (100Mbps OUTBOUND) ===
# VVG Church and low-priority traffic
add list=SITES_USE_VVG address=10.11.6.0/24 comment="VVG Church"
add list=SITES_USE_VVG address=192.168.1.0/24 comment="VVG Church subnet"
add list=SITES_USE_VVG address=10.11.7.0/24 comment="Villa De Vie"
# Add other low-priority sites here

# === Core infrastructure (always use primary 1012) ===
add list=SITES_USE_1012 address=10.11.100.0/24 comment="IDNI CORE NETWORKING"
add list=SITES_USE_1012 address=10.11.101.0/24 comment="IDNI CORE SERVERS (must use 1012 for fastest access)"
add list=SITES_USE_1012 address=10.11.102.0/24 comment="IDNI CORE SERVERS MGMT"

# === VPN users (typically use primary) ===
add list=SITES_USE_1012 address=10.11.253.0/24 comment="VPN Pool"
add list=SITES_USE_1012 address=10.11.254.0/24 comment="VPN Pool"
add list=SITES_USE_1012 address=10.11.255.0/24 comment="VPN Pool"

# ----------------------------------------------------------------------------
# Connection Marking for OUTBOUND Traffic (Site-Specific)
# ----------------------------------------------------------------------------
# ADD these rules to your mangle table (after the inbound rules from Step 2)

/ip firewall mangle

# === Mark NEW outbound connections based on source site ===
# Priority order: Most specific first

# Sites using 1012_INTERNET (1Gbps)
add chain=prerouting action=mark-connection new-connection-mark=CONN_VIA_1012 \
    passthrough=yes connection-state=new \
    src-address-list=SITES_USE_1012 dst-address-list=!Private_Ranges \
    comment="Outbound from sites assigned to 1012_INTERNET"

# Sites using 1000_INTERNET (500Mbps)
add chain=prerouting action=mark-connection new-connection-mark=CONN_VIA_1000 \
    passthrough=yes connection-state=new \
    src-address-list=SITES_USE_1000 dst-address-list=!Private_Ranges \
    comment="Outbound from sites assigned to 1000_INTERNET"

# Sites using 1005_INTERNET (50Mbps)
add chain=prerouting action=mark-connection new-connection-mark=CONN_VIA_1005 \
    passthrough=yes connection-state=new \
    src-address-list=SITES_USE_1005 dst-address-list=!Private_Ranges \
    comment="Outbound from sites assigned to 1005_INTERNET"

# Sites using VVG_INTERNET (100Mbps OUTBOUND)
add chain=prerouting action=mark-connection new-connection-mark=CONN_VIA_VVG \
    passthrough=yes connection-state=new \
    src-address-list=SITES_USE_VVG dst-address-list=!Private_Ranges \
    comment="Outbound from sites assigned to VVG_INTERNET"

# Default: All other sites use primary (1012_INTERNET)
add chain=prerouting action=mark-connection new-connection-mark=CONN_VIA_1012 \
    passthrough=yes connection-state=new \
    src-address=10.11.0.0/16 dst-address-list=!Private_Ranges \
    comment="Default: All other sites use 1012_INTERNET"

# NOTE: The routing marks from Step 2 will automatically apply based on these
# connection marks, so no additional routing mark rules needed here!

# ----------------------------------------------------------------------------
# NAT Configuration for OUTBOUND Traffic
# ----------------------------------------------------------------------------
# Masquerade outbound traffic on each WAN interface
# IMPORTANT: NO srcnat for INBOUND traffic (preserves source IP)

/ip firewall nat
# Remove your existing masquerade rules and replace with these:

# Masquerade outbound traffic per WAN
add chain=srcnat action=masquerade out-interface="VLAN3000 - 1000_INTERNET" \
    comment="Masquerade outbound via 1000_INTERNET (500Mbps)"

add chain=srcnat action=masquerade out-interface="VLAN3002 - 1012_INTERNET" \
    comment="Masquerade outbound via 1012_INTERNET (1Gbps PRIMARY)"

add chain=srcnat action=masquerade out-interface="VLAN3003 - 1005_INTERNET" \
    comment="Masquerade outbound via 1005_INTERNET (50Mbps)"

add chain=srcnat action=masquerade out-interface="VLAN3004 - VVG_INTERNET" \
    comment="Masquerade outbound via VVG_INTERNET (100Mbps)"

# Keep your VPN masquerade rule
add chain=srcnat action=masquerade out-interface=all-ppp src-address=10.11.0.0/16 \
    comment="VPN Masquerade rule"

# CRITICAL: DO NOT add any dstnat rules on the core for inbound traffic!
# Port forwarding happens on the site routers (see next file)

# ----------------------------------------------------------------------------
# Optional: Load Balancing for Unassigned Sites
# ----------------------------------------------------------------------------
# If you want to distribute traffic from sites not specifically assigned:

# Uncomment these if you want load balancing (instead of the default rule above)
# add chain=prerouting action=mark-connection new-connection-mark=CONN_VIA_1012 \
#     passthrough=yes connection-state=new per-connection-classifier=both-addresses:4/0 \
#     src-address=10.11.0.0/16 dst-address-list=!Private_Ranges \
#     comment="Load balance: 25% via 1012"

# add chain=prerouting action=mark-connection new-connection-mark=CONN_VIA_1000 \
#     passthrough=yes connection-state=new per-connection-classifier=both-addresses:4/1 \
#     src-address=10.11.0.0/16 dst-address-list=!Private_Ranges \
#     comment="Load balance: 25% via 1000"

# add chain=prerouting action=mark-connection new-connection-mark=CONN_VIA_VVG \
#     passthrough=yes connection-state=new per-connection-classifier=both-addresses:4/2 \
#     src-address=10.11.0.0/16 dst-address-list=!Private_Ranges \
#     comment="Load balance: 25% via VVG"

# add chain=prerouting action=mark-connection new-connection-mark=CONN_VIA_1005 \
#     passthrough=yes connection-state=new per-connection-classifier=both-addresses:4/3 \
#     src-address=10.11.0.0/16 dst-address-list=!Private_Ranges \
#     comment="Load balance: 25% via 1005"

# ----------------------------------------------------------------------------
# Verification Commands
# ----------------------------------------------------------------------------
# View site assignments:
# /ip firewall address-list print where list~"SITES_USE"

# Test outbound routing for specific site:
# Example: Test from VPS School (10.11.12.1)
# /tool traceroute 8.8.8.8 src-address=10.11.12.1

# View connection marks in action:
# /ip firewall connection print where connection-mark!=no-mark

# Check which sites are generating most traffic per WAN:
# /ip firewall connection print stats where connection-mark=CONN_VIA_1012
# /ip firewall connection print stats where connection-mark=CONN_VIA_1000

# Monitor mangle rule hits:
# /ip firewall mangle print stats where chain=prerouting and action=mark-connection

# Real-time monitoring of specific WAN:
# /tool torch interface="VLAN3002 - 1012_INTERNET"

# ----------------------------------------------------------------------------
# Adjusting Site Assignments
# ----------------------------------------------------------------------------
# To move a site to different internet connection:
# 1. Remove from current address list:
#    /ip firewall address-list remove [find list=SITES_USE_1012 and address=10.11.X.0/24]
# 2. Add to new address list:
#    /ip firewall address-list add list=SITES_USE_1000 address=10.11.X.0/24
# 3. Existing connections continue on old path
# 4. New connections use new path

# Next step: Configure site routers for port forwarding (see next file)
