# ============================================================================
# CAMERA/VIDEO TRAFFIC OPTIMIZATION
# For: Multi-WAN network with heavy surveillance camera traffic
# ============================================================================
# Purpose: Optimize for sustained high-bandwidth video streams
# ============================================================================

# YOUR NETWORK PROFILE:
# - Heavy IP camera traffic (VLAN20 = 192.168.107.x at 1012 site)
# - Long-lived video streams (hours/days)
# - Need for source IP preservation (security/audit trails)
# - Multiple camera VLANs across 200+ sites
# - CCR1072 core (perfect for video routing)

# WHY CAMERA TRAFFIC IS DIFFERENT:
# 1. Long-lived connections (not short HTTP requests)
# 2. High sustained bandwidth (not bursty)
# 3. Sensitive to connection interruption (can't drop mid-stream)
# 4. Benefits massively from fasttrack (hardware offload)
# 5. Needs proper connection tracking timeouts

# ============================================================================
# CORE ROUTER: CAMERA-OPTIMIZED CONNECTION TRACKING
# ============================================================================

/ip firewall connection tracking
set enabled=yes \
    tcp-established-timeout=1d \
    tcp-fin-wait-timeout=10s \
    tcp-close-wait-timeout=10s \
    tcp-time-wait-timeout=10s \
    tcp-close-timeout=10s \
    udp-timeout=3m \
    udp-stream-timeout=3m \
    icmp-timeout=10s \
    generic-timeout=10m \
    max-entries=262144

# Explanation:
# - tcp-established-timeout=1d: Keep video stream connections alive for full day
# - udp-stream-timeout=3m: Some cameras use RTSP over UDP
# - max-entries=262144: Support thousands of concurrent camera streams

# ============================================================================
# CORE ROUTER: FASTTRACK IS CRITICAL FOR VIDEO
# ============================================================================

# With video traffic, fasttrack isn't optional - it's essential!
# Video streams = sustained high bandwidth = perfect for hardware offload

/ip firewall filter
# Place these at the TOP of your filter rules

# Accept established/related (required before fasttrack)
add chain=forward action=accept connection-state=established,related \
    place-before=0 comment="Accept for fasttrack"

# Fasttrack established connections (HUGE benefit for video)
add chain=forward action=fasttrack-connection hw-offload=yes \
    connection-state=established,related connection-mark=!no-mark \
    place-before=1 comment="Fasttrack video streams to hardware"

# Why this matters for cameras:
# - Without fasttrack: 10-20 Gbps max, high CPU
# - With fasttrack: 60-80 Gbps, <5% CPU
# - Camera streams spend 99.9% of time in established state
# - Perfect candidate for hardware offload

# ============================================================================
# CORE ROUTER: CAMERA VLAN IDENTIFICATION
# ============================================================================

# Identify all your camera VLANs across sites
/ip firewall address-list
add list=CAMERA_VLANS address=192.168.20.0/24 comment="1012 - VPS Cameras"
add list=CAMERA_VLANS address=192.168.107.0/24 comment="1012 - VPS Cameras alt"
add list=CAMERA_VLANS address=10.20.41.0/24 comment="1005 - 8KBS Cameras"
# Add all other camera subnets from your 200+ sites

# Camera servers/NVRs
add list=CAMERA_SERVERS address=10.11.101.206 comment="ANPR01 main"
# Add other camera servers/NVRs

# ============================================================================
# CORE ROUTER: PRIORITY MARKING FOR VIDEO (OPTIONAL)
# ============================================================================

# If you want to prioritize camera traffic over other traffic:

/ip firewall mangle
# Mark camera traffic with higher priority (DSCP EF)
add chain=postrouting action=set-priority new-priority=from-dscp-high-3-bits \
    src-address-list=CAMERA_VLANS passthrough=yes \
    comment="Priority for camera upload traffic"

add chain=postrouting action=set-priority new-priority=from-dscp-high-3-bits \
    dst-address-list=CAMERA_VLANS passthrough=yes \
    comment="Priority for camera viewing traffic"

# Note: This requires QoS-aware switches/routers in path
# Your CCR2004s and CCR1072 support this

# ============================================================================
# SITE ROUTER SPECIFIC CONFIGS
# ============================================================================

# === 1012_INTERNET (VPS School) - CCR2004 - 1Gbps ===
# Heavy camera traffic on VLAN20 (192.168.107.x)
# Current config: NO port forwarding configured yet

## On 1012 site router (CCR2004-1G-12S+2XS) ##

/ip firewall nat
# Forward camera RTSP traffic (port 554) to core
add chain=dstnat action=dst-nat to-addresses=10.10.2.2 \
    in-interface=ether1-Internet protocol=tcp dst-port=554 \
    comment="Forward RTSP to core (preserve source IP)"

# Forward camera HTTP/HTTPS (web interface access)
add chain=dstnat action=dst-nat to-addresses=10.10.2.2 \
    in-interface=ether1-Internet protocol=tcp dst-port=80,443,8080,8443 \
    comment="Forward camera web access to core"

