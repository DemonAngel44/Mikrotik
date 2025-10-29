# ============================================================================
# STEP 6: PERFORMANCE OPTIMIZATION
# For: 1100_MTIK-CCR1072-THE_CORE (and site routers)
# ============================================================================
# Purpose: Maximize throughput and minimize CPU usage
# Your CCR1072 has 72 cores at 1.3% - let's optimize further!
# ============================================================================

# ----------------------------------------------------------------------------
# FASTTRACK - Hardware Offload for Established Connections
# ----------------------------------------------------------------------------
# Fasttrack bypasses most firewall/mangle processing for established connections
# Can achieve 10Gbps+ with minimal CPU usage

# IMPORTANT: Fasttrack compatibility
# Works with: Basic forwarding, NAT masquerade
# Does NOT work with: QoS, queues, some mangle actions
# Our solution: Fasttrack after connection/routing marks are applied

/ip firewall filter
# Place these rules EARLY in your filter chain (before other forward rules)

# Accept established/related first (required for fasttrack)
add chain=forward action=accept connection-state=established,related \
    place-before=0 comment="Accept established/related for fasttrack"

# Fasttrack established connections
# NOTE: We exclude connection-mark=no-mark to ensure our marked connections
# get processed correctly on first packet, then fasttracked after
add chain=forward action=fasttrack-connection hw-offload=yes \
    connection-state=established,related connection-mark=!no-mark \
    place-before=1 comment="Fasttrack offload established connections"

# EXPLANATION:
# 1. First packet arrives, goes through full mangle processing
# 2. Connection gets marked (CONN_VIA_1012, etc.)
# 3. Routing mark is applied
# 4. Subsequent packets in same connection are fasttracked
# 5. Fasttracked packets skip most processing = massive performance gain

# ----------------------------------------------------------------------------
# Connection Tracking Optimization
# ----------------------------------------------------------------------------
# Tune connection tracking for your network size

/ip firewall connection tracking
set enabled=yes \
    tcp-established-timeout=1d \
    tcp-fin-wait-timeout=10s \
    tcp-close-wait-timeout=10s \
    tcp-last-ack-timeout=10s \
    tcp-time-wait-timeout=10s \
    tcp-close-timeout=10s \
    udp-timeout=10s \
    udp-stream-timeout=3m \
    icmp-timeout=10s \
    generic-timeout=10m

# This reduces the time old connections stay in the table
# Faster cleanup = less memory usage = better performance

# For very high connection count environments, increase table size:
# set max-entries=2000000

# ----------------------------------------------------------------------------
# Bridge Hardware Offload (If Supported by Switch Chip)
# ----------------------------------------------------------------------------
# Your CCR1072-1G-8S+ may have switch chip that supports hardware offload

/interface bridge
set IDNI.CORE-Bridge vlan-filtering=yes frame-types=admit-only-vlan-tagged \
    hw-offload=yes comment="Enable hardware offload if supported"

# Check if hw-offload is active:
# /interface bridge print detail
# If hw-offload shows "no" after enabling, your model doesn't support it

# ----------------------------------------------------------------------------
# Interface Transmit Queues (For High Bandwidth Interfaces)
# ----------------------------------------------------------------------------
# Optimize for your SFP+ interfaces handling lots of traffic

/queue interface
set sfp-sfpplus2-VPSSwitch1 queue=only-hardware-queue
set sfp-sfpplus3-8KBS-Switch1 queue=only-hardware-queue
set sfp-sfpplus4-VCIDOfficeSwitch1 queue=only-hardware-queue
set sfp-sfpplus5-26PBSSwitch1 queue=only-hardware-queue
set sfp-sfpplus7-CameraSwitchNew queue=only-hardware-queue
set sfp-sfpplus8-VVGChurch queue=only-hardware-queue

# This bypasses software queuing for maximum performance
# Only use if you don't need QoS/traffic shaping on these interfaces

# ----------------------------------------------------------------------------
# Disable Unused Services (Security + Performance)
# ----------------------------------------------------------------------------
# Every enabled service consumes some CPU cycles

/ip service
set telnet disabled=yes
set ftp disabled=yes
set www disabled=yes address=10.11.100.0/24,10.11.101.0/24
set ssh address=10.11.100.0/24,10.11.101.0/24 port=22
set www-ssl address=10.11.100.0/24,10.11.101.0/24 port=443
set winbox address=10.11.100.0/24,10.11.101.0/24 port=8291
set api disabled=yes
set api-ssl disabled=yes

# Disable bandwidth server (only enable when testing)
/tool bandwidth-server set enabled=no

# Disable MAC telnet/winbox discovery on WAN interfaces
/tool mac-server
set allowed-interface-list=LAN_ALL
/tool mac-server mac-winbox
set allowed-interface-list=LAN_ALL
/tool mac-server ping
set enabled=no

# ----------------------------------------------------------------------------
# Firewall Rule Optimization
# ----------------------------------------------------------------------------
# Optimize rule order for performance (most common matches first)

# Your firewall filter should be ordered like this:
# 1. Accept established/related (highest traffic)
# 2. Fasttrack established/related
# 3. Drop invalid connections
# 4. Accept common protocols (ICMP, etc.)
# 5. Specific allow rules
# 6. Drop rules
# 7. Log rules (last - most CPU intensive)

# Use address lists instead of multiple individual rules
# Example: Instead of 10 rules checking different IPs, use one rule with address-list

