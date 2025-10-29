# 2025-10-27 18:02:06 by RouterOS 7.20.2
# software id = V59N-BN1W
#
# model = CRS318-16P-2S+
# serial number = D55A0F5C3238
/caps-man channel
add band=2ghz-g/n control-channel-width=20mhz frequency=2412,2437,2462 name=\
    CH_2G_20 reselect-interval=4w2d tx-power=17
add band=5ghz-n/ac control-channel-width=20mhz extension-channel=disabled \
    frequency=5180,5200,5220,5240 name=CH_5G_20_NDFS reselect-interval=4w2d \
    skip-dfs-channels=yes
add band=5ghz-n/ac control-channel-width=20mhz extension-channel=disabled \
    frequency=5180,5260,5500,5580,5660 name=CH_5G_80 reselect-interval=4w2d \
    skip-dfs-channels=yes
/interface bridge
add frame-types=admit-only-vlan-tagged name=Local.Bridge vlan-filtering=yes
/interface ethernet
set [ find default-name=ether1 ] name=ether1-Internet poe-out=off
set [ find default-name=ether2 ] name=ether2-AtosLaptop
set [ find default-name=ether3 ] name=ether3-UKRSNLaptop
set [ find default-name=ether4 ] name=ether4-ConfigSW
set [ find default-name=ether5 ] name=ether5-DesktopMGMT
set [ find default-name=ether7 ] name=ether7-JessieLaptop
set [ find default-name=ether8 ] name=ether8-Desktop-LAN
set [ find default-name=ether9 ] name="ether9-Desktop-MGMT(tmp)"
set [ find default-name=ether10 ] name=ether10-Testing2
set [ find default-name=ether16 ] name=ether16-OfficeWAP
set [ find default-name=sfp-sfpplus1 ] name=sfp-sfpplus1-WAN
set [ find default-name=sfp-sfpplus2 ] name=sfp-sfpplus2-Garage
/interface eoip
add local-address=192.168.100.1 mac-address=02:AE:4F:94:BE:79 mtu=1550 name=\
    eoip-tunnel1 remote-address=192.168.100.4 tunnel-id=4101
/interface wireguard
add listen-port=15065 mtu=1420 name=WG_M_5065_BBID-Windmeul
add listen-port=15067 mtu=1420 name=WG_M_5067_CLC-UK
add disabled=yes listen-port=15067 mtu=1420 name=WG_M_Charl_iPhone
/interface vlan
add interface=Local.Bridge name=VLAN99 vlan-id=99
add interface=Local.Bridge name=VLAN1005 vlan-id=1005
add interface=Local.Bridge name=VLAN3003-Internet vlan-id=3003
add disabled=yes interface=Local.Bridge name=VLAN3105-NORD vlan-id=3105
/caps-man datapath
add bridge=Local.Bridge client-to-client-forwarding=yes name=IDNI.VLANCONFIG \
    vlan-id=1005 vlan-mode=use-tag
/caps-man rates
add basic=12Mbps,24Mbps name=LimitedRates supported=\
    12Mbps,18Mbps,24Mbps,36Mbps,48Mbps,54Mbps
/caps-man security
add authentication-types=wpa2-psk disable-pmkid=no encryption=aes-ccm \
    group-encryption=aes-ccm group-key-update=1h name=IDNI.Security
add authentication-types=wpa2-psk disable-pmkid=no encryption=aes-ccm \
    group-encryption=aes-ccm group-key-update=1h name=NorthAPSecurity
add authentication-types=wpa2-psk encryption=aes-ccm group-encryption=aes-ccm \
    group-key-update=1h name=VPS.STAFF.SECURITY
/caps-man configuration
add channel=CH_2G_20 country="south africa" datapath.bridge=Local.Bridge \
    .vlan-id=1005 .vlan-mode=use-tag guard-interval=any installation=indoor \
    max-sta-count=32 mode=ap multicast-helper=full name=IDNI.WIFI.Config.2Ghz \
    rates=LimitedRates security=IDNI.Security ssid=IDNI.WIFI
add channel=CH_5G_80 country="south africa" datapath.bridge=Local.Bridge \
    .vlan-id=1005 .vlan-mode=use-tag guard-interval=any installation=indoor \
    max-sta-count=64 mode=ap multicast-helper=full name=IDNI.WIFI.Config.5Ghz \
    rates=LimitedRates security=IDNI.Security ssid=IDNI.WIFI