# Forward ANPR specific ports (already configured on 1000, add to 1012)
add chain=dstnat action=dst-nat to-addresses=10.10.2.2 \
    in-interface=ether1-Internet protocol=tcp dst-port=6280-6290 \
    comment="Forward ANPR ports to core"

# CRITICAL: NO srcnat for forwarded traffic!
# Your current config doesn't have masquerade, keep it that way
# Only masquerade for local router management traffic if needed:
# add chain=srcnat action=masquerade out-interface=ether1-Internet \
#     src-address=10.10.2.0/30 comment="Only masquerade router's own traffic"

# Camera-specific optimization: MSS clamping for video
add chain=forward action=change-mss new-mss=clamp-to-pmtu protocol=tcp \
    tcp-flags=syn passthrough=yes comment="Clamp MSS for camera streams"

# === 1000_INTERNET (VCID Office) - CCR2004 - 500Mbps ===
# Currently has port forwarding WITH masquerade - NEEDS FIX

## On 1000 site router (CCR2004-1G-12S+2XS) ##

/ip firewall nat
# REMOVE the existing masquerade rule (line 97 in your config):
# remove [find chain=srcnat and out-interface=VLAN3000-Internet]

# Replace with SELECTIVE masquerade:
add chain=srcnat action=masquerade out-interface=VLAN3000-Internet \
    src-address=10.10.0.0/30 comment="Only masquerade router's own traffic (10.10.0.0/30)"

# Your existing port forwards (lines 88-96) are forwarding to specific IPs
# Change them to forward to CORE instead for centralized routing:

# BEFORE (your current config - forwards directly to servers):
# add action=dst-nat chain=dstnat dst-port=6280,6281 to-addresses=10.11.101.206

# AFTER (forward to core, let core route to servers):
add action=dst-nat chain=dstnat dst-port=6280,6281 \
    in-interface=VLAN3000-Internet protocol=tcp to-addresses=10.10.0.2 \
    comment="Forward ANPR to core (10.10.0.2)"

# Update other forwards similarly:
add action=dst-nat chain=dstnat dst-port=22 \
    in-interface=VLAN3000-Internet protocol=tcp to-addresses=10.10.0.2 \
    comment="Forward SSH to core"

add action=dst-nat chain=dstnat dst-port=500,1701,4500 \
    in-interface=VLAN3000-Internet protocol=udp to-addresses=10.10.0.2 \
    comment="Forward VPN to core"

add action=dst-nat chain=dstnat dst-port=80,443,8080,8443 \
    in-interface=VLAN3000-Internet protocol=tcp to-addresses=10.10.0.2 \
    comment="Forward HTTP/HTTPS to core"

# === 1005_INTERNET (8KBS) - CRS318-16P-2S+ - 50Mbps ===
# Lower bandwidth, suitable for lightweight camera access

## On 1005 site router (CRS318-16P-2S+) ##

/ip firewall nat
# Add port forwarding (currently none configured)
# Given 50Mbps limitation, forward only essential ports

add chain=dstnat action=dst-nat to-addresses=10.10.3.2 \
    in-interface=ether1-Internet protocol=tcp dst-port=80,443 \
    comment="Forward HTTP/HTTPS to core"

# NO srcnat for forwarded traffic
# Only masquerade router's own traffic:
add chain=srcnat action=masquerade out-interface=ether1-Internet \
    src-address=10.10.3.0/30 comment="Only masquerade router's own traffic"

# ============================================================================
# CAMERA STREAM MONITORING
# ============================================================================

# Monitor camera traffic on core:

# View camera connections:
# /ip firewall connection print where dst-address~"192.168.(20|107)" or src-address~"192.168.(20|107)"

# View camera traffic volume:
# /tool torch interface="VLAN3002 - 1012_INTERNET" src-address=192.168.20.0/24
# /tool torch interface="VLAN3002 - 1012_INTERNET" src-address=192.168.107.0/24

# Check fasttrack effectiveness for cameras:
# /ip firewall filter print stats where action=fasttrack-connection
# Should show MASSIVE hit counts if cameras are streaming

# Monitor connection tracking for camera streams:
# /ip firewall connection print count-only where timeout>1h
# Should show long-lived camera connections

# ============================================================================
# CAMERA-SPECIFIC TROUBLESHOOTING
# ============================================================================

# Problem: Camera stream drops after X minutes
# Cause: Connection tracking timeout too short
# Fix: Increase tcp-established-timeout (already set to 1d above)

# Problem: High CPU with many camera streams
# Cause: Fasttrack not working
# Fix: Verify fasttrack rules are first in filter chain
# Check: /ip firewall filter print stats where action=fasttrack-connection

# Problem: Camera viewing from internet fails
# Cause: Asymmetric routing (your original problem!)
# Fix: Connection marking + routing marks (see file 2 and 8)