# ----------------------------------------------------------------------------
# Logging Optimization
# ----------------------------------------------------------------------------
# Excessive logging kills performance

/system logging
# Log only warnings and errors for firewall
set action=memory topics=firewall,warning
set action=memory topics=firewall,error

# Don't log every packet drop
/ip firewall filter
# When adding drop rules, use log=no (or omit log parameter)
# Only log specific suspicious traffic, not general drops

# ----------------------------------------------------------------------------
# DNS Caching
# ----------------------------------------------------------------------------
# Increase DNS cache for better performance

/ip dns
set allow-remote-requests=yes cache-size=8192KiB cache-max-ttl=1w servers=8.8.8.8,1.1.1.1

# ----------------------------------------------------------------------------
# CPU Affinity and IRQ Optimization (Advanced)
# ----------------------------------------------------------------------------
# CCR1072 has 72 cores - let RouterOS handle distribution automatically
# Usually no manual tuning needed, but monitor with:

# /system resource irq print
# /system resource cpu print

# If you see imbalance, you can manually assign:
# /system resource irq set <irq-number> cpu=<core-list>

# ----------------------------------------------------------------------------
# Memory Optimization
# ----------------------------------------------------------------------------
# Monitor memory usage:
# /system resource print

# If memory is low, reduce:
# - Connection tracking timeout (see above)
# - Firewall connection tracking max-entries
# - DNS cache size
# - Logging buffer sizes

# ----------------------------------------------------------------------------
# Packet Flow Optimization
# ----------------------------------------------------------------------------
# Minimize packet processing overhead

# Use simple mangle actions where possible:
# - passthrough=no on final action (skip further processing)
# - Place most common rules first
# - Use connection marks instead of packet marks (more efficient)

# Our configuration already does this:
# - Connection marks for tracking
# - Routing marks based on connection marks
# - passthrough=no on routing marks
# - Fasttrack for established connections

# ----------------------------------------------------------------------------
# WAN Interface Optimization
# ----------------------------------------------------------------------------
# Tune TCP settings for WAN connections

/ip firewall mangle
# MSS clamping for all WAN interfaces (prevent fragmentation)
add chain=forward action=change-mss new-mss=clamp-to-pmtu protocol=tcp \
    tcp-flags=syn passthrough=yes out-interface-list=WAN_ALL \
    comment="Clamp MSS for WAN to prevent fragmentation"

# ----------------------------------------------------------------------------
# BGP Optimization (If Using BGP)
# ----------------------------------------------------------------------------
# You have BGP configured but disabled - if you enable it:

/routing bgp connection
set [find] hold-time=90s keepalive-time=30s \
    comment="Reduce BGP keepalive overhead"

# ----------------------------------------------------------------------------
# Performance Monitoring
# ----------------------------------------------------------------------------
# Commands to monitor performance:

# Overall system:
# /system resource print
# /system resource monitor-traffic interface=sfp-sfpplus2-VPSSwitch1

# CPU per core:
# /system resource cpu print

# Connection tracking:
# /ip firewall connection print count-only
# /ip firewall connection tracking print

# Firewall performance:
# /ip firewall filter print stats
# /ip firewall mangle print stats
# /ip firewall nat print stats

# Fasttrack effectiveness:
# /ip firewall filter print stats where action=fasttrack-connection
# If hit count is high, fasttrack is working well!

# Interface statistics:
# /interface print stats
# /interface monitor-traffic interface=sfp-sfpplus2-VPSSwitch1

# Routing table performance:
# /routing stats print

# ----------------------------------------------------------------------------
# Performance Baseline
# ----------------------------------------------------------------------------
# Before applying optimizations, record baseline:

# /system resource print
# CPU: 1.3% (you mentioned)
# Memory: ?
# Uptime: ?

# After applying:
# - CPU should stay low even under heavy load
# - Fasttrack hit count should be high
# - Connection tracking should show reasonable timeout

# Expected results with fasttrack:
# - 10Gbps+ throughput possible
# - CPU < 5% even at multi-gigabit speeds
# - Sub-microsecond latency for fasttracked packets

# ----------------------------------------------------------------------------
# Gradual Rollout
# ----------------------------------------------------------------------------
# Enable optimizations in this order:

# 1. Connection tracking optimization (low risk)
# 2. Service hardening (improves security + performance)
# 3. Firewall rule order optimization (test thoroughly)
# 4. Fasttrack (test last - most impactful but most complex)

# Test fasttrack on ONE WAN connection first:
# add chain=forward action=fasttrack-connection \
#     in-interface="VLAN3002 - 1012_INTERNET" connection-state=established,related

# Monitor for issues, then expand to all interfaces

# ----------------------------------------------------------------------------
# Troubleshooting Performance Issues
# ----------------------------------------------------------------------------

# If CPU is high:
# 1. Check firewall rule hit counts: /ip firewall filter print stats
# 2. Look for rules with huge hit counts and optimize
# 3. Check if fasttrack is working: stats should show high hits
# 4. Monitor IRQ distribution: /system resource irq print

# If throughput is low:
# 1. Check for duplex mismatches: /interface print
# 2. Monitor errors: /interface print stats
# 3. Check MSS/MTU: Use ping with DF bit
# 4. Verify hardware offload: /interface bridge print detail

# If latency is high:
# 1. Check queue depths: /queue interface print
# 2. Disable software queues: set queue=only-hardware-queue
# 3. Check for excessive logging
# 4. Monitor connection tracking table size

# Next step: Testing and validation procedures (see next file)