add channel=CH_2G_20 country="south africa" datapath.bridge=Local.Bridge \
    .vlan-id=1005 .vlan-mode=use-tag guard-interval=any hide-ssid=yes \
    installation=indoor max-sta-count=32 mode=ap multicast-helper=full name=\
    VPS.WIFI.Config.2Ghz rates=LimitedRates security=VPS.STAFF.SECURITY ssid=\
    VPS.STAFF.WIFI
/interface list
add name=DiscoverOnly
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip ipsec mode-config
add name=NordVPN responder=no
/ip ipsec policy group
add name=NordVPN
/ip ipsec profile
add dpd-interval=2m dpd-maximum-failures=5 name=NordVPN
/ip ipsec peer
add address=uk2267.nordvpn.com disabled=yes exchange-mode=ike2 name=NordVPN \
    profile=NordVPN
/ip ipsec proposal
set [ find default=yes ] disabled=yes
add disabled=yes name=NordVPN pfs-group=none
/ip pool
add name=LAN_DHCP_POOL ranges=10.11.5.1-10.11.5.249
add name=MGMT_DHCP_POOL ranges=10.99.0.10-10.99.0.254
add name=dhcp_pool2 ranges=192.168.99.2-192.168.99.254
add name=dhcp_pool3 ranges=192.168.100.2-192.168.100.254
/ip dhcp-server
add add-arp=yes address-pool=LAN_DHCP_POOL always-broadcast=yes interface=\
    VLAN1005 lease-time=1h name=LAN.DHCP_Server
add add-arp=yes address-pool=MGMT_DHCP_POOL disabled=yes interface=VLAN99 \
    name=MGMT.DHCP_Server
add address-pool=dhcp_pool2 disabled=yes interface=VLAN3105-NORD name=\
    NORDVPN.DHCP_Server
/port
set 0 name=serial0
/routing table
add disabled=no fib name=via-NorthVPN
add disabled=no fib name=to-vlan3003
add disabled=no fib name=via-Core
/caps-man manager
set enabled=yes
/caps-man provisioning
add action=create-dynamic-enabled hw-supported-modes=gn master-configuration=\
    IDNI.WIFI.Config.2Ghz name-format=prefix-identity name-prefix=2Ghz \
    slave-configurations=VPS.WIFI.Config.2Ghz
add action=create-dynamic-enabled hw-supported-modes=an,ac \
    master-configuration=IDNI.WIFI.Config.5Ghz name-format=prefix-identity \
    name-prefix=5Ghz
/interface bridge port
add bridge=Local.Bridge interface=ether2-AtosLaptop pvid=1005
add bridge=Local.Bridge interface=ether3-UKRSNLaptop pvid=1005
add bridge=Local.Bridge comment="previously vlan 99" frame-types=\
    admit-only-untagged-and-priority-tagged interface=ether5-DesktopMGMT \
    pvid=99
add bridge=Local.Bridge interface=ether8-Desktop-LAN pvid=1005
add bridge=Local.Bridge interface=ether4-ConfigSW pvid=1005
add bridge=Local.Bridge interface=ether6 pvid=1005
add bridge=Local.Bridge interface=ether7-JessieLaptop pvid=1005
add bridge=Local.Bridge interface=ether11 pvid=1005
add bridge=Local.Bridge interface=ether12 pvid=1005
add bridge=Local.Bridge interface=ether13 pvid=1005
add bridge=Local.Bridge interface=ether14 pvid=1005
add bridge=Local.Bridge interface=ether15 pvid=1005
add bridge=Local.Bridge interface=ether16-OfficeWAP pvid=1005
add bridge=Local.Bridge interface=ether1-Internet pvid=3003
add bridge=Local.Bridge interface=sfp-sfpplus2-Garage pvid=1005
add bridge=Local.Bridge frame-types=admit-only-vlan-tagged interface=\
    sfp-sfpplus1-WAN
add bridge=Local.Bridge interface=ether10-Testing2 pvid=1005
add bridge=Local.Bridge interface="ether9-Desktop-MGMT(tmp)" pvid=99
/ip neighbor discovery-settings
set discover-interface-list=all
/ipv6 settings
set disable-ipv6=yes forward=no
/interface bridge vlan
add bridge=Local.Bridge tagged=sfp-sfpplus1-WAN vlan-ids=3003
add bridge=Local.Bridge tagged=sfp-sfpplus1-WAN untagged=ether5-DesktopMGMT \
    vlan-ids=99
add bridge=Local.Bridge disabled=yes tagged=sfp-sfpplus1-WAN untagged=\
    ether5-DesktopMGMT vlan-ids=1000