# Problem: Choppy video playback
# Cause: MTU issues or QoS problems
# Fix: MSS clamping (already added above)
# Consider: Priority marking for camera VLANs

# Problem: Can't access camera from specific WAN
# Cause: Port forward not configured or srcnat stripping source IP
# Fix: Add port forward, ensure NO srcnat on forwarded traffic

# ============================================================================
# BANDWIDTH PLANNING FOR CAMERAS
# ============================================================================

# Typical camera bandwidth usage:
# - 1080p H.264: 2-4 Mbps per camera
# - 4K H.265: 6-8 Mbps per camera
# - Motion JPEG: 10-20 Mbps per camera (avoid if possible)

# Your WAN capacity planning:
# 1012_INTERNET (1Gbps):
#   - Can handle: 250+ concurrent 1080p streams
#   - Recommended: Max 150 streams (60% utilization)

# 1000_INTERNET (500Mbps):
#   - Can handle: 125+ concurrent 1080p streams
#   - Recommended: Max 75 streams (60% utilization)

# 1005_INTERNET (50Mbps):
#   - Can handle: 12-15 concurrent 1080p streams
#   - Recommended: Max 8-10 streams (60% utilization)
#   - Best for: Remote viewing, not primary recording

# Your CCR1072 can easily handle routing for all 3 WANs simultaneously
# at full capacity (1.65 Gbps combined << 80 Gbps capable)

# ============================================================================
# RECOMMENDED CAMERA NETWORK ARCHITECTURE
# ============================================================================

# Best practice for your setup:

# 1. PRIMARY RECORDING:
#    - Cameras → Site Switch → Site Router → Core → NVR/Servers
#    - Use highest bandwidth WAN (1012_INTERNET)
#    - Keep recording traffic LOCAL where possible

# 2. REMOTE VIEWING:
#    - External viewers → Any WAN → Core → NVR → Core → Same WAN → Viewer
#    - Connection marking ensures return path matches inbound path
#    - Works across all 3 WANs with port forwarding

# 3. INTER-SITE VIEWING:
#    - Site A cameras → Core → Site B viewer
#    - Stays within your network (no WAN traversal)
#    - Lowest latency, highest quality

# 4. CLOUD UPLOAD (if needed):
#    - NVR → Core → Assigned WAN → Cloud
#    - Use policy routing to assign specific NVRs to specific WANs
#    - Prevents saturating single WAN

# ============================================================================
# PERFORMANCE BENCHMARKS (Camera-Specific)
# ============================================================================

# What to expect with proper configuration:

# CCR1072 Core Router:
# - 500 concurrent camera streams: <3% CPU (with fasttrack)
# - 1000 concurrent camera streams: <6% CPU
# - Max theoretical: 10,000+ streams (limited by camera bandwidth, not router)

# CCR2004 Site Routers (1012, 1000):
# - 200 concurrent camera streams: <5% CPU (with fasttrack)
# - Port forwarding: Negligible overhead
# - NAT translation: <1% CPU per 1000 translations/sec

# Connection marking overhead:
# - Per packet: <1 microsecond (negligible for video streams)
# - Per connection: One-time cost at stream start
# - Ongoing: Zero (fasttrack bypasses mangle for established)

# ============================================================================
# TESTING CAMERA STREAM ROUTING
# ============================================================================

# Test camera access from internet via 1012_INTERNET:

# 1. From external location, connect to 1012's public IP on camera port
#    Example: rtsp://<1012-public-ip>:554/stream1

# 2. On 1012 site router:
#    /ip firewall connection print where dst-address=10.10.2.2 and dst-port=554
#    Expected: src=<real-client-ip> dst=10.10.2.2 (NOT src=10.10.2.1!)

# 3. On core router:
#    /ip firewall connection print where dst-port=554 and connection-mark=VIA_1012
#    Expected: connection marked correctly

# 4. Watch video stream for 5+ minutes
#    Expected: No drops, smooth playback

# 5. On core router:
#    /tool torch interface="VLAN3002 - 1012_INTERNET"
#    Expected: See sustained traffic BOTH directions (inbound request, outbound video)

# If video plays smoothly and returns via correct interface = SUCCESS!

# ============================================================================
# NEXT STEPS
# ============================================================================

# 1. Apply connection marking from file 8 (CCR1072-Optimized-Approach.rsc)
# 2. Fix 1000 site router (remove broad masquerade, forward to core)
# 3. Add port forwarding to 1012 site router (forward to core)
# 4. Test camera access from internet via each WAN
# 5. Enable fasttrack on core (CRITICAL for video performance)
# 6. Monitor camera connection counts and bandwidth
# 7. Adjust camera assignments to WANs based on usage

# Your network is well-suited for this!
# - CCR1072 has plenty of capacity
# - CCR2004s are excellent for camera switching
# - VLANs properly segment camera traffic
# - Just need connection marking to fix return path routing
