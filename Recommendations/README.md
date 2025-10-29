# Multi-WAN Policy-Based Routing Solution
## For CCR1072-1G-8S+ Core Router with 4 Internet Connections

---

## Executive Summary

This solution solves your **asymmetric routing issue** where traffic arrives via one internet connection but replies exit via a different one, causing connection failures.

### Current Problem
```
Client → 1000_INTERNET → Core → Server → Core → 1012_INTERNET → ❌ FAIL
```

### Solution
```
Client → 1000_INTERNET → Core → Server → Core → 1000_INTERNET → ✅ SUCCESS
```

### Key Features
- ✅ **Source IP Preservation**: Inbound connections retain real client IP (no NAT)
- ✅ **Return Path Routing**: Replies always use the same path as inbound
- ✅ **Site-Specific Policies**: Control which sites use which internet connection
- ✅ **Automatic Failover**: Seamless failover when WAN goes down
- ✅ **Hardware Acceleration**: Fasttrack for maximum throughput, minimal CPU
- ✅ **Scalability**: Handles 200+ sites with 60+ VLANs

---

## Network Topology

```
                                    ┌─────────────────┐
                                    │   Internet      │
                                    └────────┬────────┘
                            ┌────────────────┼────────────────┐
                            │                │                │
                    ┌───────▼──────┐ ┌──────▼──────┐ ┌───────▼──────┐
                    │ 1000_INTERNET│ │1012_INTERNET│ │1005_INTERNET │
                    │  CCR2004     │ │  CCR2004    │ │ netPower 16P │
                    │  500Mbps     │ │  1Gbps      │ │   50Mbps     │
                    └───────┬──────┘ └──────┬──────┘ └───────┬──────┘
                            │                │                │
                      10.10.0.1/30    10.10.2.1/30     10.10.3.1/30
                            │                │                │
                            └────────────────┼────────────────┘
                                             │
                                    ┌────────▼─────────┐
                                    │  CCR1072 CORE    │
                                    │  72-core CPU     │
                                    │  1.3% usage      │
                                    └────────┬─────────┘
                                             │
                    ┌────────────────────────┼────────────────────────┐
                    │                        │                        │
            ┌───────▼────────┐    ┌─────────▼────────┐    ┌─────────▼────────┐
            │ VLAN1000       │    │  VLAN1012        │    │  VLAN1005        │
            │ VCID Office    │    │  VPS School      │    │  8KBS            │
            │                │    │                  │    │                  │
            │ VLAN1001       │    │  VLAN1101        │    └──────────────────┘
            │ 26 PBS         │    │  Core Servers    │
            │                │    │  10.11.101.0/24  │
            │ ...60+ VLANs   │    └──────────────────┘
            └────────────────┘
```

---

## Internet Connections

| Name | Interface | Speed | Router | Port Forward | Usage |
|------|-----------|-------|--------|--------------|-------|
| 1012_INTERNET | VLAN3002 (10.10.2.0/30) | 1Gbps | CCR2004 | ✅ Yes | PRIMARY - Most traffic |
| 1000_INTERNET | VLAN3000 (10.10.0.0/30) | 500Mbps | CCR2004 | ✅ Yes | VCID sites |
| 1005_INTERNET | VLAN3003 (10.10.3.0/30) | 50Mbps | netPower 16P | ✅ Yes | 8KBS sites |
| VVG_INTERNET | VLAN3004 (192.168.254.0/30) | 100Mbps | ISP router | ❌ No | Outbound only |

---

## How It Works

### 1. Connection Tracking (Inbound)
When a client connects from the internet:

```
1. Client (8.8.8.8) → 1012_INTERNET (public IP) → Port Forward → Core (10.10.2.2)
2. Core marks connection: CONN_VIA_1012
3. Core applies routing mark: RT_VIA_1012
4. Packet forwarded to server (10.11.101.206)
5. Server replies to 8.8.8.8
6. Core sees reply, checks connection mark: CONN_VIA_1012
7. Routing mark forces reply via InternetVia1012 routing table
8. Reply exits via 10.10.2.1 (same path as inbound) ✅
```

### 2. Policy-Based Routing (Outbound)
When internal site initiates connection:

```
1. VPS School (192.168.10.5) → Core → Internet
2. Core checks source: 192.168.10.5 in SITES_USE_1012 address list
3. Core marks connection: CONN_VIA_1012
4. Core applies routing mark: RT_VIA_1012
5. Packet exits via 1012_INTERNET (10.10.2.1)
6. Masquerade at site router
7. Reply returns, connection tracking handles reverse NAT ✅
```

