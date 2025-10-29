# 2025-10-27 17:03:48 by RouterOS 7.20.2
# software id = BTBI-G6D4
#
# model = CCR2004-1G-12S+2XS
# serial number = D4F00D081203
/interface bridge
add frame-types=admit-only-vlan-tagged name=Bride.Local vlan-filtering=yes
/interface ethernet
set [ find default-name=sfp-sfpplus1 ] name=sfp-sfpplus1-Services
set [ find default-name=sfp-sfpplus11 ] name=sfp-sfpplus11-LAN
set [ find default-name=sfp-sfpplus12 ] name=sfp-sfpplus12-WAN
set [ find default-name=sfp28-1 ] disabled=yes
set [ find default-name=sfp28-2 ] disabled=yes
/interface vlan
add interface=Bride.Local name=VLAN1000 vlan-id=1000
add interface=Bride.Local name=VLAN3000-Internet vlan-id=3000
/interface ethernet switch
set 0 cpu-flow-control=yes
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=dhcp_pool0 ranges=10.11.0.1-10.11.0.199
/ip dhcp-server
add add-arp=yes address-pool=dhcp_pool0 always-broadcast=yes interface=\
    VLAN1000 name=DHCP.LAN
/port
set 0 name=serial0
/interface bridge port
add bridge=Bride.Local frame-types=admit-only-untagged-and-priority-tagged \
    interface=ether1 pvid=3000
add bridge=Bride.Local interface=sfp-sfpplus1-Services pvid=1000
add bridge=Bride.Local interface=sfp-sfpplus11-LAN pvid=1000
add bridge=Bride.Local frame-types=admit-only-vlan-tagged interface=\
    sfp-sfpplus12-WAN
/ip neighbor discovery-settings
set discover-interface-list=!dynamic
/ipv6 settings
set disable-ipv6=yes
/interface bridge vlan
add bridge=Bride.Local comment="added by pvid" tagged=sfp-sfpplus12-WAN \
    untagged=ether1 vlan-ids=3000
add bridge=Bride.Local comment="added by pvid" tagged=sfp-sfpplus12-WAN \
    untagged=sfp-sfpplus11-LAN,sfp-sfpplus1-Services vlan-ids=1000
/ip address
add address=10.11.0.250/24 interface=VLAN1000 network=10.11.0.0
add address=10.11.100.205/30 interface=VLAN1000 network=10.11.100.204
add address=102.182.242.216/26 interface=VLAN3000-Internet network=\
    102.182.242.192
add address=192.168.8.250/24 interface=VLAN1000 network=192.168.8.0
add address=10.10.0.1/30 interface=VLAN3000-Internet network=10.10.0.0
/ip cloud
set ddns-enabled=yes
/ip dhcp-client
add interface=VLAN3000-Internet
/ip dhcp-server lease
add address=10.11.0.142 client-id=1:0:21:b7:bf:e1:79 comment=\
    "Lexmark Office Printer" mac-address=00:21:B7:BF:E1:79 server=DHCP.LAN
add address=10.11.0.200 client-id=1:44:a6:42:de:24:65 comment=\
    "Facial Recognition Camera" mac-address=44:A6:42:DE:24:65 server=DHCP.LAN
add address=10.11.0.254 mac-address=64:D1:54:C2:93:B6 server=DHCP.LAN
add address=10.11.0.22 client-id=1:94:dd:f8:1f:ca:81 mac-address=\
    94:DD:F8:1F:CA:81 server=DHCP.LAN
/ip dhcp-server network
add address=10.11.0.0/24 dns-server=8.8.8.8,1.1.1.1 gateway=10.11.0.250
/ip dns
set servers=8.8.8.8
/ip firewall address-list
add address=0.0.0.0/8 comment=RFC6890 list=Private_Range
add address=10.0.0.0/8 comment=RFC6890 list=Private_Range
add address=100.64.0.0/10 comment=RFC6890 list=Private_Range
add address=127.0.0.0/8 comment=RFC6890 list=Private_Range
add address=169.254.0.0/16 comment=RFC6890 list=Private_Range
add address=172.16.0.0/12 comment=RFC6890 list=Private_Range
add address=192.0.0.0/24 comment=RFC6890 list=Private_Range
add address=192.0.2.0/24 comment=RFC6890 list=Private_Range
add address=192.168.0.0/16 comment=RFC6890 list=Private_Range
add address=192.88.99.0/24 comment=RFC3068 list=Private_Range
add address=198.18.0.0/15 comment=RFC6890 list=Private_Range
add address=198.51.100.0/24 comment=RFC6890 list=Private_Range
add address=203.0.113.0/24 comment=RFC6890 list=Private_Range
add address=224.0.0.0/4 comment=RFC4601 list=Private_Range
add address=240.0.0.0/4 comment=RFC6890 list=Private_Range
/ip firewall filter
add action=accept chain=input protocol=icmp
add action=drop chain=input connection-state=invalid,new in-interface=\
    VLAN3000-Internet
/ip firewall nat
add action=dst-nat chain=dstnat dst-port=22 in-interface=VLAN3000-Internet \
    protocol=tcp to-addresses=10.11.101.230
add action=dst-nat chain=dstnat dst-port=6280,6281 in-interface=\
    VLAN3000-Internet protocol=tcp src-address=165.0.77.19 to-addresses=\
    10.10.0.1 to-ports=6280
add action=dst-nat chain=dstnat comment=VPN dst-port=500,1701,4500 \
    in-interface=VLAN3000-Internet protocol=udp to-addresses=10.11.100.250
add action=dst-nat chain=dstnat dst-port=6280,6281 in-interface=\
    VLAN3000-Internet protocol=tcp to-addresses=10.11.101.206 to-ports=6280
add action=masquerade chain=srcnat out-interface=VLAN3000-Internet
/ip route
add disabled=no distance=151 dst-address=0.0.0.0/0 gateway=102.182.242.193
add disabled=yes distance=130 dst-address=10.11.0.0/16 gateway=10.11.100.206 \
    pref-src=10.11.0.250
add disabled=yes distance=130 dst-address=10.20.0.0/16 gateway=10.11.100.206 \
    pref-src=10.11.0.250
add disabled=yes distance=130 dst-address=192.168.107.0/24 gateway=\
    10.11.100.206 pref-src=10.11.0.250
add comment="Private network" disabled=no distance=140 dst-address=\
    198.18.0.0/15 gateway=10.11.100.206 pref-src=10.11.0.250 routing-table=\
    main scope=30 suppress-hw-offload=no target-scope=10
add comment="Private network" disabled=no distance=140 dst-address=\
    192.168.0.0/16 gateway=10.11.100.206 pref-src=10.11.0.250 routing-table=\
    main scope=30 suppress-hw-offload=no target-scope=10
add comment="Private network" disabled=no distance=140 dst-address=\
    192.0.0.0/24 gateway=10.11.100.206 pref-src=10.11.0.250 routing-table=\
    main scope=30 suppress-hw-offload=no target-scope=10
add comment="Private network" disabled=no distance=140 dst-address=\
    172.16.0.0/12 gateway=10.11.100.206 pref-src=10.11.0.250 routing-table=\
    main scope=30 suppress-hw-offload=no target-scope=10
add comment="Private network" disabled=no distance=140 dst-address=10.0.0.0/8 \
    gateway=10.11.100.206 pref-src=10.11.0.250 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
/ip smb shares
set [ find default=yes ] directory=flash/pub
/system clock
set time-zone-name=Africa/Johannesburg
