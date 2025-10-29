# Camera Surveillance Network - Multi-WAN Implementation Guide

## Your Network Overview

**Core Router**: CCR1072-1G-8S+ (80Gbps, 72 cores) @ 1.3% CPU
**Primary Use Case**: Video surveillance across 200+ sites with IP cameras
**Current Issue**: Asymmetric routing breaks return path for camera streams

### Internet Connections

| Site | Router | Speed | Camera Traffic | Status |
|------|--------|-------|----------------|--------|
| **1012** VPS School | CCR2004 | 1Gbps | Heavy (VLAN20: 192.168.107.x) | PRIMARY - Needs port forwarding |
| **1000** VCID Office | CCR2004 | 500Mbps | Medium | Needs NAT fix |
| **1005** 8KBS | CRS318 | 50Mbps | Light | Needs port forwarding |
| **VVG** Church | ISP Router | 100Mbps | None | Outbound only |

---

## The Problem (Illustrated with Camera Stream)

### Current Behavior (BROKEN):
```
External Viewer
    |
    | 1. Request camera stream
    ↓
1000_INTERNET (500Mbps)
    |
    | 2. Port forward to core
    ↓
CORE ROUTER (CCR1072)
    |
    | 3. Route to camera server
    ↓
Camera Server (10.11.101.206)
    |
    | 4. Stream reply
    ↓
CORE ROUTER
    |
    | 5. ❌ Routes via WRONG WAN (1012)
    ↓
1012_INTERNET (1Gbps) ← WRONG PATH!
    |
    ↓
❌ STREAM FAILS (client expects from 1000, receives from 1012)
```

### Fixed Behavior (WORKING):
```
External Viewer
    |
    | 1. Request camera stream
    ↓
1000_INTERNET (500Mbps)
    |
    | 2. Port forward to core (source IP preserved!)
    ↓
CORE ROUTER (CCR1072)
    |  ✓ Connection marked: CONN_VIA_1000
    |  ✓ Routing mark applied: Route_Via_1000
    |
    | 3. Route to camera server
    ↓
Camera Server (10.11.101.206)
    |
    | 4. Stream reply
    ↓
CORE ROUTER
    |  ✓ Checks connection mark: CONN_VIA_1000
    |  ✓ Uses routing table: Route_Via_1000
    |
    | 5. ✓ Routes via CORRECT WAN (1000)
    ↓
1000_INTERNET (500Mbps) ← CORRECT PATH!
    |
    ↓
✓ STREAM WORKS (symmetric routing maintained)
```

---

## Implementation Steps

### Phase 1: Fix Site Routers (2 hours)

**Priority Order:**
1. **1000_INTERNET** (already has port forwarding, just needs NAT fix)
2. **1012_INTERNET** (primary camera traffic, needs port forwarding added)
3. **1005_INTERNET** (light traffic, can wait)

#### 1000 Site Router - CRITICAL FIX
```bash
# See file: RouterConfigs/1000/CHANGES-NEEDED.rsc

# The fix:
1. Remove broad masquerade (line 97 of current config)
2. Add selective masquerade (only router's own traffic)
3. Change port forwards to send to core (10.10.0.2) instead of directly to servers

# Time: 15 minutes
# Risk: Low (can rollback easily)
```

#### 1012 Site Router - ADD PORT FORWARDING
```bash
# See file: RouterConfigs/1012/CHANGES-NEEDED.rsc

# What to add:
1. Port forwarding rules (camera ports 554, 80, 443, 6280-6290)
2. Selective masquerade (only router's own traffic)
3. Routes to internal networks
4. Basic firewall rules

# Time: 20 minutes
# Risk: Low (currently no port forwarding, adding new rules)
```

### Phase 2: Configure Core Router (1 hour)