### 3. Failover
When WAN connection fails:

```
1. Gateway 10.10.2.1 stops responding to pings
2. Route check-gateway=ping marks route as inactive
3. Backup route (distance=2) becomes active
4. New connections automatically use backup WAN
5. Existing connections continue on backup WAN
6. When primary recovers, new connections use primary again ✅
```

---

## Implementation Files

| File | Purpose | Apply To |
|------|---------|----------|
| **1-Core-Internet-Setup.rsc** | Configure 4th WAN, interface lists, address lists | Core Router |
| **2-Core-Connection-Routing-Marks.rsc** | Mark connections and apply routing marks | Core Router |
| **3-Core-Routing-Tables-Failover.rsc** | Configure routing tables with failover | Core Router |
| **4-Core-Site-Policy-Routing.rsc** | Assign sites to specific internet connections | Core Router |
| **5-Site-Router-Port-Forwarding.rsc** | Port forwarding WITHOUT srcnat (preserves source IP) | Site Routers |
| **6-Performance-Optimization.rsc** | Fasttrack, connection tracking, hardware offload | Core + Site Routers |
| **7-Testing-Validation.rsc** | Complete testing procedures and troubleshooting | All |

---

## Implementation Roadmap

### Phase 1: Preparation (1 hour)
- [ ] Backup all devices (`/export file=backup-YYYY-MM-DD`)
- [ ] Document current server gateways
- [ ] Test current internet connectivity
- [ ] Record baseline CPU/performance metrics
- [ ] Set up out-of-band access (keep VPN connected)

### Phase 2: Core Router - Basic Setup (30 minutes)
- [ ] Apply **1-Core-Internet-Setup.rsc**
- [ ] Test: Verify interface lists and address lists
- [ ] Test: Ping all 4 gateways
- [ ] **STOP if issues** - Rollback and troubleshoot

### Phase 3: Core Router - Routing Tables (30 minutes)
- [ ] Apply **3-Core-Routing-Tables-Failover.rsc**
- [ ] Test: Traceroute via each routing table
- [ ] Test: Verify internal routes in all tables
- [ ] **STOP if issues** - Rollback and troubleshoot

### Phase 4: Core Router - Connection/Routing Marks (15 minutes)
- [ ] Apply **2-Core-Connection-Routing-Marks.rsc**
- [ ] Test: Verify mangle rules exist
- [ ] Test: Check mangle statistics (will be 0 until traffic flows)
- [ ] **STOP if issues** - Rollback and troubleshoot

### Phase 5: Test ONE WAN Connection (1 hour)
**Start with 1012_INTERNET (your primary)**

- [ ] On site router: Backup current config
- [ ] On site router: Apply port forward from **5-Site-Router-Port-Forwarding.rsc**
- [ ] On server 10.11.101.206: Change default gateway to 10.11.101.250 (core)
- [ ] Test: SSH from internet to 1012's public IP
- [ ] Test: On site router - verify source IP preserved (not 10.10.2.1)
- [ ] Test: On core - verify connection mark CONN_VIA_1012
- [ ] Test: Monitor return path via `torch` - should exit VLAN3002
- [ ] **If successful**, move to Phase 6
- [ ] **If failed**, troubleshoot before continuing (see Testing file)

### Phase 6: Add Remaining WAN Connections (2 hours)
- [ ] Apply port forwarding to 1000_INTERNET site router
- [ ] Apply port forwarding to 1005_INTERNET site router
- [ ] Test each connection individually
- [ ] Verify return path routing for each

### Phase 7: Site-Specific Outbound Routing (30 minutes)
- [ ] Apply **4-Core-Site-Policy-Routing.rsc**
- [ ] Test: From VPS School site, check public IP (should be 1012)
- [ ] Test: From VCID Office site, check public IP (should be 1000)
- [ ] Test: From 8KBS site, check public IP (should be 1005)
- [ ] Adjust site assignments as needed

### Phase 8: Failover Testing (30 minutes)
- [ ] Disconnect 1012_INTERNET cable
- [ ] Verify failover to backup WAN
- [ ] Verify existing connections continue
- [ ] Reconnect and verify recovery
- [ ] Repeat for other WANs

