# Multi-WAN Quick Reference Card

## Emergency Rollback
```
/import backup-YYYY-MM-DD.rsc
/system reboot
```

## Critical Monitoring Commands

### Check WAN Status
```
/tool netwatch print
/ping 10.10.2.1 count=3  # 1012_INTERNET
/ping 10.10.0.1 count=3  # 1000_INTERNET
/ping 10.10.3.1 count=3  # 1005_INTERNET
/ping 192.168.254.1 count=3  # VVG_INTERNET
```

### Check Connection Marks (Real-Time)
```
/ip firewall connection print where connection-mark!=no-mark
```

### Check Return Path Routing
```
/tool torch interface="VLAN3002 - 1012_INTERNET"
# Should see BOTH inbound and outbound traffic for active connections
```

### Verify Mangle is Working
```
/ip firewall mangle print stats where action=mark-connection
# Hit counts should increment as traffic flows
```

### Check Fasttrack Performance
```
/ip firewall filter print stats where action=fasttrack-connection
# High hit count = fasttrack working well
```

### Monitor CPU Usage
```
/system resource print
# Should be < 5% under load
```

---

## Test Connection from Internet

### From External Location:
```
ssh <public-ip-of-1012>
```

### On Site Router (1012):
```
/ip firewall connection print where dst-address~"10.10.2"
# Look for: src=<real-client-ip> dst=10.10.2.2
# NOT: src=10.10.2.1 (that means unwanted srcnat!)
```

### On Core Router:
```
/ip firewall connection print where dst-address~"10.11.101.206"
# Look for: connection-mark=CONN_VIA_1012
```

### Test Return Path:
```
/tool torch interface="VLAN3002 - 1012_INTERNET"
# Should show traffic BOTH directions
```

---

## Test Outbound Site Routing

### From VPS School Site (192.168.10.x):
Visit: https://www.whatismyip.com
Expected: 1012_INTERNET public IP

### On Core:
```
/ip firewall connection print where src-address~"192.168.10" and dst-port=443
# Check connection-mark: Should be CONN_VIA_1012
```

---

## Common Issues

### Issue: Replies go out wrong interface
**Fix**: Check connection mark exists and routing mark is applied
```
/ip firewall connection print where dst-address=<server-ip>
/ip firewall mangle print stats where action=mark-routing
```

### Issue: Source IP not preserved
**Fix**: Remove srcnat from site router for forwarded traffic
```
# On site router:
/ip firewall nat print where chain=srcnat
# Should ONLY see masquerade for 10.10.X.0/30, not all traffic
```

### Issue: Server unreachable from internet
**Fix**: Verify server default gateway points to core
```
# On server:
Windows: ipconfig /all
Linux: ip route show default
# Expected: default via 10.11.101.250
```

### Issue: Failover not working
**Fix**: Verify check-gateway enabled and backup routes exist
```
/ip route print where dst-address=0.0.0.0/0 and routing-table=InternetVia1012
# Should see distance=1 (primary) and distance=2 (backup)
```

---

## Site-to-WAN Assignments

### Check Which Sites Use Which WAN:
```
/ip firewall address-list print where list~"SITES_USE"
```

### Move Site to Different WAN:
```
# Remove from current
/ip firewall address-list remove [find list=SITES_USE_1012 and address=10.11.X.0/24]

# Add to new
/ip firewall address-list add list=SITES_USE_1000 address=10.11.X.0/24 comment="Moved to 1000"
```

---

## Validation Checklist

- [ ] All 4 WANs respond to ping
- [ ] Inbound connection shows real client IP (not site router IP)
- [ ] Connection has correct connection-mark
- [ ] Replies exit same interface as inbound
- [ ] Outbound from assigned sites uses correct WAN
- [ ] Failover works when WAN disconnected
- [ ] CPU < 5% under load
- [ ] Fasttrack hit count high
- [ ] No unexpected firewall drops

---

## Key IP Addresses

| Description | IP | Interface |
|-------------|----|-----------|
| Core Router Management | 10.11.100.250 | VLAN1100 |
| Core Router Server VLAN | 10.11.101.250 | VLAN1101 |
| 1012_INTERNET Gateway | 10.10.2.1 | VLAN3002 |
| 1012_INTERNET Core | 10.10.2.2 | VLAN3002 |
| 1000_INTERNET Gateway | 10.10.0.1 | VLAN3000 |
| 1000_INTERNET Core | 10.10.0.2 | VLAN3000 |
| 1005_INTERNET Gateway | 10.10.3.1 | VLAN3003 |
| 1005_INTERNET Core | 10.10.3.2 | VLAN3003 |
| VVG_INTERNET Gateway | 192.168.254.1 | VLAN3004 |
| VVG_INTERNET Core | 192.168.254.2 | VLAN3004 |
| Main Server (ANPR01) | 10.11.101.206 | VLAN1101 |

---

## Support Contacts

- **Mikrotik Forum**: https://forum.mikrotik.com
- **Emergency Rollback**: Import backup file
- **Documentation**: See README.md
- **Full Testing**: See 7-Testing-Validation.rsc

---

**Remember**: Always backup before making changes!
```
/export file=backup-before-changes
/system backup save name=backup-before-changes
```
