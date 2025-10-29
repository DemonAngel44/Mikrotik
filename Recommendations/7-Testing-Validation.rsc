# ============================================================================
# STEP 7: TESTING AND VALIDATION PROCEDURES
# For: Complete multi-WAN setup validation
# ============================================================================
# Purpose: Systematically test all aspects of the configuration
# ============================================================================

# ============================================================================
# PRE-DEPLOYMENT CHECKLIST
# ============================================================================

# [ ] Backup all devices
#     /export file=backup-YYYY-MM-DD
#     /system backup save name=backup-YYYY-MM-DD

# [ ] Document current default gateways for all servers
#     On each server: ipconfig /all (Windows) or ip route (Linux)

# [ ] Identify test servers for each internet connection
#     - Server accessible via 1012_INTERNET: 10.11.101.206 (ANPR01)
#     - Server accessible via 1000_INTERNET: <assign one>
#     - Server accessible via 1005_INTERNET: <assign one>

# [ ] Test internet connectivity from each WAN BEFORE making changes
#     From core: /tool traceroute 8.8.8.8 routing-table=main
#     From core: ping 8.8.8.8 routing-table=main

# [ ] Document current CPU usage baseline
#     /system resource print

# [ ] Set up remote access backup (in case you lock yourself out)
#     Keep VPN connection active during deployment

# ============================================================================
# PHASE 1: CORE ROUTER BASIC SETUP (Test Before Moving Forward)
# ============================================================================

# --- Test 1: Verify Interface Lists ---
/interface list member print
# Expected: See all 4 WAN interfaces in WAN_ALL
# Expected: See all internal VLANs in LAN_ALL

# --- Test 2: Verify VVG Internet VLAN ---
/interface vlan print where name~"VVG"
/ip address print where interface~"VVG"
# Expected: VLAN3004 - VVG_INTERNET with IP 192.168.254.2/30

# --- Test 3: Verify Address Lists ---
/ip firewall address-list print where list=PUBLIC_SERVERS
# Expected: See server IPs (10.11.101.206, etc.)

/ip firewall address-list print where list~"SITES_USE"
# Expected: See site assignments to different internet connections

# --- Test 4: Test Connectivity to All Gateways ---
:put "Testing gateway connectivity..."
:put "1012_INTERNET (10.10.2.1):"
/ping 10.10.2.1 count=5
:put "1000_INTERNET (10.10.0.1):"
/ping 10.10.0.1 count=5
:put "1005_INTERNET (10.10.3.1):"
/ping 10.10.3.1 count=5
:put "VVG_INTERNET (192.168.254.1):"
/ping 192.168.254.1 count=5

# All should respond. If not, fix physical connectivity first!

# ============================================================================
# PHASE 2: ROUTING TABLE VALIDATION
# ============================================================================

# --- Test 5: Verify Routing Tables Exist ---
/routing table print
# Expected: See InternetVia1000, InternetVia1012, InternetVia1005, InternetVia_VVG

# --- Test 6: Verify Default Routes in Each Table ---
/ip route print where dst-address=0.0.0.0/0
# Expected: See default routes for each routing table with check-gateway=ping

# --- Test 7: Test Routing from Each Table ---
:put "Testing routing via 1012_INTERNET:"
/tool traceroute 8.8.8.8 routing-table=InternetVia1012 count=1

:put "Testing routing via 1000_INTERNET:"
/tool traceroute 8.8.8.8 routing-table=InternetVia1000 count=1

:put "Testing routing via 1005_INTERNET:"
/tool traceroute 8.8.8.8 routing-table=InternetVia1005 count=1

:put "Testing routing via VVG_INTERNET:"
/tool traceroute 8.8.8.8 routing-table=InternetVia_VVG count=1

# All should reach internet (first hop should be the correct gateway)

# --- Test 8: Verify Internal Routes in All Tables ---
/ip route print where routing-table=InternetVia1012 and dst-address~"10.11"
# Expected: See internal routes copied to this table
# Repeat for other tables

# ============================================================================
# PHASE 3: CONNECTION AND ROUTING MARK VALIDATION
# ============================================================================