```bash
# Use simplified approach from file: 8-CCR1072-Optimized-Approach.rsc

# What to configure:
1. Connection marking (12 mangle rules) ← THE KEY FIX
2. Routing tables (4 tables with failover)
3. NAT for outbound (masquerade per WAN)

# Time: 30 minutes configuration + 30 minutes testing
# Risk: Medium (test carefully, can rollback)
```

### Phase 3: Enable Fasttrack (30 minutes)

```bash
# For camera traffic, fasttrack is CRITICAL
# See file: 9-Camera-Video-Traffic-Optimization.rsc

# What to enable:
1. Fasttrack rules in firewall filter
2. Extended connection tracking timeouts (for long video streams)

# Time: 10 minutes configuration + 20 minutes validation
# Risk: Low (huge performance benefit for video)
```

---

## Camera Traffic Optimization

### Why Video Is Different

| Aspect | Normal Web Traffic | Camera Streams |
|--------|-------------------|----------------|
| **Connection Duration** | Seconds | Hours/Days |
| **Bandwidth** | Bursty | Sustained |
| **Interruption Tolerance** | High | Very Low |
| **Connection Count** | High turnover | Stable |
| **Fasttrack Benefit** | Moderate | Massive |

### Expected Performance

#### WITHOUT Fasttrack:
- **100 camera streams**: 15-20% CPU
- **500 camera streams**: 70-80% CPU (struggle)
- **Max throughput**: 10-15 Gbps

#### WITH Fasttrack:
- **100 camera streams**: 1-2% CPU
- **500 camera streams**: 5-8% CPU (easy)
- **1000+ camera streams**: 12-15% CPU (still comfortable)
- **Max throughput**: 60-80 Gbps

### Camera Stream Bandwidth Planning

#### Typical Camera Bandwidth:
- **1080p H.264**: 2-4 Mbps per camera
- **4K H.265**: 6-8 Mbps per camera

#### Your WAN Capacity:

**1012_INTERNET (1Gbps)**:
- **Theoretical Max**: 250-500 concurrent 1080p streams
- **Recommended Max**: 150-200 streams (60-80% utilization)
- **Use for**: Primary camera recording and high-quality viewing

**1000_INTERNET (500Mbps)**:
- **Theoretical Max**: 125-250 concurrent 1080p streams
- **Recommended Max**: 75-100 streams (60% utilization)
- **Use for**: Secondary viewing, office cameras

**1005_INTERNET (50Mbps)**:
- **Theoretical Max**: 12-25 concurrent 1080p streams
- **Recommended Max**: 8-12 streams (60% utilization)
- **Use for**: Remote monitoring only, not primary recording

---

## Testing Procedure

### Test 1: Verify Source IP Preservation (CRITICAL)

**On 1000 Site Router** (after NAT fix):
```routeros
# 1. Connect from external internet to camera via public IP
# Example: rtsp://102.182.242.216:554/stream

# 2. On site router, check connection:
/ip firewall connection print where dst-address=10.10.0.2

# EXPECTED: src=<real-client-ip> dst=10.10.0.2
# WRONG: src=10.10.0.1 dst=10.10.0.2 (means masquerade is still active!)
```

### Test 2: Verify Connection Marking

**On Core Router** (after connection marking configured):
```routeros
# While camera stream is active from test above:
/ip firewall connection print where connection-mark=VIA_1000

# EXPECTED: See connection with real client IP marked as VIA_1000
```

### Test 3: Verify Return Path Routing

**On Core Router**:
```routeros
# Monitor traffic while streaming:
/tool torch interface="VLAN3000 - 1000_INTERNET"

# EXPECTED: See traffic BOTH directions:
# - Inbound: Client requests
# - Outbound: Video stream data
# Both should be on same interface (VLAN3000)
```

### Test 4: Long-Duration Stream Test

```
1. Start camera stream from internet
2. Let it run for 30+ minutes
3. Monitor for drops or interruptions
4. Check CPU usage on core (should stay low with fasttrack)
```