add bridge=Local.Bridge comment="added by pvid" tagged=sfp-sfpplus1-WAN \
    untagged="sfp-sfpplus2-Garage,ether16-OfficeWAP,ether4-ConfigSW,ether2-Ato\
    sLaptop,ether8-Desktop-LAN,ether3-UKRSNLaptop,ether10-Testing2" vlan-ids=\
    1005
/interface list member
add interface=VLAN1005 list=DiscoverOnly
/interface ovpn-server server
add mac-address=FE:33:9C:05:9C:F9 name=ovpn-server1
/interface wireguard peers
add allowed-address=0.0.0.0/0 client-keepalive=30s disabled=yes interface=\
    WG_M_Charl_iPhone name=WG_P_Charl_iPhone public-key=\
    "XnYgdPqE3Fag4W3gnRv4EO24XkRwe66Nf+RiuhxRXBo="
add allowed-address=0.0.0.0/0 interface=WG_M_5067_CLC-UK name=\
    WG_P_5066_CLC-UK-8KBS persistent-keepalive=30s public-key=\
    "mwYsZA8ksWC0kyzZ/WrCt9l5dCq/liejIKZN3k9VGVM="
add allowed-address=0.0.0.0/0 interface=WG_M_5065_BBID-Windmeul name=\
    WG_P_5065_BBID-Windmeul persistent-keepalive=30s public-key=\
    "VC5w4c26Dmd6hAK0y5GLZq11F/8MLqfvbzcLB4srQDM="
/ip address
add address=10.11.5.250/24 interface=VLAN1005 network=10.11.5.0
add address=10.11.100.149/30 interface=VLAN1005 network=10.11.100.148
add address=10.15.67.251/24 interface=WG_M_5067_CLC-UK network=10.15.67.0
add address=10.10.3.1/30 interface=VLAN3003-Internet network=10.10.3.0
/ip cloud
set ddns-enabled=yes
/ip dhcp-client
add default-route-distance=150 interface=VLAN3003-Internet
/ip dhcp-server lease
add address=10.11.5.239 client-id=1:98:df:82:5c:d5:95 mac-address=\
    98:DF:82:5C:D5:95 server=LAN.DHCP_Server
add address=10.11.5.199 client-id=1:b4:2e:99:fd:19:b9 mac-address=\
    B4:2E:99:FD:19:B9 server=LAN.DHCP_Server
add address=10.11.5.206 mac-address=84:9D:C2:96:0D:49 server=LAN.DHCP_Server
add address=10.11.5.205 client-id=1:b4:8c:9d:f4:82:9d mac-address=\
    B4:8C:9D:F4:82:9D server=LAN.DHCP_Server
add address=10.11.5.4 client-id=1:14:7d:da:b6:ef:48 mac-address=\
    14:7D:DA:B6:EF:48 server=LAN.DHCP_Server
add address=10.11.5.9 client-id=1:a0:6f:aa:43:bf:e mac-address=\
    A0:6F:AA:43:BF:0E server=LAN.DHCP_Server
add address=10.11.5.6 client-id=1:14:c9:13:6f:28:2 mac-address=\
    14:C9:13:6F:28:02 server=LAN.DHCP_Server
/ip dhcp-server network
add address=10.11.5.0/24 caps-manager=10.11.5.250 dns-server=10.11.5.250 \
    domain=8KBS_Home gateway=10.11.5.250
add address=10.99.0.0/24 domain=MGMT_1005
add address=192.168.99.0/24 domain=UKLAN gateway=192.168.99.1
add address=192.168.100.0/24 dns-server=192.168.100.1 gateway=192.168.100.1
/ip dns
set allow-remote-requests=yes servers=8.8.8.8
/ip firewall address-list
add address=10.6.0.7 list=nordvpn-dynamic-ip
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
add action=accept chain=input dst-port=13231,15067 in-interface=\
    VLAN3003-Internet protocol=udp
add action=drop chain=forward out-interface=VLAN3003-Internet src-address=\
    192.168.99.0/24
add action=drop chain=input connection-state=invalid,new in-interface=\
    VLAN3003-Internet
/ip firewall mangle
add action=mark-routing chain=prerouting in-interface=WG_M_5067_CLC-UK \
    new-routing-mark=to-vlan3003
/ip firewall nat
add action=masquerade chain=srcnat out-interface=VLAN3003-Internet \
    src-address=10.11.5.0/24