# --- Test 9: Verify Mangle Rules Exist ---
/ip firewall mangle print where chain=prerouting
# Expected: See connection marking rules for inbound and outbound
# Expected: See routing marking rules based on connection marks

/ip firewall mangle print where chain=output
# Expected: See routing marking rules for router-originated traffic

# --- Test 10: Simulate Inbound Connection ---
# Before testing from real internet, simulate locally

# On a test machine in VLAN1012 (192.168.10.x):
# Try to SSH to core router: ssh admin@10.11.100.250

# On core, check connections:
/ip firewall connection print where dst-address=10.11.100.250
# Look for your test connection
# NOTE: This won't show connection mark yet since it's not coming from WAN

# --- Test 11: Check Mangle Rule Statistics ---
/ip firewall mangle print stats where chain=prerouting and action=mark-connection
# Hit counts should be 0 before real traffic arrives
# Will increment when actual traffic flows

# ============================================================================
# PHASE 4: SITE ROUTER PORT FORWARDING TEST
# ============================================================================

# --- Test 12: Verify Site Router Port Forwards (ON SITE ROUTER) ---
# On 1012_INTERNET site router:
/ip firewall nat print where chain=dstnat
# Expected: See dstnat rules forwarding to 10.10.2.2 (core)

/ip firewall nat print where chain=srcnat
# Expected: See masquerade ONLY for local router traffic (10.10.2.0/30)
# Should NOT see masquerade for all traffic!

# --- Test 13: Verify Site Router Routing (ON SITE ROUTER) ---
# On 1012_INTERNET site router:
/ip route print where dst-address=10.11.0.0/16
# Expected: Route to 10.11.0.0/16 via 10.10.2.2 (core)

# --- Test 14: Test Site Router to Core Connectivity ---
# On 1012_INTERNET site router:
/ping 10.10.2.2 count=5
# Expected: Core responds

/ping 10.11.101.206 count=5
# Expected: Server responds (routed via core)

# ============================================================================
# PHASE 5: SERVER CONFIGURATION
# ============================================================================

# --- Test 15: Verify Server Default Gateway ---
# On each server (10.11.101.x):
# Windows: ipconfig /all
# Linux: ip route show default

# Expected: Default gateway is 10.11.101.250 (core router)
# If not, change it!

# Windows:
# netsh interface ip set address "Ethernet" static 10.11.101.206 255.255.255.0 10.11.101.250

# Linux:
# ip route add default via 10.11.101.250

# --- Test 16: Test Server to Core Connectivity ---
# On server:
# ping 10.11.101.250 (core)
# ping 8.8.8.8 (internet via core)

# Both should work

# ============================================================================
# PHASE 6: END-TO-END INBOUND CONNECTION TEST
# ============================================================================

# --- Test 17: Test Inbound Connection from Internet ---
# From external internet connection (not from your network):

# 1. Find public IP of 1012_INTERNET connection
#    On site router: /ip address print where interface=ether1

# 2. From external location, connect to that public IP on forwarded port
#    Example: ssh to <public-ip>:22
#    Or: telnet <public-ip> 80

# 3. On SITE ROUTER, check connection:
/ip firewall connection print where dst-address~"10.10.2"
# Look for connection from internet IP to 10.10.2.2 (core)
# CRITICAL: src-address should be the REAL internet IP, not 10.10.2.1!
# If you see src=10.10.2.1, there's unwanted srcnat happening

# 4. On CORE ROUTER, check connection:
/ip firewall connection print where dst-address~"10.11.101"
# Look for connection from internet IP to server IP
# Check connection-mark: Should be CONN_VIA_1012
# Example: 8.8.8.8:12345 -> 10.11.101.206:22 mark:CONN_VIA_1012

# 5. Check routing mark:
/ip firewall mangle print stats where new-routing-mark=InternetVia1012
# Should show packets hitting the routing mark rule

# 6. On SERVER, check connection:
# Windows: netstat -an | findstr 22
# Linux: ss -tn | grep 22
# Should see connection from real internet IP

# 7. Verify return path (CRITICAL TEST!)
# On CORE ROUTER, monitor traffic:
/tool torch interface="VLAN3002 - 1012_INTERNET"
# Should see BOTH inbound and outbound traffic for the connection
# Outbound traffic should be replies going back to internet client

