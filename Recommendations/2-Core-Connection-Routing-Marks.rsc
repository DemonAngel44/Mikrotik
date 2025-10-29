# ============================================================================
# STEP 2: CORE ROUTER - CONNECTION AND ROUTING MARKS
# For: 1100_MTIK-CCR1072-THE_CORE
# ============================================================================
# Purpose: Mark connections by entry point to ensure return path routing
# This is THE KEY to solving your asymmetric routing issue!
# ============================================================================

# CRITICAL CONCEPT:
# When client connects via 1000_INTERNET:
#   1. Connection is marked with CONN_VIA_1000
#   2. All packets in that connection get routing mark RT_VIA_1000
#   3. Routing mark forces replies to use InternetVia1000 routing table
#   4. InternetVia1000 routing table sends traffic to 10.10.0.1 (1000 gateway)
#   5. Reply goes back through same path: Server → Core → 1000 → Client ✓

# ----------------------------------------------------------------------------
# CLEAR EXISTING MANGLE RULES (BACKUP FIRST!)
# ----------------------------------------------------------------------------
# BEFORE running this, backup your current mangle:
# /export file=mangle-backup
# Then clear existing mangle rules related to routing:
# /ip firewall mangle remove [find comment~"Internet Routing"]
# /ip firewall mangle remove [find chain=prerouting and action~"mark"]

# ----------------------------------------------------------------------------
# CONNECTION MARKING - Track Which WAN Interface Traffic Arrived On
# ----------------------------------------------------------------------------
/ip firewall mangle

# === STEP 1: Mark INBOUND connections (from internet to servers) ===
# These rules identify which WAN interface a connection originated from

add chain=prerouting action=mark-connection new-connection-mark=CONN_VIA_1000 \
    passthrough=yes in-interface="VLAN3000 - 1000_INTERNET" \
    connection-state=new dst-address-list=PUBLIC_SERVERS \
    comment="Mark inbound connections via 1000_INTERNET (500Mbps)"

add chain=prerouting action=mark-connection new-connection-mark=CONN_VIA_1012 \
    passthrough=yes in-interface="VLAN3002 - 1012_INTERNET" \
    connection-state=new dst-address-list=PUBLIC_SERVERS \
    comment="Mark inbound connections via 1012_INTERNET (1Gbps PRIMARY)"

add chain=prerouting action=mark-connection new-connection-mark=CONN_VIA_1005 \
    passthrough=yes in-interface="VLAN3003 - 1005_INTERNET" \
    connection-state=new dst-address-list=PUBLIC_SERVERS \
    comment="Mark inbound connections via 1005_INTERNET (50Mbps)"

# VVG has no port forwarding, so no inbound marking needed

# === STEP 2: Mark OUTBOUND connections based on source site policy ===
# These rules will be added in Step 3 (policy routing) based on site assignments

# ----------------------------------------------------------------------------
# ROUTING MARKING - Apply Routing Tables Based on Connection Marks
# ----------------------------------------------------------------------------
# This ensures ALL packets in a connection use the correct routing table

# === Apply routing marks in PREROUTING chain (for forwarded traffic) ===
add chain=prerouting action=mark-routing new-routing-mark=InternetVia1000 \
    passthrough=no connection-mark=CONN_VIA_1000 \
    comment="Route all traffic in this connection via 1000_INTERNET"

add chain=prerouting action=mark-routing new-routing-mark=InternetVia1012 \
    passthrough=no connection-mark=CONN_VIA_1012 \
    comment="Route all traffic in this connection via 1012_INTERNET"

add chain=prerouting action=mark-routing new-routing-mark=InternetVia1005 \
    passthrough=no connection-mark=CONN_VIA_1005 \
    comment="Route all traffic in this connection via 1005_INTERNET"

add chain=prerouting action=mark-routing new-routing-mark=InternetVia_VVG \
    passthrough=no connection-mark=CONN_VIA_VVG \
    comment="Route all traffic in this connection via VVG_INTERNET"

# === Apply routing marks in OUTPUT chain (for router-originated traffic) ===
# This handles cases where the router itself responds to connections
add chain=output action=mark-routing new-routing-mark=InternetVia1000 \
    passthrough=no connection-mark=CONN_VIA_1000 \
    comment="Route router-originated replies via 1000_INTERNET"

add chain=output action=mark-routing new-routing-mark=InternetVia1012 \
    passthrough=no connection-mark=CONN_VIA_1012 \
    comment="Route router-originated replies via 1012_INTERNET"

add chain=output action=mark-routing new-routing-mark=InternetVia1005 \
    passthrough=no connection-mark=CONN_VIA_1005 \
    comment="Route router-originated replies via 1005_INTERNET"

add chain=output action=mark-routing new-routing-mark=InternetVia_VVG \
    passthrough=no connection-mark=CONN_VIA_VVG \
    comment="Route router-originated replies via VVG_INTERNET"

# ----------------------------------------------------------------------------
# IMPORTANT NOTES
# ----------------------------------------------------------------------------
# 1. passthrough=no on routing marks means the packet won't be processed by
#    further mangle rules - this is intentional for performance
#
# 2. Connection marks persist for the entire connection lifetime
#    - Once marked, all packets (both directions) use the same path
#
# 3. dst-address-list=PUBLIC_SERVERS ensures we only mark connections
#    destined for your servers, not random inbound traffic
#
# 4. The order matters:
#    - First mark the connection (connection-mark)
#    - Then apply routing based on that mark (routing-mark)
#
# 5. These rules work for BOTH:
#    - Server replies to inbound connections
#    - Server-initiated outbound connections

# ----------------------------------------------------------------------------
# Verification Commands
# ----------------------------------------------------------------------------
# View connections with marks:
# /ip firewall connection print where connection-mark!=no-mark

# View mangle rule statistics (shows hit count):
# /ip firewall mangle print stats where chain=prerouting

# Test connection from internet:
# After port forward is configured, connect from external client
# Then: /ip firewall connection print where dst-address=10.11.101.206
# Look for: connection-mark=CONN_VIA_XXXX

# Monitor routing mark application:
# /tool torch src-address=10.11.101.206
# Should show traffic exiting via the correct WAN interface

# Next step: Configure routing tables (see next file)
