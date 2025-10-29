# 2025-10-27 17:39:33 by RouterOS 7.20.2
# software id = ME7A-VS42
#
# model = CCR2004-1G-12S+2XS
# serial number = D4F00CDF7E96
/caps-man channel
add band=2ghz-g/n control-channel-width=20mhz frequency=2412,2437,2462 name=\
    CH_2G_20 reselect-interval=4w2d..1h1s tx-power=17
add band=5ghz-a/n/ac control-channel-width=20mhz extension-channel=disabled \
    frequency=5180,5260,5500,5580,5660 name=CH_5G_80 reselect-interval=\
    4w2d..1h1s skip-dfs-channels=yes
add band=5ghz-a/n/ac control-channel-width=20mhz extension-channel=disabled \
    frequency=5180,5200,5220,5240 name=CH_5G_20_NDFS reselect-interval=\
    4w2d..1h1s skip-dfs-channels=yes
/interface bridge
add frame-types=admit-only-vlan-tagged name=Local.Bridge vlan-filtering=yes
/interface ethernet
set [ find default-name=ether1 ] name=ether1-Internet
set [ find default-name=sfp-sfpplus1 ] name=sfp-sfpplus1-G2
set [ find default-name=sfp-sfpplus2 ] name=sfp-sfpplus2-G1
set [ find default-name=sfp-sfpplus3 ] name=sfp-sfpplus3-GR
set [ find default-name=sfp-sfpplus4 ] name=sfp-sfpplus4-MC
set [ find default-name=sfp-sfpplus5 ] name=sfp-sfpplus5-LAN
set [ find default-name=sfp-sfpplus6 ] disabled=yes
set [ find default-name=sfp-sfpplus7 ] disabled=yes
set [ find default-name=sfp-sfpplus8 ] disabled=yes
set [ find default-name=sfp-sfpplus9 ] disabled=yes
set [ find default-name=sfp-sfpplus10 ] disabled=yes
set [ find default-name=sfp-sfpplus11 ] name=sfp-sfpplus11-PHONE
set [ find default-name=sfp-sfpplus12 ] name=sfp-sfpplus12-WAN
set [ find default-name=sfp28-1 ] disabled=yes
set [ find default-name=sfp28-2 ] disabled=yes
/interface wireguard
add disabled=yes listen-port=51820 mtu=1420 name=wg1
/interface vlan
add interface=Local.Bridge name=VLAN10-LAN vlan-id=10
add interface=Local.Bridge name=VLAN20-IPCAMERAS vlan-id=20
add interface=Local.Bridge name=VLAN30-WIFIAPs vlan-id=30
add interface=Local.Bridge name=VLAN40-IPPhones vlan-id=40
add interface=Local.Bridge name=VLAN50-WIFIClients vlan-id=50
add interface=Local.Bridge name=VLAN51-GuestWIFIClients vlan-id=51
add interface=Local.Bridge name=VLAN99-MGMT vlan-id=99
add interface=Local.Bridge name=VLAN1012-WAN vlan-id=1012
add interface=Local.Bridge name=VLAN3002-Internet vlan-id=3002
/caps-man rates
add basic=1Mbps,2Mbps,5.5Mbps,11Mbps,6Mbps,12Mbps,24Mbps ht-basic-mcs="" \
    ht-supported-mcs="" name=LimitedRates supported="1Mbps,2Mbps,5.5Mbps,11Mbp\
    s,6Mbps,9Mbps,12Mbps,18Mbps,24Mbps,36Mbps,48Mbps,54Mbps" vht-basic-mcs="" \
    vht-supported-mcs=""
add basic=6Mbps,12Mbps,24Mbps name=BestRates-2G supported=\
    6Mbps,9Mbps,12Mbps,18Mbps,24Mbps,36Mbps,48Mbps,54Mbps
add basic=6Mbps,12Mbps,24Mbps name=BestRates-5G supported=\
    6Mbps,9Mbps,12Mbps,18Mbps,24Mbps,36Mbps,48Mbps,54Mbps
/caps-man security
add authentication-types=wpa2-psk encryption=aes-ccm group-encryption=aes-ccm \
    group-key-update=1h name=IDNI.SECURITY