# If replies are going out different interface, routing mark isn't working!

# --- Test 18: Test from Each WAN Connection ---
# Repeat Test 17 for:
# - 1000_INTERNET connection
# - 1005_INTERNET connection
# Each should show correct connection mark and return path

# ============================================================================
# PHASE 7: OUTBOUND CONNECTION TEST (SITE-SPECIFIC ROUTING)
# ============================================================================

# --- Test 19: Test Outbound from Assigned Sites ---

# From a PC in VLAN1012 (should use 1012_INTERNET):
# Visit: https://www.whatismyip.com
# Expected: Shows public IP of 1012_INTERNET connection

# On core router, verify:
/ip firewall connection print where src-address~"192.168.10" and dst-port=443
# Check connection-mark: Should be CONN_VIA_1012

# Repeat for other sites:
# - From VLAN1000 site: Should show 1000_INTERNET public IP
# - From VLAN1005 site: Should show 1005_INTERNET public IP
# - From VVG site: Should show VVG_INTERNET public IP

# --- Test 20: Monitor Mangle Rule Hits ---
/ip firewall mangle print stats where action=mark-connection
# All site-specific rules should show hits from their assigned sites

# ============================================================================
# PHASE 8: FAILOVER TESTING
# ============================================================================

# --- Test 21: Test Gateway Failover ---

# Establish connections through 1012_INTERNET
# On site router or upstream, block traffic to simulate failure:
# /ip firewall filter add chain=output dst-address=10.10.2.1 action=drop

# On core router, watch netwatch:
/tool netwatch print
# Should show 1012_INTERNET gateway as DOWN

# Check routes:
/ip route print where routing-table=InternetVia1012 and dst-address=0.0.0.0/0
# Distance=1 route should be inactive (DAc flag)
# Distance=2 route should be active (AS flag)

# Test connectivity:
/ping 8.8.8.8 routing-table=InternetVia1012 count=5
# Should still work via failover gateway

# Remove the test block:
# /ip firewall filter remove [find dst-address=10.10.2.1]

# Verify gateway comes back UP
/tool netwatch print

# --- Test 22: Test Complete WAN Failure ---
# Disconnect physical cable from 1012_INTERNET site router

# Existing connections should failover to backup WAN
# New connections from VLAN1012 sites should use backup WAN

# Monitor on core:
/ip firewall mangle print stats where new-connection-mark=CONN_VIA_1012
# Hit count should stop incrementing

# Alternative backup connection mark should start incrementing
# (depending on your failover design)

# Reconnect cable and verify recovery

# ============================================================================
# PHASE 9: PERFORMANCE VALIDATION
# ============================================================================

# --- Test 23: Verify Fasttrack is Working ---
/ip firewall filter print stats where action=fasttrack-connection
# After some traffic flows, hit count should be HIGH
# If 0, fasttrack isn't working - check rules

# --- Test 24: Monitor CPU Usage Under Load ---
# Generate traffic (use iperf or large file transfers)
# On core:
/system resource print
# CPU should stay low (<5%) even with multi-gigabit traffic

# Check per-core usage:
/system resource cpu print
# Should show load distributed across cores

# --- Test 25: Test Maximum Throughput ---
# Use iperf3 between site and server:
# Server: iperf3 -s
# Client: iperf3 -c 10.11.101.206 -t 60 -P 10

# Monitor on core:
/interface monitor-traffic interface="VLAN3002 - 1012_INTERNET"
# Should see high throughput with low CPU

# ============================================================================
# PHASE 10: MONITORING AND VALIDATION SCRIPTS
# ============================================================================

