# ============================================================================
# STEP 3: CORE ROUTER - ROUTING TABLES WITH FAILOVER
# For: 1100_MTIK-CCR1072-THE_CORE
# ============================================================================
# Purpose: Configure routing tables for each WAN with automatic failover
# ============================================================================

# ----------------------------------------------------------------------------
# Create Routing Tables (if not already exist)
# ----------------------------------------------------------------------------
/routing table
# These already exist in your config, but here for reference:
# add name=InternetVia1000 fib comment="Route via 1000_INTERNET (500Mbps)"
# add name=InternetVia1012 fib comment="Route via 1012_INTERNET (1Gbps PRIMARY)"
# add name=InternetVia1005 fib comment="Route via 1005_INTERNET (50Mbps)"
# add name=InternetVia_VVG fib comment="Route via VVG_INTERNET (100Mbps OUTBOUND)"

# Create VVG table if it doesn't exist:
add name=InternetVia_VVG fib comment="Route via VVG_INTERNET (100Mbps OUTBOUND)"

# ----------------------------------------------------------------------------
# CRITICAL: Internal Routes Must Exist in ALL Routing Tables
# ----------------------------------------------------------------------------
# Without these, servers can't reach each other when using alternate routing tables!

# Define your internal supernet
/ip route
# Add connected routes to all custom routing tables
add dst-address=10.11.0.0/16 type=blackhole distance=255 \
    routing-table=InternetVia1000 comment="Internal networks base route"
add dst-address=10.11.0.0/16 type=blackhole distance=255 \
    routing-table=InternetVia1012 comment="Internal networks base route"
add dst-address=10.11.0.0/16 type=blackhole distance=255 \
    routing-table=InternetVia1005 comment="Internal networks base route"
add dst-address=10.11.0.0/16 type=blackhole distance=255 \
    routing-table=InternetVia_VVG comment="Internal networks base route"

# Copy ALL your specific internal routes to each routing table
# Example: If you have routes like "add dst-address=10.11.5.0/24 gateway=10.11.100.149"
# You need to add them to EACH routing table:

# Template (repeat for each routing table):
# add dst-address=10.11.5.0/24 gateway=10.11.100.149 distance=120 routing-table=InternetVia1000
# add dst-address=10.11.5.0/24 gateway=10.11.100.149 distance=120 routing-table=InternetVia1012
# add dst-address=10.11.5.0/24 gateway=10.11.100.149 distance=120 routing-table=InternetVia1005
# add dst-address=10.11.5.0/24 gateway=10.11.100.149 distance=120 routing-table=InternetVia_VVG

# AUTO-GENERATE SCRIPT (run this to copy all internal routes to all tables):
:local routingTables {"InternetVia1000";"InternetVia1012";"InternetVia1005";"InternetVia_VVG"}
:foreach table in=$routingTables do={
    :foreach route in=[/ip route find where dst-address~"^10\\.11\\." and routing-table=main] do={
        :local dstAddr [/ip route get $route dst-address]
        :local gw [/ip route get $route gateway]
        :local dist [/ip route get $route distance]
        /ip route add dst-address=$dstAddr gateway=$gw distance=$dist routing-table=$table comment="Auto-copied from main"
    }
}

# ----------------------------------------------------------------------------
# Default Routes with Failover (Using Recursive Gateway Checks)
# ----------------------------------------------------------------------------

# === PRIMARY: 1012_INTERNET (1Gbps) - Main default route ===
/ip route
add dst-address=0.0.0.0/0 gateway=10.10.2.1 distance=1 \
    routing-table=InternetVia1012 check-gateway=ping \
    comment="Primary: 1012_INTERNET (1Gbps) with health check"

# Failover to 1000 if 1012 fails
add dst-address=0.0.0.0/0 gateway=10.10.0.1 distance=2 \
    routing-table=InternetVia1012 check-gateway=ping \
    comment="Failover: Use 1000_INTERNET if 1012 fails"

# === 1000_INTERNET (500Mbps) ===
add dst-address=0.0.0.0/0 gateway=10.10.0.1 distance=1 \
    routing-table=InternetVia1000 check-gateway=ping \
    comment="Primary: 1000_INTERNET (500Mbps) with health check"

# Failover to 1012 if 1000 fails
add dst-address=0.0.0.0/0 gateway=10.10.2.1 distance=2 \
    routing-table=InternetVia1000 check-gateway=ping \
    comment="Failover: Use 1012_INTERNET if 1000 fails"

# === 1005_INTERNET (50Mbps) ===
add dst-address=0.0.0.0/0 gateway=10.10.3.1 distance=1 \
    routing-table=InternetVia1005 check-gateway=ping \
    comment="Primary: 1005_INTERNET (50Mbps) with health check"