add authentication-types=wpa2-psk comment="Klofie\$!2025" encryption=aes-ccm \
    group-encryption=aes-ccm group-key-update=1h name=VPS.STAFF.SECURITY
add authentication-types=wpa2-psk encryption=aes-ccm group-encryption=aes-ccm \
    group-key-update=1h name=VPS.GUEST.SECURITY
/caps-man configuration
add channel=CH_5G_80 channel.frequency="" .reselect-interval=..1h1s \
    .skip-dfs-channels=no country="south africa" datapath.bridge=Local.Bridge \
    .vlan-id=50 .vlan-mode=use-tag guard-interval=long installation=indoor \
    max-sta-count=64 mode=ap multicast-helper=full name=VPS.WIFI.Config.5Ghz \
    rates=BestRates-5G security=VPS.STAFF.SECURITY ssid=VPS.STAFF.WIFI
add channel=CH_2G_20 channel.frequency="" .reselect-interval=..1h1s country=\
    "south africa" datapath.bridge=Local.Bridge .vlan-id=50 .vlan-mode=\
    use-tag guard-interval=long installation=indoor max-sta-count=32 mode=ap \
    multicast-helper=full name=VPS.WIFI.Config.2Ghz rates=BestRates-2G \
    rates.ht-basic-mcs="" .ht-supported-mcs="" .vht-basic-mcs="" \
    .vht-supported-mcs="" security=VPS.STAFF.SECURITY ssid=VPS.STAFF.WIFI
add channel=CH_2G_20 country="south africa" datapath.bridge=Local.Bridge \
    .vlan-id=51 .vlan-mode=use-tag guard-interval=long installation=indoor \
    max-sta-count=32 mode=ap multicast-helper=full name=\
    Guest.WIFI.Config.2Ghz rates=BestRates-2G security=VPS.GUEST.SECURITY \
    ssid=VPS.GUEST.WIFI
add channel=CH_2G_20 country="south africa" datapath.bridge=Local.Bridge \
    .vlan-id=10 .vlan-mode=use-tag guard-interval=long hide-ssid=yes \
    installation=indoor max-sta-count=32 mode=ap multicast-helper=full name=\
    IDNI.WIFI.Config.2Ghz rates=BestRates-2G security=IDNI.SECURITY ssid=\
    IDNI.WIFI
add channel=CH_5G_80 country="south africa" datapath.bridge=Local.Bridge \
    .vlan-id=10 .vlan-mode=use-tag guard-interval=long hide-ssid=yes \
    installation=indoor max-sta-count=64 mode=ap multicast-helper=full name=\
    IDNI.WIFI.Config.5Ghz rates=BestRates-5G security=IDNI.SECURITY ssid=\
    IDNI.WIFI
add channel=CH_5G_80 country="south africa" datapath.bridge=Local.Bridge \
    .vlan-id=51 .vlan-mode=use-tag guard-interval=long installation=indoor \
    max-sta-count=64 mode=ap multicast-helper=full name=\
    Guest.WIFI.Config.5Ghz rates=BestRates-5G security=VPS.GUEST.SECURITY \
    ssid=VPS.GUEST.WIFI
/interface ethernet switch
set 0 cpu-flow-control=yes
/interface list
add comment="All local VLANs" name=LAN
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip dhcp-server option
add code=121 name=121Routes value=0x100A0B0A0B65FA000A0B65FB
/ip pool
add name=VPS.CAMERAS.Pool ranges=192.168.107.1-192.168.107.254
add name=VPS.Phones.Pool ranges=192.168.106.1-192.168.106.249
add name=VPS.Servers.Pool ranges=10.11.101.220-10.11.101.230
add name=VPS.LAN.Pool ranges=10.11.12.17-10.11.12.240
add name=VPS.WIFI.Pool ranges=\
    192.168.108.1-192.168.108.249,192.168.108.251-192.168.109.254
add name=VPS.GuestWIFI.Pool ranges=\
    192.168.112.1-192.168.112.249,192.168.112.251-192.168.115.254