# --- Create Monitoring Script on Core ---
/system script
add name=check-wan-status source={
    :put "=== WAN Connection Status ==="
    :put ""
    :foreach gw in={10.10.2.1;10.10.0.1;10.10.3.1;192.168.254.1} do={
        :local gwName
        :if ($gw = "10.10.2.1") do={ :set gwName "1012_INTERNET (1Gbps)" }
        :if ($gw = "10.10.0.1") do={ :set gwName "1000_INTERNET (500Mbps)" }
        :if ($gw = "10.10.3.1") do={ :set gwName "1005_INTERNET (50Mbps)" }
        :if ($gw = "192.168.254.1") do={ :set gwName "VVG_INTERNET (100Mbps)" }

        :local result [/ping $gw count=3]
        :if ($result > 0) do={
            :put "$gwName: UP"
        } else={
            :put "$gwName: DOWN"
        }
    }
    :put ""
    :put "=== Connection Marks ==="
    :put ("CONN_VIA_1012: " . [:len [/ip firewall connection find connection-mark=CONN_VIA_1012]])
    :put ("CONN_VIA_1000: " . [:len [/ip firewall connection find connection-mark=CONN_VIA_1000]])
    :put ("CONN_VIA_1005: " . [:len [/ip firewall connection find connection-mark=CONN_VIA_1005]])
    :put ("CONN_VIA_VVG: " . [:len [/ip firewall connection find connection-mark=CONN_VIA_VVG]])
}

# Run monitoring script:
/system script run check-wan-status

# --- Create Validation Script for Return Path Routing ---
/system script
add name=validate-return-path source={
    :put "=== Return Path Routing Validation ==="
    :put ""
    :put "Connections via 1012_INTERNET that should return via same path:"
    /ip firewall connection print where connection-mark=CONN_VIA_1012 and dst-address~"10.11.101"
    :put ""
    :put "Mangle stats for routing marks:"
    /ip firewall mangle print stats where action=mark-routing and new-routing-mark~"InternetVia"
}

# Run validation script:
/system script run validate-return-path

# ============================================================================
# TROUBLESHOOTING GUIDE
# ============================================================================

# Problem: Inbound connections fail
# Check:
# 1. Port forward on site router: /ip firewall nat print
# 2. Connection reaches core: /ip firewall connection print where dst-address~"10.11.101"
# 3. Server default gateway points to core
# 4. Firewall allows traffic: /ip firewall filter print stats

# Problem: Replies go out wrong interface
# Check:
# 1. Connection has correct mark: /ip firewall connection print where connection-mark!=no-mark
# 2. Routing mark is applied: /ip firewall mangle print stats
# 3. Routing table has correct default route: /ip route print
# 4. Site router has NO srcnat for forwarded traffic

# Problem: Source IP not preserved
# Check:
# 1. Site router NAT: Should see real client IP, not site router IP
# 2. No srcnat on site router except for local traffic
# 3. On core: /ip firewall connection print - src should be real client IP

# Problem: Outbound from wrong WAN
# Check:
# 1. Site in correct address list: /ip firewall address-list print
# 2. Connection mark rules hit: /ip firewall mangle print stats
# 3. Routing mark applied: /ip firewall mangle print stats

# Problem: Failover not working
# Check:
# 1. check-gateway=ping on routes: /ip route print detail
# 2. Netwatch status: /tool netwatch print
# 3. Backup routes exist with higher distance

# Problem: Poor performance
# Check:
# 1. Fasttrack working: /ip firewall filter print stats where action=fasttrack
# 2. CPU usage: /system resource print
# 3. Connection tracking: /ip firewall connection tracking print
# 4. Interface errors: /interface print stats

# ============================================================================
# SUCCESS CRITERIA
# ============================================================================

# Configuration is successful when:
# [√] All 4 WAN connections show UP in monitoring
# [√] Inbound connections preserve source IP
# [√] Return path matches inbound path (asymmetric routing solved)
# [√] Sites use assigned internet connections for outbound
# [√] Failover works when WAN goes down
# [√] CPU usage stays low (<5% under load)
# [√] Fasttrack shows high hit counts
# [√] No firewall drops for legitimate traffic
# [√] Throughput approaches line speed
# [√] Latency remains low (<1ms added by routing)

# ============================================================================
# POST-DEPLOYMENT
# ============================================================================

# [ ] Document final configuration
# [ ] Update network diagram
# [ ] Create runbook for common operations
# [ ] Schedule regular monitoring checks
# [ ] Set up alerts for WAN failures
# [ ] Train team on troubleshooting procedures
# [ ] Schedule review in 30 days

# ============================================================================
# END OF TESTING AND VALIDATION
# ============================================================================