# Failover to 1012 if 1005 fails
add dst-address=0.0.0.0/0 gateway=10.10.2.1 distance=2 \
    routing-table=InternetVia1005 check-gateway=ping \
    comment="Failover: Use 1012_INTERNET if 1005 fails"

# === VVG_INTERNET (100Mbps) - Outbound only ===
add dst-address=0.0.0.0/0 gateway=192.168.254.1 distance=1 \
    routing-table=InternetVia_VVG check-gateway=ping \
    comment="Primary: VVG_INTERNET (100Mbps OUTBOUND) with health check"

# Failover to 1012 if VVG fails
add dst-address=0.0.0.0/0 gateway=10.10.2.1 distance=2 \
    routing-table=InternetVia_VVG check-gateway=ping \
    comment="Failover: Use 1012_INTERNET if VVG fails"

# === MAIN routing table default route ===
# This is for traffic without any routing mark (general internet access)
add dst-address=0.0.0.0/0 gateway=10.10.2.1 distance=1 \
    routing-table=main check-gateway=ping \
    comment="Main table: Primary via 1012_INTERNET (1Gbps)"

# Main table failover cascade
add dst-address=0.0.0.0/0 gateway=10.10.0.1 distance=2 \
    routing-table=main check-gateway=ping \
    comment="Main table: Failover to 1000_INTERNET (500Mbps)"

add dst-address=0.0.0.0/0 gateway=192.168.254.1 distance=3 \
    routing-table=main check-gateway=ping \
    comment="Main table: Failover to VVG_INTERNET (100Mbps)"

add dst-address=0.0.0.0/0 gateway=10.10.3.1 distance=4 \
    routing-table=main check-gateway=ping \
    comment="Main table: Last resort via 1005_INTERNET (50Mbps)"

# ----------------------------------------------------------------------------
# NetWatch for Additional Monitoring (Optional but Recommended)
# ----------------------------------------------------------------------------
# Monitor gateway connectivity and log failures

/tool netwatch
add host=10.10.2.1 interval=10s timeout=5s \
    comment="Monitor 1012_INTERNET gateway" \
    up-script="/log info \"1012_INTERNET gateway UP\"" \
    down-script="/log error \"1012_INTERNET gateway DOWN - failover active\""

add host=10.10.0.1 interval=10s timeout=5s \
    comment="Monitor 1000_INTERNET gateway" \
    up-script="/log info \"1000_INTERNET gateway UP\"" \
    down-script="/log error \"1000_INTERNET gateway DOWN - failover active\""

add host=10.10.3.1 interval=10s timeout=5s \
    comment="Monitor 1005_INTERNET gateway" \
    up-script="/log info \"1005_INTERNET gateway UP\"" \
    down-script="/log error \"1005_INTERNET gateway DOWN - failover active\""

add host=192.168.254.1 interval=10s timeout=5s \
    comment="Monitor VVG_INTERNET gateway" \
    up-script="/log info \"VVG_INTERNET gateway UP\"" \
    down-script="/log error \"VVG_INTERNET gateway DOWN - failover active\""

# Test internet connectivity through each gateway
add host=8.8.8.8 interval=30s timeout=5s \
    comment="Monitor internet connectivity via main table" \
    down-script="/log error \"Internet connectivity DOWN on main routing table\""

# ----------------------------------------------------------------------------
# REMOVE OLD CONFLICTING ROUTES
# ----------------------------------------------------------------------------
# Your current config has many old routes that may conflict
# Before applying this, identify and remove:

# Find routes that might conflict:
# /ip route print where dst-address=0.0.0.0/0
# /ip route print where routing-table=InternetVia1000
# /ip route print where routing-table=InternetVia1012
# /ip route print where routing-table=InternetVia1005

# Remove old default routes in custom tables (backup first!):
# /ip route remove [find dst-address=0.0.0.0/0 and routing-table=InternetVia1000 and distance=151]
# /ip route remove [find dst-address=0.0.0.0/0 and routing-table=InternetVia1012 and distance=149]
# etc...

# ----------------------------------------------------------------------------
# Verification Commands
# ----------------------------------------------------------------------------
# View routing tables:
# /ip route print where routing-table!=main
# /ip route print where dst-address=0.0.0.0/0

# Test specific routing table:
# /ip route print where routing-table=InternetVia1012

# Check route status (active/inactive based on check-gateway):
# /ip route print detail where check-gateway=ping

# Test routing from specific source:
# /tool traceroute 8.8.8.8 routing-table=InternetVia1000

# Monitor netwatch status:
# /tool netwatch print

# Next step: Configure site-specific outbound policy routing (see next file)