/ip dhcp-server
add address-pool=VPS.LAN.Pool always-broadcast=yes interface=VLAN10-LAN name=\
    VPS.DHCP.LAN
add address-pool=VPS.Phones.Pool interface=VLAN40-IPPhones name=\
    VPS.DHCP.Phones
add address-pool=VPS.CAMERAS.Pool always-broadcast=yes interface=\
    VLAN20-IPCAMERAS name=VPS.DHCP.Cameras
add address-pool=VPS.WIFI.Pool always-broadcast=yes interface=\
    VLAN50-WIFIClients name=VPS.DHCP.WIFI
add address-pool=VPS.GuestWIFI.Pool interface=VLAN51-GuestWIFIClients \
    lease-time=10m name=VPS.DHCP.GuestWIFIClients
/port
set 0 name=serial0
/caps-man access-list
add action=reject comment="BLOCKED: Netgear rogue DHCP server - net_ac_0D0E" \
    mac-address=54:B8:74:56:0D:0E
add action=accept allow-signal-out-of-range=10s disabled=yes interface=all \
    signal-range=-79..120 ssid-regexp=""
add action=reject allow-signal-out-of-range=30s disabled=yes interface=all \
    signal-range=-120..-80 ssid-regexp=""
/caps-man manager
set enabled=yes
/caps-man provisioning
add action=create-dynamic-enabled hw-supported-modes=gn master-configuration=\
    VPS.WIFI.Config.2Ghz name-format=prefix-identity name-prefix=2Ghz \
    slave-configurations=Guest.WIFI.Config.2Ghz,IDNI.WIFI.Config.2Ghz
add action=create-dynamic-enabled hw-supported-modes=an,ac \
    master-configuration=VPS.WIFI.Config.5Ghz name-format=prefix-identity \
    name-prefix=5Ghz slave-configurations=\
    Guest.WIFI.Config.5Ghz,IDNI.WIFI.Config.5Ghz
/interface bridge port
add bridge=Local.Bridge frame-types=admit-only-vlan-tagged interface=\
    sfp-sfpplus1-G2
add bridge=Local.Bridge frame-types=admit-only-vlan-tagged interface=\
    sfp-sfpplus2-G1
add bridge=Local.Bridge frame-types=admit-only-vlan-tagged interface=\
    sfp-sfpplus3-GR
add bridge=Local.Bridge frame-types=admit-only-vlan-tagged interface=\
    sfp-sfpplus4-MC
add bridge=Local.Bridge frame-types=admit-only-untagged-and-priority-tagged \
    interface=sfp-sfpplus5-LAN pvid=10
add bridge=Local.Bridge frame-types=admit-only-vlan-tagged interface=\
    sfp-sfpplus6
add bridge=Local.Bridge frame-types=admit-only-vlan-tagged interface=\
    sfp-sfpplus7
add bridge=Local.Bridge frame-types=admit-only-vlan-tagged interface=\
    sfp-sfpplus8
add bridge=Local.Bridge frame-types=admit-only-vlan-tagged interface=\
    sfp-sfpplus9
add bridge=Local.Bridge frame-types=admit-only-vlan-tagged interface=\
    sfp-sfpplus10
add bridge=Local.Bridge frame-types=admit-only-vlan-tagged interface=\
    sfp-sfpplus11-PHONE
add bridge=Local.Bridge frame-types=admit-only-vlan-tagged interface=\
    sfp-sfpplus12-WAN
add bridge=Local.Bridge frame-types=admit-only-untagged-and-priority-tagged \
    interface=ether1-Internet pvid=3002
/interface bridge settings
set use-ip-firewall=yes use-ip-firewall-for-vlan=yes
/ip neighbor discovery-settings
set discover-interface-list=all
/ipv6 settings
set disable-ipv6=yes forward=no
/interface bridge vlan
add bridge=Local.Bridge tagged="sfp-sfpplus1-G2,sfp-sfpplus12-WAN,sfp-sfpplus2\
    -G1,sfp-sfpplus3-GR,sfp-sfpplus4-MC,sfp-sfpplus11-PHONE" untagged=\
    sfp-sfpplus5-LAN vlan-ids=10