/ip ipsec identity
add auth-method=eap certificate="" disabled=yes eap-methods=eap-mschapv2 \
    generate-policy=port-strict mode-config=NordVPN peer=NordVPN \
    policy-template-group=NordVPN username=SNJu1gGxHCra5u1v8e9npG1o
/ip ipsec policy
set 0 disabled=yes
add disabled=yes dst-address=0.0.0.0/0 group=NordVPN src-address=0.0.0.0/0 \
    template=yes
/ip route
add disabled=no distance=140 dst-address=10.11.0.0/16 gateway=10.11.100.150 \
    pref-src=10.11.5.250 routing-table=main suppress-hw-offload=no
add disabled=yes distance=10 dst-address=0.0.0.0/0 gateway=10.6.0.7 \
    routing-table=via-NorthVPN scope=30 suppress-hw-offload=no target-scope=\
    10
add disabled=yes distance=10 dst-address=192.168.99.0/24 gateway=\
    VLAN3105-NORD routing-table=via-NorthVPN scope=10 suppress-hw-offload=no \
    target-scope=5
add disabled=yes distance=1 dst-address=192.168.100.2/32 gateway=0.0.0.0 \
    routing-table=main scope=30 suppress-hw-offload=no target-scope=10
add disabled=no distance=140 dst-address=10.12.0.0/14 gateway=10.11.100.150 \
    routing-table=main scope=30 suppress-hw-offload=no target-scope=10
add comment=RFC6890_Private_Range distance=149 dst-address=0.0.0.0/8 gateway=\
    10.11.100.150
add comment=RFC6890_Private_Range distance=149 dst-address=10.0.0.0/8 \
    gateway=10.11.100.150
add comment=RFC6890_Private_Range distance=149 dst-address=100.64.0.0/10 \
    gateway=10.11.100.150
add comment=RFC6890_Private_Range distance=149 dst-address=127.0.0.0/8 \
    gateway=10.11.100.150
add comment=RFC6890_Private_Range distance=149 dst-address=169.254.0.0/16 \
    gateway=10.11.100.150
add comment=RFC6890_Private_Range distance=149 dst-address=172.16.0.0/12 \
    gateway=10.11.100.150
add comment=RFC6890_Private_Range distance=149 dst-address=192.0.0.0/24 \
    gateway=10.11.100.150
add comment=RFC6890_Private_Range distance=149 dst-address=192.0.2.0/24 \
    gateway=10.11.100.150
add comment=RFC6890_Private_Range disabled=no distance=149 dst-address=\
    192.168.0.0/16 gateway=10.11.100.150 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
add comment=RFC3068_Private_Range distance=149 dst-address=192.88.99.0/24 \
    gateway=10.11.100.150
add comment=RFC6890_Private_Range distance=149 dst-address=198.18.0.0/15 \
    gateway=10.11.100.150
add comment=RFC6890_Private_Range distance=149 dst-address=198.51.100.0/24 \
    gateway=10.11.100.150
add comment=RFC6890_Private_Range distance=149 dst-address=203.0.113.0/24 \
    gateway=10.11.100.150
add comment=RFC4601_Private_Range distance=149 dst-address=224.0.0.0/4 \
    gateway=10.11.100.150
add comment=RFC6890_Private_Range distance=149 dst-address=240.0.0.0/4 \
    gateway=10.11.100.150
add disabled=no dst-address=0.0.0.0/0 gateway="" routing-table=to-vlan3003 \
    suppress-hw-offload=no
add disabled=no dst-address=0.0.0.0/0 gateway=10.11.5.247 routing-table=\
    via-NorthVPN suppress-hw-offload=no
add disabled=no distance=1 dst-address=10.11.5.0/24 gateway=VLAN1005 \
    routing-table=via-NorthVPN scope=10 suppress-hw-offload=no target-scope=5
add disabled=no distance=149 dst-address=0.0.0.0/0 gateway=10.11.100.150 \
    routing-table=via-Core scope=30 suppress-hw-offload=no target-scope=10
/routing rule
add action=lookup disabled=no src-address=10.11.5.24/32 table=via-Core
add action=lookup disabled=yes src-address=10.11.5.9/32 table=via-NorthVPN
add action=lookup disabled=yes src-address=10.11.5.6/32 table=via-NorthVPN
add action=lookup disabled=yes src-address=10.11.5.4/32 table=via-NorthVPN
/system clock
set time-zone-name=Africa/Johannesburg
/system identity
set name=1005_MTIK_netPower
/system logging
add topics=wireless,debug