### Phase 9: Performance Optimization (30 minutes)
- [ ] Apply **6-Performance-Optimization.rsc**
- [ ] Monitor fasttrack statistics
- [ ] Verify CPU stays low under load
- [ ] Test maximum throughput with iperf3

### Phase 10: Monitoring and Documentation (1 hour)
- [ ] Set up monitoring scripts
- [ ] Create network diagram
- [ ] Document final configuration
- [ ] Train team on troubleshooting
- [ ] Schedule 30-day review

**Total Time: ~8 hours** (spread over multiple days recommended)

---

## Critical Success Factors

### ✅ Must Have for Success

1. **Site Routers: NO srcnat on forwarded traffic**
   ```
   ❌ WRONG: add chain=srcnat action=masquerade out-interface=to-core
   ✅ RIGHT: Only masquerade router's own traffic (10.10.X.0/30)
   ```

2. **Servers: Core as default gateway**
   ```
   ❌ WRONG: Default gateway = site router (10.10.2.1)
   ✅ RIGHT: Default gateway = core (10.11.101.250)
   ```

3. **Core: Connection marks BEFORE routing marks**
   ```
   ✅ Mangle order:
   1. Mark connection (based on in-interface)
   2. Mark routing (based on connection-mark)
   ```

4. **Core: Internal routes in ALL routing tables**
   ```
   ❌ WRONG: Only in main table
   ✅ RIGHT: Copy to InternetVia1000, InternetVia1012, InternetVia1005, InternetVia_VVG
   ```

---

## Troubleshooting Quick Reference

### Problem: Inbound connections fail
```
Check:
1. Port forward exists on site router
2. Site router NOT doing srcnat on forwarded traffic
3. Core sees connection with real source IP
4. Server default gateway points to core
5. Firewall allows traffic
```

### Problem: Replies go out wrong interface
```
Check:
1. Connection has correct connection-mark
2. Routing mark is applied in mangle
3. Routing table has correct default route
4. passthrough=no on routing mark rules
```

### Problem: Source IP not preserved
```
Check:
1. Site router: /ip firewall connection print
   - src should be real client IP, not site router IP
2. No srcnat for forwarded traffic on site router
3. Core: /ip firewall connection print
   - src should be real client IP
```

### Problem: Failover not working
```
Check:
1. check-gateway=ping enabled on routes
2. Netwatch shows gateway status
3. Backup routes exist with higher distance
```

---

## Performance Expectations

### With Optimization:
- **Throughput**: Near line-rate (950Mbps on 1Gbps connection)
- **CPU Usage**: < 5% even at multi-gigabit speeds
- **Latency**: < 1ms added by core router
- **Fasttrack**: 90%+ of packets hardware offloaded

### Monitoring:
```
# CPU usage
/system resource print

# Fasttrack effectiveness
/ip firewall filter print stats where action=fasttrack-connection

# Connection marks
/ip firewall connection print count-only where connection-mark!=no-mark

# Per-WAN traffic
/tool torch interface="VLAN3002 - 1012_INTERNET"
```

---

## Support and Maintenance

### Daily:
- Monitor WAN status (netwatch or scripts)
- Check for firewall drops

### Weekly:
- Review connection mark statistics
- Check failover functionality
- Monitor CPU/memory usage

### Monthly:
- Review site-to-WAN assignments
- Optimize based on usage patterns
- Update documentation

### Quarterly:
- Full configuration backup
- Disaster recovery test
- RouterOS security updates

---

## Additional Resources

- **Mikrotik Wiki**: https://wiki.mikrotik.com/wiki/Manual:Routing
- **Policy-Based Routing**: https://wiki.mikrotik.com/wiki/Manual:PCC
- **Connection Tracking**: https://wiki.mikrotik.com/wiki/Manual:IP/Firewall/Connection_tracking
- **Fasttrack**: https://wiki.mikrotik.com/wiki/Manual:Fast_Path

---

## Configuration Version History

| Date | Version | Changes | Author |
|------|---------|---------|--------|
| 2025-10-27 | 1.0 | Initial multi-WAN setup | Claude |
|  |  |  |  |

---

## Contact and Support

For issues during implementation:
1. Refer to **7-Testing-Validation.rsc** troubleshooting section
2. Check Mikrotik forums: https://forum.mikrotik.com
3. Review connection marks and mangle statistics

---

**IMPORTANT**: Test on ONE internet connection first, validate completely, then expand to others!