add bridge=Local.Bridge tagged=sfp-sfpplus12-WAN vlan-ids=1012
add bridge=Local.Bridge tagged="sfp-sfpplus1-G2,sfp-sfpplus12-WAN,sfp-sfpplus2\
    -G1,sfp-sfpplus3-GR,sfp-sfpplus4-MC,sfp-sfpplus11-PHONE" vlan-ids=20
add bridge=Local.Bridge tagged="sfp-sfpplus1-G2,sfp-sfpplus12-WAN,sfp-sfpplus2\
    -G1,sfp-sfpplus3-GR,sfp-sfpplus4-MC,sfp-sfpplus11-PHONE" vlan-ids=40
add bridge=Local.Bridge tagged="sfp-sfpplus1-G2,sfp-sfpplus12-WAN,sfp-sfpplus2\
    -G1,sfp-sfpplus3-GR,sfp-sfpplus4-MC,sfp-sfpplus11-PHONE" vlan-ids=30
add bridge=Local.Bridge tagged=sfp-sfpplus12-WAN untagged=ether1-Internet \
    vlan-ids=3002
add bridge=Local.Bridge tagged="sfp-sfpplus12-WAN,sfp-sfpplus11-PHONE,sfp-sfpp\
    lus1-G2,sfp-sfpplus2-G1,sfp-sfpplus3-GR,sfp-sfpplus4-MC" vlan-ids=99
add bridge=Local.Bridge tagged=sfp-sfpplus12-WAN vlan-ids=50
add bridge=Local.Bridge tagged=sfp-sfpplus12-WAN vlan-ids=51
/interface list member
add interface=VLAN10-LAN list=LAN
add interface=VLAN20-IPCAMERAS list=LAN
add interface=VLAN40-IPPhones list=LAN
add interface=VLAN50-WIFIClients list=LAN
add interface=VLAN51-GuestWIFIClients list=LAN
/interface wireguard peers
add allowed-address=10.10.10.2/32 disabled=yes interface=wg1 name=peer2 \
    persistent-keepalive=25s public-key=\
    "8J3lUcHQUOcFLCwkrwGRhX3H6CbozIgM2jh3DP3FRRg="
/ip address
add address=10.11.100.245/30 interface=VLAN1012-WAN network=10.11.100.244
add address=10.11.12.250/24 interface=VLAN10-LAN network=10.11.12.0
add address=192.168.107.250/24 interface=VLAN20-IPCAMERAS network=\
    192.168.107.0
add address=192.168.106.250/24 interface=VLAN40-IPPhones network=\
    192.168.106.0
add address=192.168.108.250/23 interface=VLAN50-WIFIClients network=\
    192.168.108.0
add address=192.168.105.250/24 interface=VLAN30-WIFIAPs network=192.168.105.0
add address=192.168.112.250/22 interface=VLAN51-GuestWIFIClients network=\
    192.168.112.0
add address=10.10.2.1/30 interface=VLAN3002-Internet network=10.10.2.0
add address=10.10.10.1/30 disabled=yes interface=wg1 network=10.10.10.0
/ip cloud
set ddns-enabled=yes
/ip dhcp-client
add default-route-distance=150 interface=VLAN3002-Internet
add add-default-route=no default-route-tables=main interface=\
    VLAN50-WIFIClients use-peer-dns=no use-peer-ntp=no
/ip dhcp-server lease
add address=10.11.12.221 client-id=1:bc:5e:33:5c:6b:80 mac-address=\
    BC:5E:33:5C:6B:80 server=VPS.DHCP.LAN
add address=10.11.12.230 comment=PABX mac-address=00:00:00:00:00:01
add address=10.11.12.5 comment="Legacy IPCamera Static IP" mac-address=\
    00:00:00:00:00:05
add address=10.11.12.6 comment="Legacy IPCamera Static IP" mac-address=\
    00:00:00:00:00:06
add address=10.11.12.7 comment="Legacy IPCamera Static IP" mac-address=\
    00:00:00:00:00:07
add address=10.11.12.8 comment="Legacy IPCamera Static IP" mac-address=\
    00:00:00:00:00:08