**Success Criteria:**
- ✓ No stream drops
- ✓ Smooth playback
- ✓ CPU < 5% on core
- ✓ Return path uses same WAN as inbound

---

## Common Camera Issues & Solutions

### Problem: Camera stream drops after 10-15 minutes
**Cause**: Connection tracking timeout too short
**Solution**: Increase tcp-established-timeout to 1d (see file 9)

### Problem: Choppy video playback
**Cause**: MTU/MSS mismatch
**Solution**: Add MSS clamping (see file 9, line "change-mss")

### Problem: Can't access cameras from specific WAN
**Cause**: No port forwarding or srcnat stripping source IP
**Solution**: Add port forwarding, remove broad masquerade

### Problem: High CPU with many camera streams
**Cause**: Fasttrack not enabled or not working
**Solution**: Enable fasttrack rules (see file 9)

### Problem: Cameras accessible but can't view from NVR
**Cause**: Asymmetric routing (your original problem!)
**Solution**: Connection marking + routing marks (file 8)

---

## Rollback Plan

If anything goes wrong:

### Site Routers:
```routeros
# Restore from backup:
/import 1000-backup-before-changes.rsc
/system reboot
```

### Core Router:
```routeros
# Remove connection marking:
/ip firewall mangle remove [find comment~"VIA_10"]

# Remove routing marks:
/ip firewall mangle remove [find action=mark-routing]

# Restore will fall back to default routing
```

---

## Maintenance & Monitoring

### Daily Checks:
```routeros
# On core - check WAN health:
/tool netwatch print

# Check connection marks are working:
/ip firewall connection print count-only where connection-mark!=no-mark
```

### Weekly Checks:
```routeros
# Check fasttrack effectiveness:
/ip firewall filter print stats where action=fasttrack-connection
# Should show millions of hits for active camera network

# Check CPU usage:
/system resource print
# Should be < 10% even with hundreds of cameras
```

### Monthly Checks:
- Review camera bandwidth usage per WAN
- Rebalance camera assignments if one WAN is overloaded
- Test failover by disconnecting primary WAN

---

## File Reference Guide

| File | Purpose | When to Use |
|------|---------|-------------|
| **8-CCR1072-Optimized-Approach.rsc** | Core router config (simplified) | START HERE for core |
| **9-Camera-Video-Traffic-Optimization.rsc** | Camera-specific optimizations | After basic routing works |
| **RouterConfigs/1000/CHANGES-NEEDED.rsc** | Fix 1000 site router NAT | FIRST - critical fix |
| **RouterConfigs/1012/CHANGES-NEEDED.rsc** | Add 1012 site router port forwarding | SECOND - primary cameras |
| **QUICK-REFERENCE.md** | Emergency commands | Keep handy during implementation |
| **7-Testing-Validation.rsc** | Detailed testing procedures | Use to validate each phase |

---

## Success Metrics

After full implementation:

- [√] Can access cameras from internet via all 3 WANs
- [√] Source IP preserved (visible in NVR logs as real client IPs)
- [√] Camera streams don't drop (hours of continuous viewing)
- [√] Core CPU < 5% with hundreds of active streams
- [√] Failover works (unplug WAN, streams switch to backup)
- [√] Camera recording continues during WAN failure
- [√] No asymmetric routing (return path matches inbound path)

---

## Next Steps

1. **Read** RouterConfigs/1000/CHANGES-NEEDED.rsc
2. **Backup** 1000 site router
3. **Apply** NAT fix to 1000 router
4. **Test** camera access via 1000 WAN
5. **If successful**, move to 1012 router
6. **Then** configure core router with file 8
7. **Finally** enable fasttrack and enjoy!

**Estimated Total Time**: 4-6 hours including testing
**Recommended Approach**: Do it over 2-3 sessions to avoid rushing

---

**Questions or issues?** Refer to QUICK-REFERENCE.md for emergency commands and troubleshooting.