add address=10.11.12.9 comment="Legacy IPCamera Static IP" mac-address=\
    00:00:00:00:00:09
add address=10.11.12.10 comment="Legacy IPCamera Static IP" mac-address=\
    00:00:00:00:00:10
add address=10.11.12.11 comment="Legacy IPCamera Static IP" mac-address=\
    00:00:00:00:00:11
add address=10.11.12.12 comment="Legacy IPCamera Static IP" mac-address=\
    00:00:00:00:00:12
add address=10.11.12.13 comment="Legacy IPCamera Static IP" mac-address=\
    00:00:00:00:00:13
add address=10.11.12.14 comment="Legacy IPCamera Static IP" mac-address=\
    00:00:00:00:00:14
add address=10.11.12.15 comment="Legacy IPCamera Static IP" mac-address=\
    00:00:00:00:00:15
add address=10.11.12.248 comment="Lan Connected AP" mac-address=\
    00:00:00:00:00:F5
add address=10.11.12.249 comment="Lan Connected AP" mac-address=\
    00:00:00:00:00:F6
add address=10.11.12.247 comment="Lan Connected AP" mac-address=\
    00:00:00:00:00:F4
add address=10.11.12.220 comment="Lizel Printer" mac-address=\
    00:00:00:00:00:FA
add address=10.11.12.241 comment="WKOD Server" mac-address=00:00:00:00:00:41
add address=10.11.12.242 comment="WKOD Server" mac-address=00:00:00:00:00:42
add address=10.11.12.243 comment="WKOD Server" mac-address=00:00:00:00:00:43
add address=10.11.12.244 comment="WKOD Server" mac-address=00:00:00:00:00:44
add address=10.11.12.245 comment="WKOD Server" mac-address=00:00:00:00:00:45
add address=10.11.12.246 comment="WKOD Server" mac-address=00:00:00:00:00:46
/ip dhcp-server network
add address=10.11.12.0/24 dns-server=10.11.12.250 domain=VPS.ORG.ZA gateway=\
    10.11.12.250 netmask=24
add address=192.168.105.0/24 dns-server=10.11.12.250 domain=VPS.ORG.ZA \
    gateway=192.168.105.250 netmask=24
add address=192.168.107.0/24 dns-server=10.11.12.250 domain=VPS.ORG.ZA \
    gateway=192.168.107.250 netmask=24
add address=192.168.108.0/23 dns-server=10.11.12.250 domain=VPS.ORG.ZA \
    gateway=192.168.108.250 netmask=23
add address=192.168.112.0/22 dns-server=208.67.220.123,208.67.222.123 \
    gateway=192.168.112.250 netmask=22
/ip dns
set allow-remote-requests=yes
/ip firewall address-list
add address=10.11.12.250 comment="DHCP server IP - VLAN10-LAN" list=\
    dhcp-server-ips
add address=192.168.105.250 comment="DHCP server IP" list=dhcp-server-ips
add address=192.168.107.250 comment="DHCP server IP" list=dhcp-server-ips
add address=192.168.108.250 comment="DHCP server IP - VLAN50-WIFIClients" \
    list=dhcp-server-ips
add address=192.168.112.250 comment="DHCP server IP" list=dhcp-server-ips
add address=10.11.12.0/24 list=valid-lan-subnets
add address=192.168.105.0/24 list=valid-lan-subnets
add address=192.168.107.0/24 list=valid-lan-subnets
add address=192.168.108.0/23 list=valid-lan-subnets
add address=192.168.112.0/22 list=valid-lan-subnets
/ip firewall filter
add action=accept chain=input comment="Allow WireGuard" dst-port=51820 \
    protocol=udp
add action=accept chain=input disabled=yes protocol=icmp
add action=drop chain=forward in-interface=VLAN51-GuestWIFIClients \
    out-interface=!VLAN3002-Internet
add action=drop chain=input connection-state=invalid,new in-interface=\
    VLAN3002-Internet
add action=add-src-to-address-list address-list=rogue-dhcp \
    address-list-timeout=1d chain=forward comment="Tag rogue DHCP sources" \
    in-interface-list=LAN log=yes log-prefix="ROGUE-DHCP " protocol=udp \
    src-address-list=!dhcp-server-ips src-port=67
/ip firewall nat
add action=src-nat chain=srcnat dst-address=10.11.101.221 to-addresses=\
    10.11.12.250
add action=dst-nat chain=dstnat dst-port=6280,6281 in-interface=\
    VLAN3002-Internet protocol=tcp src-address=!10.11.0.0/16 to-addresses=\
    10.11.101.206 to-ports=6280
add action=dst-nat chain=dstnat dst-port=500,1701,4500 in-interface=\
    VLAN3002-Internet protocol=udp to-addresses=10.11.100.250
add action=dst-nat chain=dstnat dst-port=15065-15068 in-interface=\
    VLAN3002-Internet protocol=udp to-addresses=10.11.100.250
add action=dst-nat chain=dstnat dst-port=15069 in-interface=VLAN3002-Internet \
    protocol=udp to-addresses=10.11.100.250
add action=dst-nat chain=dstnat dst-port=443 in-interface=VLAN3002-Internet \
    protocol=tcp src-address=!10.11.0.0/16 to-addresses=10.11.101.221
add action=dst-nat chain=dstnat dst-port=80 in-interface=VLAN3002-Internet \
    protocol=tcp src-address=!10.11.0.0/16 to-addresses=10.11.101.221
add action=masquerade chain=srcnat out-interface=VLAN3002-Internet
/ip firewall service-port
set sip disabled=yes
/ip route
add comment=RFC6890_Private_Range distance=149 dst-address=0.0.0.0/8 gateway=\
    10.11.100.246
add comment=RFC6890_Private_Range distance=149 dst-address=10.0.0.0/8 \
    gateway=10.11.100.246
add comment=RFC6890_Private_Range distance=149 dst-address=100.64.0.0/10 \
    gateway=10.11.100.246
add comment=RFC6890_Private_Range distance=149 dst-address=127.0.0.0/8 \
    gateway=10.11.100.246
add comment=RFC6890_Private_Range distance=149 dst-address=169.254.0.0/16 \
    gateway=10.11.100.246
add comment=RFC6890_Private_Range distance=149 dst-address=172.16.0.0/12 \
    gateway=10.11.100.246
add comment=RFC6890_Private_Range distance=149 dst-address=192.0.0.0/24 \
    gateway=10.11.100.246
add comment=RFC6890_Private_Range distance=149 dst-address=192.0.2.0/24 \
    gateway=10.11.100.246
add comment=RFC6890_Private_Range distance=149 dst-address=192.168.0.0/16 \
    gateway=10.11.100.246
add comment=RFC3068_Private_Range distance=149 dst-address=192.88.99.0/24 \
    gateway=10.11.100.246
add comment=RFC6890_Private_Range distance=149 dst-address=198.18.0.0/15 \
    gateway=10.11.100.246
add comment=RFC6890_Private_Range distance=149 dst-address=198.51.100.0/24 \
    gateway=10.11.100.246
add comment=RFC6890_Private_Range distance=149 dst-address=203.0.113.0/24 \
    gateway=10.11.100.246
add comment=RFC4601_Private_Range distance=149 dst-address=224.0.0.0/4 \
    gateway=10.11.100.246
add comment=RFC6890_Private_Range distance=149 dst-address=240.0.0.0/4 \
    gateway=10.11.100.246
add dst-address=192.168.11.0/24 gateway=10.10.10.2
/ip smb shares
set [ find default=yes ] directory=flash/pub
/ip upnp
set enabled=yes
/ip upnp interfaces
add interface=VLAN3002-Internet type=external
/system clock
set time-zone-name=Africa/Johannesburg
/system identity
set name=1012_MTIK_VPS_CoreRouter
/system ntp client
set enabled=yes
/system ntp client servers
add address=time.windows.com
/tool sniffer
set filter-interface=VLAN50-WIFIClients filter-ip-protocol=udp filter-port=\
    bootps,bootpc filter-src-ip-address=192.168.1.1/32 memory-limit=100000KiB \
    streaming-enabled=yes
