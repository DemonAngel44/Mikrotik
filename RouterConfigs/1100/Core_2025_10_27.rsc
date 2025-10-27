# 2025-10-27 15:05:21 by RouterOS 7.20.1
# software id = LYSU-Q66R
#
# model = CCR1072-1G-8S+
# serial number = 727206808AEA
/interface bridge
add frame-types=admit-only-vlan-tagged name=IDNI.CORE-Bridge vlan-filtering=\
    yes
add name=MANAGEMENT_CONFIG
/interface sstp-server
add name=<sstp-BBID-0003> user=BBID-0003
add name=<sstp-BW-0014-SSTP> user=BW-0014-SSTP
add name=<sstp-BW-0015-SSTP> user=BW-0015-SSTP
/interface ethernet
set [ find default-name=ether1 ] advertise="10M-baseT-half,10M-baseT-full,100M\
    -baseT-half,100M-baseT-full,1G-baseT-half,1G-baseT-full"
set [ find default-name=sfp-sfpplus1 ] disabled=yes name=\
    sfp-sfpplus1-Disabled
set [ find default-name=sfp-sfpplus2 ] name=sfp-sfpplus2-VPSSwitch1
set [ find default-name=sfp-sfpplus3 ] name=sfp-sfpplus3-8KBS-Switch1
set [ find default-name=sfp-sfpplus4 ] name=sfp-sfpplus4-VCIDOfficeSwitch1
set [ find default-name=sfp-sfpplus5 ] name=sfp-sfpplus5-26PBSSwitch1
set [ find default-name=sfp-sfpplus6 ] disabled=yes name=\
    sfp-sfpplus6-Disabled
set [ find default-name=sfp-sfpplus7 ] name=sfp-sfpplus7-CameraSwitchNew
set [ find default-name=sfp-sfpplus8 ] name=sfp-sfpplus8-VVGChurch
/interface l2tp-client
add connect-to=ACC-CPT.home-connect.co.za name=Internet_Static_IP user=\
    86fd-57fa@home-connect.co.za
/interface l2tp-server
add name=<VPS-RianaWessels> user=VPS-RianaWessels
add name=<l2tp-ADM-Charl> user=ADM-Charl
add name=<l2tp-ADM-CobusBuckle> user=ADM-CobusBuckle
add name=<l2tp-ADM-Leon> user=ADM-Leon
add name=<l2tp-ADM-Paul> user=ADM-Paul
add name=<l2tp-ADM-RemoteConfig> user=ADM-RemoteConfig
add name=<l2tp-BBID-0001> user=BBID-0001
add name=<l2tp-BBID-0002> user=BBID-0002
add name=<l2tp-BBID-0003> user=BBID-0003
add name=<l2tp-BBID-0004> user=BBID-0004
add name=<l2tp-BBID-0005> user=BBID-0005
add name=<l2tp-BOLT-0001> user=BOLT-0001
add name=<l2tp-BOLT-0002> user=BOLT-0002
add comment=10.11.250.1 name=<l2tp-BW-0001> user=BW-0001
add name=<l2tp-BW-0002> user=BW-0002
add name=<l2tp-BW-0004> user=BW-0004
add name=<l2tp-BW-0005> user=BW-0005
add name=<l2tp-BW-0006> user=BW-0006
add name=<l2tp-BW-0007> user=BW-0007
add name=<l2tp-BW-0008> user=BW-0008
add name=<l2tp-BW-0009> user=BW-0009
add name=<l2tp-BW-0010> user=BW-0010
add name=<l2tp-BW-0011> user=BW-0011
add name=<l2tp-BW-0012> user=BW-0012
add name=<l2tp-BW-0013> user=BW-0013
add name=<l2tp-BW-0014> user=BW-0014
add name=<l2tp-BW-0015> user=BW-0015
add name=<l2tp-BW-0016> user=BW-0016
add name=<l2tp-BW-0017> user=BW-0017
add name=<l2tp-CLC-Azure> user=CLC-Azure
add name=<l2tp-DeviceToConfigure> user=DeviceToConfigure
add name=<l2tp-SJC-0001> user=SJC-0001
add name=<l2tp-SJC-0002> user=SJC-0002
add name=<l2tp-SJC-0003> user=SJC-0003
add name=<l2tp-SJC-0004> user=SJC-0004
add name=<l2tp-SJC-0005> user=SJC-0005
add name=<l2tp-VCID-0002> user=VCID-0002
add name=<l2tp-VCID-0003> user=VCID-0003
/interface wireguard
add comment="BBID-WindMeul Str" disabled=yes listen-port=15065 mtu=1420 name=\
    WG_M_5065_BBID-Windmeul
add comment="CLC-Connection to the UK" disabled=yes listen-port=15066 mtu=\
    1420 name=WG_M_5066_CLC-UK
add disabled=yes listen-port=15068 mtu=1280 name=WG_M_5068_CLC-3C_BELMET
add disabled=yes listen-port=15069 mtu=1420 name=\
    WG_M_5069_CLC-NHW_CobusBuckle_Landskroon
/interface vlan
add interface=IDNI.CORE-Bridge name=MGMT-VLAN99 vlan-id=99
add interface=IDNI.CORE-Bridge name="VLAN1000 - VCID OFFICE" vlan-id=1000
add interface=IDNI.CORE-Bridge name="VLAN1001 - VCID 26 PBS" vlan-id=1001
add interface=IDNI.CORE-Bridge name="VLAN1001_64 - VCID 26PBSA" vlan-id=64
add interface=IDNI.CORE-Bridge name="VLAN1001_65 - VCID 26PBSB" vlan-id=65
add interface=IDNI.CORE-Bridge name="VLAN1001_66 - VCID 26PBSC" vlan-id=66
add interface=IDNI.CORE-Bridge name="VLAN1001_67 - VCID 26PBS WIFI APs" \
    vlan-id=67
add interface=IDNI.CORE-Bridge name="VLAN1002 - VCID 26PBS Boundary" vlan-id=\
    1002
add interface=IDNI.CORE-Bridge name="VLAN1003 - VCID MAST" vlan-id=1003
add interface=IDNI.CORE-Bridge name="VLAN1004 - VCID ECHO 3 - GH" vlan-id=\
    1004
add interface=IDNI.CORE-Bridge name="VLAN1005 - VCID 8 KBS" vlan-id=1005
add interface=IDNI.CORE-Bridge name="VLAN1006 - VCID TOLKEN" vlan-id=1006
add interface=IDNI.CORE-Bridge name="VLAN1007 - VCID Villa De Vie" vlan-id=\
    1007
add interface=IDNI.CORE-Bridge name="VLAN1008 - VCID VPS MCS" vlan-id=1008
add interface=IDNI.CORE-Bridge name="VLAN1010 - VCID ECHO 2 - LPR" vlan-id=\
    1010
add interface=IDNI.CORE-Bridge name="VLAN1012 - VCID VPS" vlan-id=1012
add interface=IDNI.CORE-Bridge name="VLAN1012_10 - VPS LAN" vlan-id=10
add interface=IDNI.CORE-Bridge name="VLAN1012_20 - VPS IPCAMERAS" vlan-id=20
add interface=IDNI.CORE-Bridge name="VLAN1012_30 VPS WIFI APs" vlan-id=30
add interface=IDNI.CORE-Bridge name="VLAN1012_40 - VPS IPPhones" vlan-id=40
add interface=IDNI.CORE-Bridge name="VLAN1012_50 - VPS WIFIClients" vlan-id=\
    50
add interface=IDNI.CORE-Bridge name="VLAN1012_51 - VPS GuestWIFIClients" \
    vlan-id=51
add interface=IDNI.CORE-Bridge name="VLAN1013 - VCID BETTER CALL" vlan-id=\
    1013
add interface=IDNI.CORE-Bridge name="VLAN1015 - NWP HILLCREST" vlan-id=1015
add interface=IDNI.CORE-Bridge name="VLAN1016 - VCID ECHO 1 - MCS" vlan-id=\
    1016
add interface=IDNI.CORE-Bridge name="VLAN1017 - VCID ECHO 1 - GH LPR" \
    vlan-id=1017
add interface=IDNI.CORE-Bridge name="VLAN1020 - VCID 23 WLS" vlan-id=1020
add interface=IDNI.CORE-Bridge name="VLAN1021 - VCID Welgelee" vlan-id=1021
add interface=IDNI.CORE-Bridge name="VLAN1037 - BBID N1 MCS" vlan-id=1037
add interface=IDNI.CORE-Bridge name="VLAN1038 - VCID 24MPS" vlan-id=1038
add interface=IDNI.CORE-Bridge name="VLAN1042 - BBID BRACKVIEW HS" vlan-id=\
    1042
add interface=IDNI.CORE-Bridge name="VLAN1050 - VCID WG" vlan-id=1050
add interface=IDNI.CORE-Bridge name="VLAN1051 - VCID RAISED INTERSECTION" \
    vlan-id=1051
add interface=IDNI.CORE-Bridge name="VLAN1100 - IDNI CORE NETWORKING" \
    vlan-id=1100
add interface=IDNI.CORE-Bridge name="VLAN1101 - IDNI CORE SERVERS" vlan-id=\
    1101
add interface=IDNI.CORE-Bridge name="VLAN1102 - IDNI CORE SERVERS MGMT" \
    vlan-id=1102
add interface=IDNI.CORE-Bridge name="VLAN3000 - 1000_INTERNET" vlan-id=3000
add interface=IDNI.CORE-Bridge name="VLAN3002 - 1012_INTERNET" vlan-id=3002
add interface=IDNI.CORE-Bridge name="VLAN3003 - 1005_INTERNET" vlan-id=3003
add interface=IDNI.CORE-Bridge name="VLAN3010 - FRIEND OF GOD" vlan-id=3010
add interface=IDNI.CORE-Bridge name="VLAN3102 - VCID 26 PBSA" vlan-id=3102
add interface=IDNI.CORE-Bridge name="VLAN3103 - VCID 26 PBSB" vlan-id=3103
/caps-man security
add authentication-types=wpa2-psk encryption=aes-ccm group-encryption=aes-ccm \
    name=IDNI.WIFI.Security
add authentication-types=wpa2-psk encryption=aes-ccm group-encryption=aes-ccm \
    name=VVG.WIFI.Security
add authentication-types=wpa2-psk encryption=aes-ccm group-encryption=aes-ccm \
    name=IDNI.P2MP.Omnitik.Security
add authentication-types=wpa2-psk encryption=aes-ccm group-encryption=aes-ccm \
    name=IDNI.P2MP.Sector.Security
add authentication-types=wpa2-psk encryption=aes-ccm group-encryption=aes-ccm \
    name=IDNI.P2MP.Security2
add authentication-types=wpa2-psk encryption=aes-ccm group-encryption=aes-ccm \
    name=IDNI.P2P.3rdParty
add authentication-types=wpa2-psk encryption=aes-ccm group-encryption=aes-ccm \
    name=IDNI.P2P.3rdParty.BW
add authentication-types=wpa2-psk encryption=aes-ccm group-encryption=aes-ccm \
    name=IDNI.P2P.VCID
add authentication-types=wpa2-psk encryption=aes-ccm group-encryption=aes-ccm \
    name=VVG.WIFI.Guest.Security
add authentication-types=wpa2-psk encryption=aes-ccm group-encryption=aes-ccm \
    name=IDNI.P2P.3rdPartySecurity2
/interface list
add exclude=dynamic name=discover
/interface lte apn
set [ find default=yes ] ip-type=ipv4 use-network-apn=no
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/iot lora servers
add address=eu.mikrotik.thethings.industries name=TTN-EU protocol=UDP
add address=us.mikrotik.thethings.industries name=TTN-US protocol=UDP
add address=eu1.cloud.thethings.industries name="TTS Cloud (eu1)" protocol=\
    UDP
add address=nam1.cloud.thethings.industries name="TTS Cloud (nam1)" protocol=\
    UDP
add address=au1.cloud.thethings.industries name="TTS Cloud (au1)" protocol=\
    UDP
add address=eu1.cloud.thethings.network name="TTN V3 (eu1)" protocol=UDP
add address=nam1.cloud.thethings.network name="TTN V3 (nam1)" protocol=UDP
add address=au1.cloud.thethings.network name="TTN V3 (au1)" protocol=UDP
/ip ipsec proposal
set [ find default=yes ] auth-algorithms=sha256,sha1
/ip pool
add name=IDNI.1100.POOL ranges=192.168.2.1-192.168.2.249
add name=IDNI.VPN.POOL ranges=10.11.253.1-10.11.255.253
add name=dhcp_pool2 ranges=192.168.1.1-192.168.1.249
add name=dhcp_pool3 ranges=192.168.1.51-192.168.1.110
add name=dhcp_pool4 ranges=10.11.101.201-10.11.101.249
/ip dhcp-server
add add-arp=yes address-pool=dhcp_pool4 interface=\
    "VLAN1101 - IDNI CORE SERVERS" lease-time=59m name=1101.DHCP
/ip smb users
set [ find default=yes ] disabled=yes
/port
set 0 name=serial0
set 1 name=serial1
/ppp profile
add name=VPN
add change-tcp-mss=yes local-address=IDNI.VPN.POOL name=IDNI.VPN-L2TP \
    remote-address=IDNI.VPN.POOL use-encryption=yes
add change-tcp-mss=yes name="Static IP Address Profile" use-encryption=yes
/interface l2tp-client
add connect-to=197.234.160.1 name=IDNI.INTERNET-STATIC-VPN.1100 profile=\
    "Static IP Address Profile" user=86fd-57fa@home-connect.co.za
/routing bgp instance
add as=65000 name=bgp-instance-1 router-id=10.15.1.1
add as=65000 name=bgp-instance-2 router-id=10.15.1.5
add as=65000 name=bgp-instance-3 router-id=10.15.1.9
/routing bgp template
set default as=65530 disabled=no output.network=bgp-networks
/routing ospf instance
add disabled=yes name=default-v2 router-id=10.110.100.250
add disabled=no name=default-v3 version=3
/routing ospf area
add disabled=yes instance=default-v2 name=backbone-v2
add disabled=yes instance=default-v3 name=backbone-v3
/routing table
add fib name=RouteViaSCH
add fib name=RouteViaVCID
add fib name=RouteViaVVG
add fib name=RouteVia8KBS
add fib name=CobusBuckleRoutes
add comment="Vredekloof Primary School" disabled=no fib name=InternetVia1012
add comment="CLC Offices" disabled=no fib name=InternetVia1005
add comment="VCID Offices" disabled=no fib name=InternetVia1000
/snmp community
set [ find default=yes ] addresses=0.0.0.0/0
/user group
add name=TheDudeOnly policy="read,test,winbox,web,sniff,api,rest-api,!local,!t\
    elnet,!ssh,!ftp,!reboot,!write,!policy,!password,!sensitive,!romon"
/interface vlan
add disabled=yes interface=*1F21 name="VLAN2001 - COBUS BUCKLE" vlan-id=2001
/dude
set data-directory=nvme1
/interface bridge filter
add action=drop chain=forward in-interface=sfp-sfpplus2-VPSSwitch1 \
    mac-protocol=vlan vlan-id=1
add action=drop chain=input in-interface=sfp-sfpplus2-VPSSwitch1 \
    mac-protocol=vlan vlan-id=1
/interface bridge port
add bridge=IDNI.CORE-Bridge frame-types=admit-only-vlan-tagged interface=\
    sfp-sfpplus5-26PBSSwitch1
add bridge=IDNI.CORE-Bridge frame-types=admit-only-vlan-tagged interface=\
    sfp-sfpplus3-8KBS-Switch1
add bridge=IDNI.CORE-Bridge frame-types=\
    admit-only-untagged-and-priority-tagged interface=sfp-sfpplus8-VVGChurch \
    pvid=3010
add bridge=IDNI.CORE-Bridge frame-types=admit-only-vlan-tagged interface=\
    sfp-sfpplus2-VPSSwitch1
add bridge=IDNI.CORE-Bridge frame-types=admit-only-vlan-tagged interface=\
    sfp-sfpplus4-VCIDOfficeSwitch1
add bridge=IDNI.CORE-Bridge frame-types=admit-only-vlan-tagged interface=\
    sfp-sfpplus7-CameraSwitchNew
add bridge=MANAGEMENT_CONFIG interface=MGMT-VLAN99 trusted=yes
add bridge=MANAGEMENT_CONFIG interface="VLAN1038 - VCID 24MPS" trusted=yes
/ip neighbor discovery-settings
set discover-interface-list=all
/ipv6 settings
set disable-ipv6=yes forward=no
/interface bridge vlan
add bridge=IDNI.CORE-Bridge tagged=sfp-sfpplus3-8KBS-Switch1,IDNI.CORE-Bridge \
    vlan-ids=1005
add bridge=IDNI.CORE-Bridge disabled=yes tagged=sfp-sfpplus8-VVGChurch \
    vlan-ids=3001
add bridge=IDNI.CORE-Bridge tagged=IDNI.CORE-Bridge untagged=\
    sfp-sfpplus8-VVGChurch vlan-ids=3010
add bridge=IDNI.CORE-Bridge tagged=\
    sfp-sfpplus2-VPSSwitch1,sfp-sfpplus3-8KBS-Switch1,IDNI.CORE-Bridge \
    vlan-ids=3002
add bridge=IDNI.CORE-Bridge tagged=sfp-sfpplus2-VPSSwitch1,IDNI.CORE-Bridge \
    vlan-ids=10
add bridge=IDNI.CORE-Bridge tagged=sfp-sfpplus2-VPSSwitch1,IDNI.CORE-Bridge \
    vlan-ids=20
add bridge=IDNI.CORE-Bridge tagged=sfp-sfpplus2-VPSSwitch1,IDNI.CORE-Bridge \
    vlan-ids=30
add bridge=IDNI.CORE-Bridge tagged=sfp-sfpplus2-VPSSwitch1,IDNI.CORE-Bridge \
    vlan-ids=40
add bridge=IDNI.CORE-Bridge tagged=sfp-sfpplus2-VPSSwitch1,IDNI.CORE-Bridge \
    vlan-ids=50
add bridge=IDNI.CORE-Bridge tagged=sfp-sfpplus2-VPSSwitch1,IDNI.CORE-Bridge \
    vlan-ids=51
add bridge=IDNI.CORE-Bridge tagged=sfp-sfpplus2-VPSSwitch1,IDNI.CORE-Bridge \
    vlan-ids=1012
add bridge=IDNI.CORE-Bridge tagged=sfp-sfpplus2-VPSSwitch1,IDNI.CORE-Bridge \
    vlan-ids=1101
add bridge=IDNI.CORE-Bridge tagged=sfp-sfpplus2-VPSSwitch1,IDNI.CORE-Bridge \
    vlan-ids=1102
add bridge=IDNI.CORE-Bridge tagged=sfp-sfpplus3-8KBS-Switch1,IDNI.CORE-Bridge \
    vlan-ids=3003
add bridge=IDNI.CORE-Bridge tagged=sfp-sfpplus3-8KBS-Switch1,IDNI.CORE-Bridge \
    vlan-ids=99
add bridge=IDNI.CORE-Bridge tagged=\
    sfp-sfpplus7-CameraSwitchNew,IDNI.CORE-Bridge vlan-ids=1003
add bridge=IDNI.CORE-Bridge tagged=\
    sfp-sfpplus7-CameraSwitchNew,IDNI.CORE-Bridge vlan-ids=1004
add bridge=IDNI.CORE-Bridge tagged=\
    sfp-sfpplus7-CameraSwitchNew,IDNI.CORE-Bridge vlan-ids=1006
add bridge=IDNI.CORE-Bridge tagged=\
    sfp-sfpplus7-CameraSwitchNew,IDNI.CORE-Bridge vlan-ids=1007
add bridge=IDNI.CORE-Bridge tagged=\
    sfp-sfpplus7-CameraSwitchNew,sfp-sfpplus8-VVGChurch,IDNI.CORE-Bridge \
    vlan-ids=1008
add bridge=IDNI.CORE-Bridge tagged=\
    sfp-sfpplus7-CameraSwitchNew,IDNI.CORE-Bridge vlan-ids=1010
add bridge=IDNI.CORE-Bridge tagged=\
    sfp-sfpplus7-CameraSwitchNew,IDNI.CORE-Bridge vlan-ids=1013
add bridge=IDNI.CORE-Bridge tagged=\
    sfp-sfpplus7-CameraSwitchNew,IDNI.CORE-Bridge vlan-ids=1015
add bridge=IDNI.CORE-Bridge tagged=\
    sfp-sfpplus7-CameraSwitchNew,IDNI.CORE-Bridge vlan-ids=1016
add bridge=IDNI.CORE-Bridge tagged=\
    sfp-sfpplus7-CameraSwitchNew,IDNI.CORE-Bridge vlan-ids=1017
add bridge=IDNI.CORE-Bridge tagged=\
    sfp-sfpplus7-CameraSwitchNew,IDNI.CORE-Bridge vlan-ids=1020
add bridge=IDNI.CORE-Bridge tagged=\
    sfp-sfpplus7-CameraSwitchNew,IDNI.CORE-Bridge vlan-ids=1021
add bridge=IDNI.CORE-Bridge tagged=\
    sfp-sfpplus7-CameraSwitchNew,IDNI.CORE-Bridge vlan-ids=1038
add bridge=IDNI.CORE-Bridge tagged=\
    sfp-sfpplus7-CameraSwitchNew,IDNI.CORE-Bridge vlan-ids=1050
add bridge=IDNI.CORE-Bridge tagged=\
    sfp-sfpplus7-CameraSwitchNew,IDNI.CORE-Bridge vlan-ids=1051
add bridge=IDNI.CORE-Bridge tagged=\
    sfp-sfpplus7-CameraSwitchNew,IDNI.CORE-Bridge vlan-ids=1100
add bridge=IDNI.CORE-Bridge tagged=\
    sfp-sfpplus4-VCIDOfficeSwitch1,IDNI.CORE-Bridge vlan-ids=1000
add bridge=IDNI.CORE-Bridge tagged=\
    sfp-sfpplus4-VCIDOfficeSwitch1,IDNI.CORE-Bridge vlan-ids=3000
add bridge=IDNI.CORE-Bridge tagged=sfp-sfpplus5-26PBSSwitch1,IDNI.CORE-Bridge \
    vlan-ids=64
add bridge=IDNI.CORE-Bridge tagged=sfp-sfpplus5-26PBSSwitch1,IDNI.CORE-Bridge \
    vlan-ids=65
add bridge=IDNI.CORE-Bridge tagged=sfp-sfpplus5-26PBSSwitch1,IDNI.CORE-Bridge \
    vlan-ids=66
add bridge=IDNI.CORE-Bridge tagged=sfp-sfpplus5-26PBSSwitch1,IDNI.CORE-Bridge \
    vlan-ids=67
add bridge=IDNI.CORE-Bridge tagged=sfp-sfpplus5-26PBSSwitch1,IDNI.CORE-Bridge \
    vlan-ids=1001
add bridge=IDNI.CORE-Bridge tagged=sfp-sfpplus5-26PBSSwitch1,IDNI.CORE-Bridge \
    vlan-ids=1002
add bridge=IDNI.CORE-Bridge tagged=sfp-sfpplus5-26PBSSwitch1,IDNI.CORE-Bridge \
    vlan-ids=1042
add bridge=IDNI.CORE-Bridge tagged=sfp-sfpplus5-26PBSSwitch1,IDNI.CORE-Bridge \
    vlan-ids=3102
add bridge=IDNI.CORE-Bridge tagged=sfp-sfpplus5-26PBSSwitch1,IDNI.CORE-Bridge \
    vlan-ids=3103
add bridge=IDNI.CORE-Bridge tagged=\
    sfp-sfpplus7-CameraSwitchNew,IDNI.CORE-Bridge vlan-ids=1037
/interface l2tp-server server
set authentication=mschap2 default-profile=IDNI.VPN-L2TP enabled=yes \
    keepalive-timeout=60 use-ipsec=yes
/interface list member
add interface=sfp-sfpplus1-Disabled list=discover
add interface=sfp-sfpplus2-VPSSwitch1 list=discover
add interface=<l2tp-ADM-Charl> list=discover
add interface=<l2tp-BBID-0001> list=discover
add interface=<l2tp-BBID-0002> list=discover
add interface="VLAN1015 - NWP HILLCREST" list=discover
add interface="VLAN1000 - VCID OFFICE" list=discover
add interface="VLAN1001 - VCID 26 PBS" list=discover
add interface="VLAN1003 - VCID MAST" list=discover
add interface=*96 list=discover
add interface="VLAN1010 - VCID ECHO 2 - LPR" list=discover
add interface=*57 list=discover
add interface="VLAN1012 - VCID VPS" list=discover
add interface="VLAN1016 - VCID ECHO 1 - MCS" list=discover
add interface="VLAN1017 - VCID ECHO 1 - GH LPR" list=discover
add interface="VLAN1020 - VCID 23 WLS" list=discover
add interface="VLAN3000 - 1000_INTERNET" list=discover
add interface=<l2tp-BOLT-0001> list=discover
add interface=<l2tp-BW-0001> list=discover
add interface=<l2tp-BW-0002> list=discover
add interface=<l2tp-SJC-0001> list=discover
add interface=<l2tp-SJC-0002> list=discover
add interface=<l2tp-SJC-0003> list=discover
add interface=<l2tp-SJC-0004> list=discover
add interface=<l2tp-SJC-0005> list=discover
add interface=sfp-sfpplus3-8KBS-Switch1 list=discover
add interface=sfp-sfpplus4-VCIDOfficeSwitch1 list=discover
add interface=sfp-sfpplus5-26PBSSwitch1 list=discover
add interface=sfp-sfpplus6-Disabled list=discover
add interface=sfp-sfpplus7-CameraSwitchNew list=discover
add interface=sfp-sfpplus8-VVGChurch list=discover
add interface=sfp-sfpplus1-Disabled list=*2000012
add interface=sfp-sfpplus2-VPSSwitch1 list=*2000012
add interface=<l2tp-ADM-Charl> list=*2000012
add interface=<l2tp-BBID-0001> list=*2000012
add interface=<l2tp-BBID-0002> list=*2000012
add interface="VLAN1015 - NWP HILLCREST" list=*2000012
add interface=IDNI.INTERNET-STATIC-VPN.1100 list=*2000012
add interface=<l2tp-BOLT-0001> list=*2000012
add interface=<l2tp-SJC-0001> list=*2000012
add interface=<l2tp-SJC-0002> list=*2000012
add interface=<l2tp-SJC-0003> list=*2000012
add interface=<l2tp-DeviceToConfigure> list=*2000012
add interface=<l2tp-SJC-0004> list=*2000012
add interface=<l2tp-SJC-0005> list=*2000012
add interface=<l2tp-BW-0002> list=*2000012
add interface="VLAN1003 - VCID MAST" list=*2000012
add interface="VLAN1016 - VCID ECHO 1 - MCS" list=*2000012
add interface=*96 list=*2000012
add interface="VLAN1012 - VCID VPS" list=*2000012
add interface="VLAN1042 - BBID BRACKVIEW HS" list=*2000012
add interface="VLAN1013 - VCID BETTER CALL" list=*2000012
add interface=<l2tp-BW-0004> list=*2000012
add interface=<l2tp-VCID-0002> list=*2000012
add interface=<l2tp-BW-0005> list=*2000012
add interface=<l2tp-BW-0006> list=*2000012
add interface=<l2tp-BW-0007> list=*2000012
add interface=<l2tp-ADM-Leon> list=*2000012
add interface=<l2tp-VCID-0003> list=*2000012
add interface=<l2tp-BW-0008> list=*2000012
add interface=<l2tp-BW-0009> list=*2000012
add interface="VLAN1004 - VCID ECHO 3 - GH" list=*2000012
add interface="VLAN1005 - VCID 8 KBS" list=*2000012
add interface=<l2tp-BW-0010> list=*2000012
add interface=*1F2C list=*2000012
add interface=*1F2D list=*2000012
add interface="VLAN1101 - IDNI CORE SERVERS" list=*2000012
add interface=*2246 list=*2000012
add interface=*2247 list=*2000012
add interface=*2248 list=*2000012
add interface=*2249 list=*2000012
add interface=*224A list=*2000012
add interface=*224B list=*2000012
add interface=*224C list=*2000012
add interface=*224D list=*2000012
add interface=*224E list=*2000012
add interface=*224F list=*2000012
add interface=*2250 list=*2000012
add interface=*2251 list=*2000012
add interface=*2252 list=*2000012
add interface=*2254 list=*2000012
add interface=*2255 list=*2000012
add interface=*2257 list=*2000012
add interface=*2258 list=*2000012
add interface=*2259 list=*2000012
add interface=*225A list=*2000012
add interface=*225B list=*2000012
add interface=*225C list=*2000012
add interface=*225D list=*2000012
add interface=*225E list=*2000012
add interface=*225F list=*2000012
add interface=*2260 list=*2000012
add interface=*2261 list=*2000012
add interface=*2262 list=*2000012
add interface=*2263 list=*2000012
add interface=*2264 list=*2000012
add interface=*2265 list=*2000012
add interface=*2266 list=*2000012
add interface=*2267 list=*2000012
add interface=*2268 list=*2000012
add interface=*2269 list=*2000012
add interface=*226A list=*2000012
add interface=*226B list=*2000012
add interface=*226D list=*2000012
add interface=*226E list=*2000012
add interface=*226F list=*2000012
add interface=*2270 list=*2000012
add interface=*2271 list=*2000012
add interface=*2272 list=*2000012
add interface=*2273 list=*2000012
add interface=*2274 list=*2000012
add interface=*2276 list=*2000012
add interface=*2277 list=*2000012
add interface=*2278 list=*2000012
add interface=*2279 list=*2000012
add interface="VLAN2001 - COBUS BUCKLE" list=*2000012
add interface=*319A list=*2000012
add interface=<l2tp-ADM-RemoteConfig> list=*2000012
add interface=<l2tp-ADM-CobusBuckle> list=*2000012
add interface=<l2tp-BW-0011> list=*2000012
add interface=<l2tp-BOLT-0002> list=*2000012
add interface=<l2tp-BW-0012> list=*2000012
add interface="VLAN1038 - VCID 24MPS" list=*2000012
add interface=<l2tp-BBID-0003> list=*2000012
add interface=<l2tp-BW-0013> list=*2000012
add interface=<l2tp-ADM-Paul> list=*2000012
add interface=*A9B0 list=*2000012
add interface=<l2tp-BBID-0004> list=*2000012
add interface="VLAN3102 - VCID 26 PBSA" list=*2000012
add interface="VLAN3103 - VCID 26 PBSB" list=*2000012
add interface=<l2tp-CLC-Azure> list=*2000012
add interface=<sstp-BBID-0003> list=*2000012
add interface=Internet_Static_IP list=*2000012
add interface=<l2tp-BW-0014> list=*2000012
add interface=<l2tp-BW-0015> list=*2000012
add interface=<l2tp-BW-0016> list=*2000012
add interface=<l2tp-BBID-0005> list=*2000012
add interface=<l2tp-BW-0017> list=*2000012
add interface=<sstp-BW-0014-SSTP> list=*2000012
add interface=<sstp-BW-0015-SSTP> list=*2000012
add interface=lo list=*2000012
add interface=IDNI.CORE-Bridge list=*2000012
add interface=WG_M_5065_BBID-Windmeul list=*2000012
add interface=WG_M_5066_CLC-UK list=*2000012
/interface pptp-server server
# PPTP connections are considered unsafe, it is suggested to use a more modern VPN protocol instead
set default-profile=default
/interface sstp-server server
set authentication=mschap2 certificate="VPN SERVER CERTIFICATE" enabled=yes \
    mrru=1600 verify-client-certificate=yes
/interface wireguard peers
add allowed-address=0.0.0.0/0 disabled=yes interface=WG_M_5065_BBID-Windmeul \
    name=WG_P_5065_BBID-Windmeul persistent-keepalive=30s public-key=\
    "VC5w4c26Dmd6hAK0y5GLZq11F/8MLqfvbzcLB4srQDM="
add allowed-address=0.0.0.0/0 disabled=yes interface=WG_M_5066_CLC-UK name=\
    WG_P_5066_CLC-UK persistent-keepalive=30s public-key=\
    "WYC1PyCICBEUpMGM6oie8z8f3kjvOpNYihl19feAG1k="
add allowed-address=0.0.0.0/0 disabled=yes interface=WG_M_5068_CLC-3C_BELMET \
    name=WG_P_5068_CLC-3C_BELMET persistent-keepalive=10s public-key=\
    "V1qbaHlywcokTp6z4HuWObkAkBsYF3WODnhOnXcAhlA="
add allowed-address=0.0.0.0/0 disabled=yes interface=\
    WG_M_5069_CLC-NHW_CobusBuckle_Landskroon name=\
    WG_P_5069_CLC-NHW_CobusBuckle_Landskroon persistent-keepalive=30s \
    public-key="AiHrVezzJGcRgCFYCJUoYyyH91A64a8MbGAruhsRsxk="
/ip address
add address=10.11.100.250/24 interface="VLAN1100 - IDNI CORE NETWORKING" \
    network=10.11.100.0
add address=10.11.100.246/30 interface="VLAN1012 - VCID VPS" network=\
    10.11.100.244
add address=10.11.100.206/30 interface="VLAN1000 - VCID OFFICE" network=\
    10.11.100.204
add address=192.168.1.250/24 interface=sfp-sfpplus8-VVGChurch network=\
    192.168.1.0
add address=10.11.100.226/30 interface="VLAN1010 - VCID ECHO 2 - LPR" \
    network=10.11.100.224
add address=10.11.100.202/30 interface="VLAN1017 - VCID ECHO 1 - GH LPR" \
    network=10.11.100.200
add address=10.11.100.254/30 disabled=yes interface="VLAN1020 - VCID 23 WLS" \
    network=10.11.100.252
add address=10.11.100.222/30 interface="VLAN3000 - 1000_INTERNET" network=\
    10.11.100.220
add address=10.11.100.190/30 interface="VLAN1015 - NWP HILLCREST" network=\
    10.11.100.188
add address=10.11.100.186/30 interface="VLAN1003 - VCID MAST" network=\
    10.11.100.184
add address=10.11.100.182/30 interface="VLAN1016 - VCID ECHO 1 - MCS" \
    network=10.11.100.180
add address=10.11.100.234/30 interface="VLAN1020 - VCID 23 WLS" network=\
    10.11.100.232
add address=10.11.100.178/30 interface="VLAN1004 - VCID ECHO 3 - GH" network=\
    10.11.100.176
add address=10.11.100.174/30 interface="VLAN1003 - VCID MAST" network=\
    10.11.100.172
add address=10.11.101.250/24 interface="VLAN1101 - IDNI CORE SERVERS" \
    network=10.11.101.0
add address=10.11.100.162/30 interface="VLAN1042 - BBID BRACKVIEW HS" \
    network=10.11.100.160
add address=10.11.100.158/30 interface="VLAN1013 - VCID BETTER CALL" network=\
    10.11.100.156
add address=10.11.100.154/30 interface=sfp-sfpplus2-VPSSwitch1 network=\
    10.11.100.152
add address=10.11.100.150/30 interface="VLAN1005 - VCID 8 KBS" network=\
    10.11.100.148
add address=10.11.100.146/30 interface=sfp-sfpplus4-VCIDOfficeSwitch1 \
    network=10.11.100.144
add address=10.11.100.1/27 comment=\
    "CORE Connected Camera Recorders (.2 - .14)" interface=\
    sfp-sfpplus4-VCIDOfficeSwitch1 network=10.11.100.0
add address=10.11.102.250/24 interface="VLAN1102 - IDNI CORE SERVERS MGMT" \
    network=10.11.102.0
add address=10.11.100.210/30 interface="VLAN3102 - VCID 26 PBSA" network=\
    10.11.100.208
add address=10.11.100.138/30 interface="VLAN1038 - VCID 24MPS" network=\
    10.11.100.136
add address=10.11.1.250/24 interface="VLAN1001 - VCID 26 PBS" network=\
    10.11.1.0
add address=10.15.1.1/30 interface=WG_M_5065_BBID-Windmeul network=10.15.1.0
add address=10.15.1.5/30 interface=WG_M_5066_CLC-UK network=10.15.1.4
add address=10.15.1.9/30 interface=WG_M_5068_CLC-3C_BELMET network=10.15.1.8
add address=10.15.1.13/30 interface=WG_M_5069_CLC-NHW_CobusBuckle_Landskroon \
    network=10.15.1.12
add address=192.168.254.1/30 interface="VLAN3002 - 1012_INTERNET" network=\
    192.168.254.0
add address=10.10.0.2/30 interface="VLAN3000 - 1000_INTERNET" network=\
    10.10.0.0
add address=10.10.2.2/30 interface="VLAN3002 - 1012_INTERNET" network=\
    10.10.2.0
add address=10.10.3.2/30 interface="VLAN3003 - 1005_INTERNET" network=\
    10.10.3.0
add address=10.11.8.250/24 interface="VLAN1008 - VCID VPS MCS" network=\
    10.11.8.0
add address=10.11.7.250/24 interface="VLAN1007 - VCID Villa De Vie" network=\
    10.11.7.0
add address=10.11.50.250/24 interface="VLAN1050 - VCID WG" network=10.11.50.0
add address=10.11.21.250/24 interface="VLAN1021 - VCID Welgelee" network=\
    10.11.21.0
add address=10.11.51.250/24 interface="VLAN1051 - VCID RAISED INTERSECTION" \
    network=10.11.51.0
add address=10.11.2.250/24 interface="VLAN1002 - VCID 26PBS Boundary" \
    network=10.11.2.0
add address=192.168.67.250/24 interface="VLAN1001_67 - VCID 26PBS WIFI APs" \
    network=192.168.67.0
add address=192.168.66.250/24 interface="VLAN1001_66 - VCID 26PBSC" network=\
    192.168.66.0
add address=192.168.65.250/24 interface="VLAN1001_65 - VCID 26PBSB" network=\
    192.168.65.0
add address=192.168.64.250/24 interface="VLAN1001_64 - VCID 26PBSA" network=\
    192.168.64.0
add address=10.11.38.250/24 interface="VLAN1038 - VCID 24MPS" network=\
    10.11.38.0
add address=10.11.37.250/24 interface="VLAN1037 - BBID N1 MCS" network=\
    10.11.37.0
/ip cloud
set ddns-enabled=yes update-time=no
/ip dhcp-server network
add address=10.11.101.0/24 dns-server=10.11.101.240 gateway=10.11.101.250
add address=192.168.1.0/24 dns-server=1.1.1.1,8.8.8.8 gateway=192.168.1.250
/ip dns
set allow-remote-requests=yes cache-size=4096KiB servers=8.8.8.8
/ip dns static
add address=10.11.101.201 name=VMS09-iDrac type=A
add address=10.11.102.200 name=VMS09 type=A
add address=10.11.101.202 name=ADDC01 type=A
add address=10.11.101.208 name=MTIK01 type=A
add address=10.11.101.205 name=MSQL01 type=A
add address=10.11.101.206 name=ANPR01 type=A
add address=10.11.101.203 name=SPKI01 type=A
add address=10.11.101.204 name=WSUS01 type=A
add address=10.11.101.207 name=RPKI01 type=A
add forward-to=10.11.101.202 regexp=".*\\.idni\\.local\$" type=FWD
add address=10.11.101.212 name=ProxyManager.idni.co.za type=A
add address=10.11.101.212 name=dockers.idni.co.za type=A
add address=10.11.101.212 name=inv.idni.co.za type=A
add address=10.11.101.212 name=23wls.idni.co.za type=A
/ip firewall address-list
add address=10.11.25.0/24 comment="Site1025 - BBID LPR FC WEST - OUT" \
    disabled=yes list=Private_Range-Allowed
add address=10.11.26.0/24 comment="Site1026 - BBID LPR OP EAST - OUT" \
    disabled=yes list=Private_Range-Allowed
add address=10.11.27.0/24 comment="Site1027 - BBID LPR FC WEST - IN" \
    disabled=yes list=Private_Range-Allowed
add address=10.11.29.0/24 comment="Site1029 - BBID LPR OP WEST - IN" \
    disabled=yes list=Private_Range-Allowed
add address=10.11.100.0/24 comment="Site1100 - IDNI THE CORE" disabled=yes \
    list=Private_Range-Allowed
add address=10.11.190.0/24 comment="Site1190 - UNKNOWN - Decommisioned\?" \
    disabled=yes list=Private_Range-Allowed
add address=10.11.129.0/24 comment="Site1129 - BBID AGRICOL" disabled=yes \
    list=Private_Range-Allowed
add address=10.11.130.0/24 comment="Site1130 - BBID LPR FC EAST - IN" \
    disabled=yes list=Private_Range-Allowed
add address=10.11.131.0/24 comment="Site1131 - BOLT BOERE SJIEK" disabled=yes \
    list=Private_Range-Allowed
add address=10.11.250.0/24 comment=\
    "Site1250 - IDNI VPN SERVICE (EXTERNAL CAMERAs)" disabled=yes list=\
    Private_Range-Allowed
add address=10.11.253.0/24 comment=\
    "Site1253/4 - IDNI VPN SERVICE (CONNECTION POOL)" disabled=yes list=\
    Private_Range-Allowed
add address=10.11.254.0/24 comment=\
    "Site1253/4 - IDNI VPN SERVICE (CONNECTION POOL)" disabled=yes list=\
    Private_Range-Allowed
add address=10.11.23.0/24 comment="Site1023 - BBID PARADYS SPAR" disabled=yes \
    list=Private_Range-Allowed
add address=10.11.7.0/24 comment="Site1007 - VILLA DE VIE (MAIN GATE)" \
    disabled=yes list=Private_Range-Allowed
add address=10.11.40.0/24 comment="Site1040 - BBID OFFICE" disabled=yes list=\
    Private_Range-Allowed
add address=10.11.5.0/24 comment="Site1005 - 8KBS" disabled=yes list=\
    Private_Range-Allowed
add address=10.11.128.0/24 comment="Site1128 - BOTTELARY" disabled=yes list=\
    Private_Range-Allowed
add address=10.11.28.0/24 comment="Site1028 - BBID LPR OP EAST - OUT" \
    disabled=yes list=Private_Range-Allowed
add address=10.11.8.0/24 comment="Site1008 - VCID VREDEKLOOF SCHOOL" \
    disabled=yes list=Private_Range-Allowed
add address=10.11.41.0/24 comment="Site1041 - BBID ROAMING (KIOSK)" disabled=\
    yes list=Private_Range-Allowed
add address=10.11.30.0/24 comment="Site1030 - BBID BFL IND HS" disabled=yes \
    list=Private_Range-Allowed
add address=10.11.31.0/24 comment="Site1031 - BBID BFL IND - IN" disabled=yes \
    list=Private_Range-Allowed
add address=10.11.15.0/24 comment="Site1015 - Tygerberg Caravans" disabled=\
    yes list=Private_Range-Allowed
add address=10.11.0.203 comment="PUBLISHED SERVICE - SMTP Mail Server" \
    disabled=yes list=Public_NatToInternal-Allow
add address=10.11.6.0/24 comment="Site1006 - VVG CHURCH - KIOSK" disabled=yes \
    list=Private_Range-Allowed
add address=10.11.64.0/24 comment=\
    "Site1064 - NCID OFFICE / HS1 (CONTROL ROOM)" disabled=yes list=\
    Private_Range-Allowed
add address=10.11.22.0/24 comment="Site1022 - BBID BFL BLVRD" disabled=yes \
    list=Private_Range-Allowed
add address=10.11.65.0/24 comment="Site1065 - NCID HS2 & CAMERA 1" disabled=\
    yes list=Private_Range-Allowed
add address=10.11.66.0/24 comment="Site1066 - NCID MATARO RD - IN" disabled=\
    yes list=Private_Range-Allowed
add address=10.11.67.0/24 comment="Site1067 - NCID WOLWEFONTEIN RD IN" \
    disabled=yes list=Private_Range-Allowed
add address=10.11.68.0/24 comment="Site1068 - NCID EASTWOOD RD IN" disabled=\
    yes list=Private_Range-Allowed
add address=10.11.69.0/24 comment="Site1069 - NCID HS3" disabled=yes list=\
    Private_Range-Allowed
add address=10.11.70.0/24 comment="Site1070 - NCID HS4" disabled=yes list=\
    Private_Range-Allowed
add address=10.11.71.0/24 comment="Site1071 - NCID BUITEN CRES IN" disabled=\
    yes list=Private_Range-Allowed
add address=10.11.72.0/24 comment="Site1072 - NCID SUNNY WAY HS" disabled=yes \
    list=Private_Range-Allowed
add address=10.11.73.0/24 comment="Site1073 - NCID 24 Montana Drive" \
    disabled=yes list=Private_Range-Allowed
add address=10.11.249.250 comment="Site1002 - BBID via BOLT VPN" disabled=yes \
    list=Private_Range-Allowed
add address=10.11.74.0/24 comment="Site1074 - NCID SUNNY WAY" disabled=yes \
    list=Private_Range-Allowed
add address=10.11.75.0/24 comment="Site1075 - NCID MCS" disabled=yes list=\
    Private_Range-Allowed
add address=10.11.4.0/24 comment="Site1004 - ECHO 3" disabled=yes list=\
    Private_Range-Allowed
add address=10.11.33.0/24 comment="Site1033 - BBID LPR OP WEST - OUT" \
    disabled=yes list=Private_Range-Allowed
add address=10.11.34.0/24 comment="Site1034 - BBID LPR Hiper Fire" disabled=\
    yes list=Private_Range-Allowed
add address=10.11.78.0/24 comment="Site1078 - SCOTTSDENE HS 2" disabled=yes \
    list=Private_Range-Allowed
add address=10.11.77.0/24 comment="Site1077 - SCOTTSDENE HS 1" disabled=yes \
    list=Private_Range-Allowed
add address=10.11.79.0/24 comment="Site1079 - EASTWOOD DRIVE" disabled=yes \
    list=Private_Range-Allowed
add address=10.11.16.0/24 comment="Site1016 - VCID LPR ECHO 1 - IN" disabled=\
    yes list=Private_Range-Allowed
add address=10.11.80.0/24 comment="Site1080 - NORTHPINE PRIMARY" disabled=yes \
    list=Private_Range-Allowed
add address=10.11.12.0/24 comment="Site1012 - VPS School" disabled=yes list=\
    Private_Range-Allowed
add address=192.168.88.0/24 comment=New-Devices disabled=yes list=\
    Private_Range-Allowed
add address=10.11.101.0/24 comment=\
    "Site1101 - IDNI THE CORE - VPS SERVER VLAN" disabled=yes list=\
    Private_Range-Allowed
add address=10.11.102.0/24 comment=\
    "Site1100 - IDNI THE CORE - VPS SERVER VLAN (MGMT)" disabled=yes list=\
    Private_Range-Allowed
add address=10.11.42.0/24 comment="Site1042 - BBID BRACKEN FLATS HIGH SITE" \
    disabled=yes list=Private_Range-Allowed
add address=10.11.43.0/24 comment="Site1043 - BBID BRACKEN FLATS CAMERAS" \
    disabled=yes list=Private_Range-Allowed
add address=10.11.132.0/24 comment="Site1132 - BOLT FORMTEK" disabled=yes \
    list=Private_Range-Allowed
add address=10.11.133.0/24 comment="Site1133 - BOLT OKOVANGO ELECTRICAL" \
    disabled=yes list=Private_Range-Allowed
add address=10.11.82.0/24 comment="Site1082 - NORTHPINE TECHNICAL HS" \
    disabled=yes list=Private_Range-Allowed
add address=10.11.83.0/24 comment="Site1083 - NORTHPINE TECHNICAL GATE" \
    disabled=yes list=Private_Range-Allowed
add address=10.11.84.0/24 comment="Site1084 - NCID KROONDEN RD ALLEY" \
    disabled=yes list=Private_Range-Allowed
add address=10.11.13.0/24 comment="Site1013 - BETTER CALL" disabled=yes list=\
    Private_Range-Allowed
add address=10.11.35.0/24 comment="Site1035 - BBID LPR HERITAGE MOTORS" \
    disabled=yes list=Private_Range-Allowed
add address=10.11.134.0/24 comment="Site1134 - MORGENSTER HOOGTE" disabled=\
    yes list=Private_Range-Allowed
add address=10.11.85.0/24 comment="Site1085 - NORTHPINE LOVIES" disabled=yes \
    list=Private_Range-Allowed
add address=10.11.86.0/24 comment="Site1086 - NCID MOSQUE" disabled=yes list=\
    Private_Range-Allowed
add address=10.11.36.0/24 comment=\
    "Site1036 - BBID LPR BFL BLVRD to PROTEA HEIGHTS" disabled=yes list=\
    Private_Range-Allowed
add address=10.11.87.0/24 comment=\
    "Site1087 - NCID WOLWEFONTEIN TO BUITEN CRES" disabled=yes list=\
    Private_Range-Allowed
add address=10.11.135.0/24 comment="Site1135 - FC EAST OUTBOUND" disabled=yes \
    list=Private_Range-Allowed
add address=10.11.37.0/24 comment="Site1037 - BBID LPR BFL BLVRD GOEDEHOOP" \
    disabled=yes list=Private_Range-Allowed
add address=10.11.38.0/24 comment="Site1037 - BBID RELAY SITE 24 MOPANIE" \
    disabled=yes list=Private_Range-Allowed
add address=10.11.88.0/24 comment="Site1088 - NCID HOWARD TO " disabled=yes \
    list=Private_Range-Allowed
add address=10.11.89.0/24 comment="Site1089 - NCID BURTONDALE" disabled=yes \
    list=Private_Range-Allowed
add address=10.11.81.0/24 comment="Site1081 - NORTHPINE PRIMARY (RELAY)" \
    disabled=yes list=Private_Range-Allowed
add address=10.11.39.0/24 comment="Site1039 - BBID OV NETWERK MAKELAARS" \
    disabled=yes list=Private_Range-Allowed
add address=10.11.52.0/24 comment=\
    "Site1052 - BBID ESSENTIAL HEALTH HIGH SITE" disabled=yes list=\
    Private_Range-Allowed
add address=10.11.44.0/24 comment="Site1044 - BBID SUPERQUICK" disabled=yes \
    list=Private_Range-Allowed
add address=192.168.105.0/24 comment="Site1012 - VPS School (Temp)" disabled=\
    yes list=Private_Range-Allowed
add address=192.168.0.96 comment="Site1020 - 23WLS - YHA" disabled=yes list=\
    Private_Range-Allowed
add address=10.11.90.0/24 comment="Site1090 - NCID KIOSK" disabled=yes list=\
    Private_Range-Allowed
add address=10.11.32.0/24 comment="Site1002 - BBID NINA4" disabled=yes list=\
    Private_Range-Allowed
add address=10.11.45.0/24 comment="Site1045 - BBID - JMC" disabled=yes list=\
    Private_Range-Allowed
add address=10.11.24.0/24 comment="Site1024 - VCID GARAGE" disabled=yes list=\
    Private_Range-Allowed
add address=10.11.46.0/24 comment="Site1045 - BBID - KFC SIGN" disabled=yes \
    list=Private_Range-Allowed
add address=10.11.58.0/24 comment="Site1058 - BBID VIS FABRIEK" disabled=yes \
    list=Private_Range-Allowed
add address=10.20.41.0/24 comment="Site1005 - 8KBS-Kameras" disabled=yes \
    list=Private_Range-Allowed
add address=10.11.91.0/24 comment="Site1091 - NCID EASTWOOD SHOP" disabled=\
    yes list=Private_Range-Allowed
add address=10.11.92.0/24 comment="Site1091 - NCID BAPTIST CHURCH" disabled=\
    yes list=Private_Range-Allowed
add address=0.0.0.0/8 comment=RFC6890 list=Private_Ranges
add address=10.0.0.0/8 comment=RFC6890 list=Private_Ranges
add address=100.64.0.0/10 comment=RFC6890 list=Private_Ranges
add address=127.0.0.0/8 comment=RFC6890 list=Private_Ranges
add address=169.254.0.0/16 comment=RFC6890 list=Private_Ranges
add address=172.16.0.0/12 comment=RFC6890 list=Private_Ranges
add address=192.0.0.0/24 comment=RFC6890 list=Private_Ranges
add address=192.0.2.0/24 comment=RFC6890 list=Private_Ranges
add address=192.168.0.0/16 comment=RFC6890 list=Private_Ranges
add address=192.88.99.0/24 comment=RFC3068 list=Private_Ranges
add address=198.18.0.0/15 comment=RFC6890 list=Private_Ranges
add address=198.51.100.0/24 comment=RFC6890 list=Private_Ranges
add address=203.0.113.0/24 comment=RFC6890 list=Private_Ranges
add address=224.0.0.0/4 comment=RFC4601 list=Private_Ranges
add address=240.0.0.0/4 comment=RFC6890 list=Private_Ranges
add address=10.11.5.250 list=AllowFromVPN
add address=10.11.101.206 list=AllowFromVPN
add address=10.11.5.0/24 list=BGP-OUT
add address=10.11.101.0/24 list=BGP-OUT
add address=10.11.64.0/19 list=NCID_IPS
add address=10.11.96.0/22 list=NCID_IPS
add address=10.11.100.0/24 list=SERV_IPS
add address=10.11.101.0/24 list=SERV_IPS
/ip firewall filter
add action=accept chain=forward dst-address=10.11.0.0/24 src-address=\
    10.11.7.0/24
add action=accept chain=forward dst-address=10.11.5.0/24 src-address=\
    10.11.7.0/24
add action=drop chain=forward src-address=10.11.7.0/24
add action=accept chain=forward dst-address=8.8.8.8
# <l2tp-ADM-CobusBuckle> not ready
# <l2tp-BW-0015> not ready
# <l2tp-ADM-CobusBuckle> not ready
# <l2tp-BW-0015> not ready
add action=accept chain=forward in-interface=<l2tp-ADM-CobusBuckle> \
    out-interface=<l2tp-BW-0015>
# <l2tp-BW-0015> not ready
# <l2tp-ADM-CobusBuckle> not ready
# <l2tp-BW-0015> not ready
# <l2tp-ADM-CobusBuckle> not ready
add action=accept chain=forward in-interface=<l2tp-BW-0015> out-interface=\
    <l2tp-ADM-CobusBuckle>
# <l2tp-ADM-Charl> not ready
# <l2tp-ADM-Charl> not ready
add action=accept chain=forward in-interface=<l2tp-ADM-Charl>
# <l2tp-ADM-Paul> not ready
# <l2tp-ADM-Paul> not ready
add action=accept chain=forward in-interface=<l2tp-ADM-Paul>
# <l2tp-ADM-Leon> not ready
# <l2tp-ADM-Leon> not ready
add action=accept chain=forward in-interface=<l2tp-ADM-Leon>
add action=accept chain=forward comment="ALLOW CAMERA TO INTERNET FOR VISEC" \
    dst-address=!10.11.0.0/16 src-address=10.11.15.239
add action=accept chain=input comment=\
    "ALLOW INBOUND NTP  CONNECTIONS TO ROUTER" dst-address=10.11.100.250 \
    dst-port=123 protocol=udp src-address=10.11.0.0/16
add action=accept chain=input dst-port=500,1701,4500 log-prefix="VPN >>>" \
    protocol=udp
add action=accept chain=output comment=\
    "ALLOW OUTBOUND ROUTER CONNECTIONS TO INTERNET" dst-address-list=\
    !Private_Range
add action=accept chain=input comment=\
    "ALLOW INBOUND DNS  CONNECTIONS TO ROUTER" dst-port=53 protocol=udp
add action=accept chain=forward comment=\
    "ALLOW KNOWN PRIVATE RANGES TO FORWARD TRAFFIC" dst-address-list=\
    Private_Range-Allowed
add action=add-src-to-address-list address-list=IPSourcestoREVIEW \
    address-list-timeout=none-dynamic chain=forward connection-state=\
    invalid,new dst-address-list=Private_Ranges src-address=192.168.0.0/16
add action=add-dst-to-address-list address-list=IPDestnationstoREVIEW \
    address-list-timeout=none-dynamic chain=forward connection-state=\
    invalid,new dst-address-list=Private_Ranges src-address=192.168.0.0/16
add action=drop chain=forward connection-state=invalid,new dst-address-list=\
    Private_Ranges log=yes log-prefix="PRIVATE_DROPPED >>" src-address=\
    192.168.0.0/16
/ip firewall mangle
add action=mark-routing chain=prerouting comment="1000 Inernet Routing" \
    in-interface="VLAN3000 - 1000_INTERNET" new-routing-mark=InternetVia1000
add action=mark-routing chain=prerouting comment="1012 Internet Routing" \
    in-interface="VLAN3002 - 1012_INTERNET" new-routing-mark=InternetVia1000
add action=mark-routing chain=prerouting comment="1005 Internet Routing" \
    in-interface="VLAN3003 - 1005_INTERNET" new-routing-mark=InternetVia1000
/ip firewall nat
add action=dst-nat chain=dstnat disabled=yes dst-port=6280,6281 protocol=tcp \
    src-address=!10.11.0.0/16 to-addresses=10.11.101.206
add action=masquerade chain=srcnat comment="VPN Masquerade rule" \
    out-interface=all-ppp src-address=10.11.0.0/16
add action=masquerade chain=srcnat disabled=yes out-interface=\
    Internet_Static_IP
/ip firewall service-port
set sip disabled=yes
/ip ipsec profile
set [ find default=yes ] dpd-interval=2m dpd-maximum-failures=5
/ip route
add disabled=no distance=120 dst-address=10.11.17.0/24 gateway=10.11.100.201
add disabled=yes distance=110 dst-address=192.168.1.50/32 gateway="" \
    pref-src=10.11.100.230 scope=10
add comment="Cobus Buckle -Camera 1 (LK)" disabled=no distance=100 \
    dst-address=10.11.250.0/29 gateway=<l2tp-BW-0015>
add disabled=no distance=120 dst-address=10.11.5.0/24 gateway=10.11.100.149
add disabled=no distance=120 dst-address=10.11.15.0/24 gateway=10.11.100.189
add comment="Cobus Buckle - Camera 2 (DT ENT)" disabled=yes distance=100 \
    dst-address=10.11.250.2/32 gateway=<l2tp-BW-0015>
add comment="Cobus Buckle - Camera 3 (SJC)" disabled=yes distance=100 \
    dst-address=10.11.250.3/32 gateway=<l2tp-BW-0015>
add comment="Cobus Buckle - Router" disabled=yes distance=100 dst-address=\
    10.11.250.4/32 gateway=<l2tp-BW-0015>
add comment="Cobus Buckle - Wireless Detuin" disabled=yes distance=100 \
    dst-address=10.11.250.5/32 gateway=<l2tp-BW-0015>
add comment="Cobus Buckle - NVR" disabled=yes distance=100 dst-address=\
    10.11.250.6/32 gateway=<l2tp-BW-0015>
add comment="SJC.Sonkring.Blackberry.IN - LPR" disabled=yes distance=100 \
    dst-address=10.11.250.7/32 gateway=<l2tp-SJC-0002>
add comment="SJC.De Tuin - Router" disabled=yes distance=100 dst-address=\
    10.11.250.8/32 gateway=<l2tp-SJC-0003>
add comment="SJC.De Tuin - LPR" disabled=yes distance=100 dst-address=\
    10.11.250.9/32 gateway=<l2tp-SJC-0003>
add comment="Bolt.Office - Router" disabled=yes distance=115 dst-address=\
    10.11.19.250/32 gateway=<l2tp-BOLT-0001> pref-src=10.11.100.250
add comment="DeviceToConfigure (Reserved) - ROUTER" disabled=yes distance=100 \
    dst-address=10.11.250.250/32 gateway=<l2tp-DeviceToConfigure>
add disabled=yes distance=100 dst-address=10.11.250.14/32 gateway=\
    <l2tp-SJC-0004>
add disabled=yes distance=100 dst-address=10.11.250.15/32 gateway=\
    <l2tp-SJC-0004>
add comment="SJC.Sonkring.Groenewoud.OUT - Router" disabled=yes distance=100 \
    dst-address=10.11.250.16/32 gateway=<l2tp-SJC-0005>
add comment="SJC.Sonkring.Groenewoud.OUT - LPR" disabled=yes distance=100 \
    dst-address=10.11.250.17/32 gateway=<l2tp-SJC-0005>
add disabled=no dst-address=10.11.249.250/32 gateway=<l2tp-BOLT-0001> \
    pref-src=10.11.100.250
add disabled=no distance=120 dst-address=10.11.4.0/24 gateway=10.11.100.177
add comment="JS - Router Skepie" disabled=no distance=100 dst-address=\
    10.11.250.20/32 gateway=<l2tp-BW-0002>
add comment="JS - Router Herman" disabled=no distance=100 dst-address=\
    10.11.250.21/32 gateway=<l2tp-BW-0002>
add comment="JS - Router Trix" disabled=no distance=100 dst-address=\
    10.11.250.22/32 gateway=<l2tp-BW-0002>
add comment="JS - Router 1" disabled=no distance=100 dst-address=\
    10.11.250.23/32 gateway=<l2tp-BW-0002>
add comment="JS - Router 1" disabled=no distance=100 dst-address=\
    10.11.250.24/32 gateway=<l2tp-BW-0002>
add comment="JS - Router 1" disabled=no distance=100 dst-address=\
    10.11.250.25/32 gateway=<l2tp-BW-0002>
add disabled=no distance=120 dst-address=10.11.18.0/24 gateway=10.11.100.173
add disabled=no distance=120 dst-address=10.11.3.0/24 gateway=10.11.100.173
add disabled=no distance=125 dst-address=10.11.128.0/20 gateway=10.11.100.173
add disabled=no distance=125 dst-address=10.11.64.0/19 gateway=10.11.100.173
add disabled=no distance=120 dst-address=10.11.16.0/24 gateway=10.11.100.181
add disabled=no distance=120 dst-address=10.11.12.0/24 gateway=10.11.100.245
add disabled=yes distance=120 dst-address=10.11.102.0/24 gateway=\
    10.11.100.245
add disabled=no distance=120 dst-address=10.11.13.0/24 gateway=10.11.100.157 \
    routing-table=main scope=30 suppress-hw-offload=no target-scope=10
add comment="CUSTOM INTERNET GATEWAY" disabled=yes distance=151 dst-address=\
    0.0.0.0/0 gateway=10.11.100.221 pref-src=10.11.100.222 routing-table=\
    RouteViaVCID scope=30 suppress-hw-offload=no target-scope=10
add comment="BBID Botlary MCS" disabled=no distance=100 dst-address=\
    10.11.250.30/32 gateway=<sstp-BBID-0003>
add comment="Malgas Router" disabled=no distance=100 dst-address=\
    10.11.250.50/32 gateway=<l2tp-BW-0005>
add comment="Malgas NVR" disabled=no distance=100 dst-address=10.11.250.51/32 \
    gateway=<l2tp-BW-0005>
add comment="Malgas PowerBox" disabled=no distance=100 dst-address=\
    10.11.250.52/32 gateway=<l2tp-BW-0005>
add comment="Malgas Camera OV1" disabled=no distance=100 dst-address=\
    10.11.250.53/32 gateway=<l2tp-BW-0005>
add comment="Malgas Camera OV2" disabled=no distance=100 dst-address=\
    10.11.250.54/32 gateway=<l2tp-BW-0005>
add comment="Malgas Camera LPR" disabled=no distance=100 dst-address=\
    10.11.250.55/32 gateway=<l2tp-BW-0005>
add comment="Malgas Wireless TP" disabled=no distance=100 dst-address=\
    10.11.250.56/32 gateway=<l2tp-BW-0005>
add comment="Malgas Wireless MCS" disabled=no distance=100 dst-address=\
    10.11.250.57/32 gateway=<l2tp-BW-0005>
add disabled=no distance=120 dst-address=10.11.37.0/24 gateway=10.11.100.137
add disabled=yes distance=121 dst-address=10.11.19.250/32 gateway=\
    <l2tp-BOLT-0001>
add disabled=yes distance=140 dst-address=102.165.224.114/32 gateway=\
    10.11.100.245 routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add comment="SPAR OLD OAK ROUTER" disabled=no distance=100 dst-address=\
    10.11.250.70/32 gateway=<l2tp-BW-0006>
add comment="SPAR OLD OAK LPR1" disabled=no distance=100 dst-address=\
    10.11.250.71/32 gateway=<l2tp-BW-0006>
add comment="SPAR OLD OAK LPR2" disabled=no distance=100 dst-address=\
    10.11.250.72/32 gateway=<l2tp-BW-0006>
add comment="DeviceToConfigure (Reserved) - CAMERA (192.168.1.64)" disabled=\
    yes distance=100 dst-address=10.11.250.251/32 gateway=\
    <l2tp-DeviceToConfigure>
add comment="Danie Tolken - Camera 2" disabled=no distance=100 dst-address=\
    10.11.250.13/32 gateway=<l2tp-BOLT-0001>
add comment="SPAR BRIGHTON ROUTER" disabled=no distance=100 dst-address=\
    10.11.250.80/32 gateway=<l2tp-BW-0007>
add comment="SPAR BRIGHTON NVR" disabled=no distance=100 dst-address=\
    10.11.250.81/32 gateway=<l2tp-BW-0007>
add comment="SPAR BRIGHTON NVR" disabled=no distance=100 dst-address=\
    10.11.250.82/32 gateway=<l2tp-BW-0007>
add comment="SPAR BRIGHTON NVR" disabled=no distance=100 dst-address=\
    10.11.250.83/32 gateway=<l2tp-BW-0007>
add comment="SPAR BRIGHTON NVR" disabled=no distance=100 dst-address=\
    10.11.250.84/32 gateway=<l2tp-BW-0007>
add comment="SPAR BRIGHTON NVR" disabled=no distance=100 dst-address=\
    10.11.250.85/32 gateway=<l2tp-BW-0007>
add comment="SPAR BRIGHTON NVR" disabled=no distance=100 dst-address=\
    10.11.250.86/32 gateway=<l2tp-BW-0007>
add comment="SPAR BRIGHTON NVR" disabled=no distance=100 dst-address=\
    10.11.250.87/32 gateway=<l2tp-BW-0007>
add comment="SPAR BRIGHTON NVR" disabled=no distance=100 dst-address=\
    10.11.250.88/32 gateway=<l2tp-BW-0007>
add comment="SPAR BRIGHTON NVR" disabled=no distance=100 dst-address=\
    10.11.250.89/32 gateway=<l2tp-BW-0007>
add comment="SPAR BRIGHTON NVR" disabled=no distance=100 dst-address=\
    10.11.250.90/32 gateway=<l2tp-BW-0007>
add disabled=no distance=121 dst-address=10.11.19.251/32 gateway=\
    <l2tp-BOLT-0001>
add disabled=yes distance=110 dst-address=10.11.22.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.43.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.42.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.34.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=no distance=110 dst-address=10.11.23.0/24 gateway=10.11.37.253 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.29.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.33.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.40.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.41.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.27.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.25.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.19.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.52.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.44.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.35.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.36.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.39.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.14.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.30.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.31.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.26.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.28.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add comment="BELMET-MAIN WORKSHOP 2" disabled=no distance=100 dst-address=\
    10.11.250.183/32 gateway=<l2tp-BW-0008>
add comment=BELMET-PRONTO disabled=no distance=100 dst-address=\
    10.11.250.184/32 gateway=<l2tp-BW-0008>
add comment="BELMET-MAIN WORKSHOP 1" disabled=no distance=100 dst-address=\
    10.11.250.185/32 gateway=<l2tp-BW-0008>
add comment=BELMET-CANTEEN disabled=no distance=100 dst-address=\
    10.11.250.186/32 gateway=<l2tp-BW-0008>
add comment="BELMET-MCM SHEDS" disabled=no distance=100 dst-address=\
    10.11.250.187/32 gateway=<l2tp-BW-0008>
add comment="BELMET-SMALL HEAVY" disabled=no distance=100 dst-address=\
    10.11.250.188/32 gateway=<l2tp-BW-0008>
add comment="BELMET-MAIN HEAVY" disabled=no distance=100 dst-address=\
    10.11.250.189/32 gateway=<l2tp-BW-0008>
add disabled=no distance=110 dst-address=10.11.20.0/24 gateway=10.11.100.233 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=no distance=110 dst-address=10.11.11.0/24 gateway=10.11.100.225 \
    scope=20
add disabled=no distance=110 dst-address=10.11.10.0/24 gateway=10.11.100.225 \
    scope=20
add disabled=no distance=110 dst-address=10.11.9.0/24 gateway=10.11.100.225 \
    scope=20
add disabled=no distance=110 dst-address=10.11.0.0/24 gateway=10.11.100.205 \
    scope=20
add comment="CUSTOM INTERNET GATEWAY" disabled=yes distance=151 dst-address=\
    0.0.0.0/0 gateway=192.168.1.1 pref-src=192.168.1.250 routing-table=\
    RouteViaVVG scope=30 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.32.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add comment="Cobus Basson" disabled=no distance=100 dst-address=\
    10.11.250.120/32 gateway=<l2tp-BW-0010>
add comment="Cobus Basson" disabled=no distance=100 dst-address=\
    10.11.250.121/32 gateway=<l2tp-BW-0010>
add comment="Cobus Basson" disabled=no distance=100 dst-address=\
    10.11.250.122/32 gateway=<l2tp-BW-0010>
add comment="Cobus Basson" disabled=no distance=100 dst-address=\
    10.11.250.123/32 gateway=<l2tp-BW-0010>
add comment="Cobus Basson" disabled=no distance=100 dst-address=\
    10.11.250.124/32 gateway=<l2tp-BW-0010>
add comment="Cobus Basson" disabled=yes distance=100 dst-address=\
    10.11.250.125/32 gateway=<l2tp-BW-0011>
add disabled=no distance=120 dst-address=10.11.6.0/24 gateway=10.11.100.177
add disabled=yes distance=110 dst-address=10.11.45.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=no distance=120 dst-address=10.11.24.0/24 gateway=10.11.100.173
add disabled=yes distance=110 dst-address=10.11.46.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.58.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add comment="PRIMARY DEFAULT GATEWAT" disabled=no distance=250 dst-address=\
    0.0.0.0/0 gateway=10.11.100.221 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
add blackhole comment=RFC6890-BLACKHOLE disabled=no distance=249 dst-address=\
    0.0.0.0/8 gateway="" routing-table=main scope=30 suppress-hw-offload=no
add blackhole comment=RFC6890-BLACKHOLE disabled=no distance=249 dst-address=\
    10.0.0.0/8 gateway="" routing-table=main scope=30 suppress-hw-offload=no
add blackhole comment=RFC6890-BLACKHOLE disabled=no distance=249 dst-address=\
    100.64.0.0/10 gateway="" routing-table=main scope=30 suppress-hw-offload=\
    no
add blackhole comment=RFC6890-BLACKHOLE disabled=no distance=249 dst-address=\
    127.0.0.0/8 gateway="" routing-table=main scope=30 suppress-hw-offload=no
add blackhole comment=RFC6890-BLACKHOLE disabled=no distance=249 dst-address=\
    169.254.0.0/16 gateway="" routing-table=main scope=30 \
    suppress-hw-offload=no
add blackhole comment=RFC6890-BLACKHOLE disabled=no distance=249 dst-address=\
    172.16.0.0/12 gateway="" routing-table=main scope=30 suppress-hw-offload=\
    no
add blackhole comment=RFC6890-BLACKHOLE disabled=no distance=249 dst-address=\
    192.0.0.0/24 gateway="" routing-table=main scope=30 suppress-hw-offload=\
    no
add blackhole comment=RFC6890-BLACKHOLE disabled=no distance=249 dst-address=\
    192.0.2.0/24 gateway="" routing-table=main scope=30 suppress-hw-offload=\
    no
add blackhole comment=RFC6890-BLACKHOLE disabled=no distance=249 dst-address=\
    192.168.0.0/16 gateway="" routing-table=main scope=30 \
    suppress-hw-offload=no
add blackhole comment=RFC6890-BLACKHOLE disabled=no distance=249 dst-address=\
    192.88.99.0/24 gateway="" routing-table=main scope=30 \
    suppress-hw-offload=no
add blackhole comment=RFC6890-BLACKHOLE disabled=no distance=249 dst-address=\
    198.18.0.0/15 gateway="" routing-table=main scope=30 suppress-hw-offload=\
    no
add blackhole comment=RFC6890-BLACKHOLE disabled=no distance=249 dst-address=\
    198.51.100.0/24 gateway="" routing-table=main scope=30 \
    suppress-hw-offload=no
add blackhole comment=RFC6890-BLACKHOLE disabled=no distance=249 dst-address=\
    203.0.113.0/24 gateway="" routing-table=main scope=30 \
    suppress-hw-offload=no
add blackhole comment=RFC6890-BLACKHOLE disabled=no distance=249 dst-address=\
    224.0.0.0/4 gateway="" routing-table=main scope=30 suppress-hw-offload=no
add blackhole comment=RFC6890-BLACKHOLE disabled=no distance=249 dst-address=\
    240.0.0.0/4 gateway="" routing-table=main scope=30 suppress-hw-offload=no
add comment="CUSTOM INTERNET GATEWAY" disabled=yes distance=151 dst-address=\
    0.0.0.0/0 gateway=10.11.100.149 pref-src=10.11.100.150 routing-table=\
    RouteVia8KBS scope=30 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.53.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add comment="Remote Device Configuration (Patrick)" disabled=no distance=100 \
    dst-address=10.11.250.100/32 gateway=<l2tp-BOLT-0002>
add comment="Remote Device Configuration (Patrick)" disabled=no distance=100 \
    dst-address=10.11.250.101/32 gateway=<l2tp-BOLT-0002>
add comment="Remote Device Configuration (Patrick)" disabled=no distance=100 \
    dst-address=10.11.250.102/32 gateway=<l2tp-BOLT-0002>
add comment="Remote Device Configuration (Patrick)" disabled=no distance=100 \
    dst-address=10.11.250.103/32 gateway=<l2tp-BOLT-0002>
add comment="Remote Device Configuration (Patrick)" disabled=no distance=100 \
    dst-address=10.11.250.104/32 gateway=<l2tp-BOLT-0002>
add comment="Remote Device Configuration (Patrick)" disabled=no distance=100 \
    dst-address=10.11.250.105/32 gateway=<l2tp-BOLT-0002>
add comment="Cobus Buckle - Camera 1 (LK)" disabled=yes distance=100 \
    dst-address=10.11.72.250/32 gateway=<l2tp-ADM-RemoteConfig>
add disabled=no distance=101 dst-address=192.168.12.0/24 gateway=\
    <l2tp-BW-0015> routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=yes distance=110 dst-address=10.11.47.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add comment="BELMET-3C Metal" disabled=no distance=100 dst-address=\
    10.11.250.190/32 gateway=<l2tp-BW-0008>
add comment="BELMET-3C Metal" disabled=no distance=100 dst-address=\
    10.11.250.191/32 gateway=<l2tp-BW-0008>
add comment="BELMET-3C Metal" disabled=no distance=100 dst-address=\
    10.11.250.192/32 gateway=<l2tp-BW-0008>
add disabled=yes distance=110 dst-address=10.11.59.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add comment="BELMET-3C Metal" disabled=no distance=100 dst-address=\
    10.11.250.199/32 gateway=<l2tp-BW-0008>
add disabled=no distance=110 dst-address=10.11.99.0/24 gateway=10.11.100.173
add comment="BELMET-TRAINING CNTR" disabled=no distance=100 dst-address=\
    10.11.250.193/32 gateway=<l2tp-BW-0008>
add comment="Cobus Buckle - NVR" disabled=no distance=100 dst-address=\
    10.11.250.10/32 gateway=<l2tp-ADM-CobusBuckle>
add disabled=yes distance=110 dst-address=10.11.60.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.48.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=no dst-address=10.11.255.254/32 gateway=<l2tp-ADM-Charl>
add disabled=no dst-address=10.11.255.253/32 gateway=<l2tp-BOLT-0001>
add comment="BOLT - Alutech" disabled=no distance=100 dst-address=\
    10.11.250.95/32 gateway=<l2tp-BOLT-0002>
add comment="BOLT - Alutech" disabled=no distance=100 dst-address=\
    10.11.250.96/32 gateway=<l2tp-BOLT-0002>
add comment="BOLT - Alutech" disabled=no distance=100 dst-address=\
    10.11.250.97/32 gateway=<l2tp-BOLT-0002>
add comment="BOLT - Alutech" disabled=no distance=100 dst-address=\
    10.11.250.98/32 gateway=<l2tp-BOLT-0002>
add comment="BOLT - Alutech" disabled=no distance=100 dst-address=\
    10.11.250.99/32 gateway=<l2tp-BOLT-0002>
add comment="Robert Wiehahn" disabled=no distance=100 dst-address=\
    10.11.250.60/32 gateway=<l2tp-BW-0012>
add comment="Robert Wiehahn" disabled=no distance=100 dst-address=\
    10.11.250.61/32 gateway=<l2tp-BW-0012>
add comment="Robert Wiehahn" disabled=no distance=100 dst-address=\
    10.11.250.62/32 gateway=<l2tp-BW-0012>
add comment="Robert Wiehahn" disabled=no distance=100 dst-address=\
    10.11.250.63/32 gateway=<l2tp-BW-0012>
add comment="Robert Wiehahn" disabled=no distance=100 dst-address=\
    10.11.250.64/32 gateway=<l2tp-BW-0012>
add disabled=no distance=110 dst-address=10.11.98.0/24 gateway=10.11.100.173
add disabled=no distance=120 dst-address=192.168.107.0/24 gateway=\
    10.11.100.245
add disabled=no distance=120 dst-address=192.168.106.0/24 gateway=\
    10.11.100.245
add disabled=yes distance=110 dst-address=10.11.195.0/24 gateway=\
    10.11.100.241 routing-table=main scope=20 suppress-hw-offload=no \
    target-scope=10
add comment="BBID Botlary MCS" disabled=no distance=100 dst-address=\
    10.11.250.31/32 gateway=<sstp-BBID-0003>
add comment="BBID Botlary MCS" disabled=no distance=100 dst-address=\
    10.11.250.32/32 gateway=<sstp-BBID-0003>
add disabled=no dst-address=192.168.12.0/27 gateway=<l2tp-BW-0012>
add disabled=no distance=100 dst-address=10.11.250.45/32 gateway=\
    <l2tp-BW-0013> scope=10
add disabled=no distance=100 dst-address=10.11.250.46/32 gateway=\
    <l2tp-BW-0013> scope=10
add disabled=no distance=100 dst-address=10.11.250.47/32 gateway=\
    <l2tp-BW-0013> scope=10
add disabled=no distance=100 dst-address=10.11.250.48/32 gateway=\
    <l2tp-BW-0013> scope=10
add disabled=no distance=100 dst-address=10.11.250.49/32 gateway=\
    <l2tp-BW-0013> scope=10
add comment=PBester disabled=no distance=100 dst-address=10.11.250.75/32 \
    gateway=<l2tp-ADM-Paul>
add comment=PBester disabled=no distance=100 dst-address=10.11.250.76/32 \
    gateway=<l2tp-ADM-Paul>
add comment="BBID KIOSK" disabled=no distance=100 dst-address=10.11.250.35/32 \
    gateway=<l2tp-BBID-0004>
add comment="BBID KIOSK" disabled=no distance=100 dst-address=10.11.250.36/32 \
    gateway=<l2tp-BBID-0004>
add comment="BBID KIOSK" disabled=no distance=100 dst-address=10.11.250.37/32 \
    gateway=<l2tp-BBID-0004>
add comment="BBID KIOSK" disabled=no distance=100 dst-address=10.11.250.38/32 \
    gateway=<l2tp-BBID-0004>
add comment="BBID KIOSK" disabled=no distance=100 dst-address=10.11.250.39/32 \
    gateway=<l2tp-BBID-0004>
add disabled=no distance=100 dst-address=10.11.250.130/32 gateway=\
    <l2tp-CLC-Azure>
add disabled=no distance=110 dst-address=10.11.96.0/24 gateway=10.11.100.173
add disabled=no distance=110 dst-address=10.11.97.0/24 gateway=10.11.100.173
add disabled=yes distance=110 dst-address=10.11.57.0/24 gateway=10.11.100.161 \
    routing-table=main scope=20 suppress-hw-offload=no target-scope=10
add disabled=yes distance=110 dst-address=10.11.101.223/32 gateway=\
    10.11.100.245
add disabled=yes distance=110 dst-address=10.11.101.224/32 gateway=\
    10.11.100.245
add comment="PRIMARY DEFAULT GATEWAT" disabled=yes distance=151 dst-address=\
    0.0.0.0/0 gateway=Internet_Static_IP routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
add disabled=no distance=100 dst-address=10.11.250.140/32 gateway=\
    <l2tp-BW-0014>
add disabled=no distance=1 dst-address=192.168.1.0/24 gateway=\
    sfp-sfpplus8-VVGChurch pref-src=192.168.1.250 routing-table=RouteViaVVG \
    scope=10 suppress-hw-offload=no target-scope=10
add comment="CUSTOM INTERNET GATEWAY" disabled=yes distance=150 dst-address=\
    0.0.0.0/0 gateway=10.11.100.221 pref-src=10.11.100.222 routing-table=\
    RouteViaVVG scope=30 suppress-hw-offload=no target-scope=10
add comment="Cobus Basson" disabled=no distance=100 dst-address=\
    10.11.250.125/32 gateway=<l2tp-BW-0009>
add comment="Cobus Basson" disabled=no distance=100 dst-address=\
    10.11.250.126/32 gateway=<l2tp-BW-0016>
add disabled=yes distance=110 dst-address=10.11.101.229/32 gateway=\
    10.11.100.245
add disabled=no dst-address=10.11.250.210/32 gateway=<l2tp-BW-0017>
add disabled=no distance=100 dst-address=10.11.250.141/32 gateway=\
    <sstp-BW-0014-SSTP>
add comment="Cobus Buckle - Router" disabled=yes distance=100 dst-address=\
    10.11.250.4/32 gateway=<sstp-BW-0015-SSTP>
add comment="Cobus Buckle - NVR" disabled=yes distance=100 dst-address=\
    10.11.250.6/32 gateway=<sstp-BW-0015-SSTP>
add comment="Cobus Buckle - Wireless Detuin" disabled=yes distance=100 \
    dst-address=10.11.250.5/32 gateway=<sstp-BW-0015-SSTP>
add comment="Cobus Buckle - Camera 3 (SJC)" disabled=yes distance=100 \
    dst-address=10.11.250.3/32 gateway=<sstp-BW-0015-SSTP>
add comment="Cobus Buckle - Camera 2 (DT ENT)" disabled=yes distance=100 \
    dst-address=10.11.250.2/32 gateway=<sstp-BW-0015-SSTP>
add comment="Cobus Buckle - Camera 1 (LK)" disabled=no distance=100 \
    dst-address=10.11.250.0/29 gateway=<sstp-BW-0015-SSTP>
add disabled=no dst-address=10.11.250.19/32 gateway=<l2tp-BBID-0005> scope=10
add comment="Malgas PowerBox" disabled=no distance=100 dst-address=\
    10.11.251.1/32 gateway=""
add disabled=no distance=120 dst-address=156.155.189.60/32 gateway=\
    10.11.100.245 routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=yes distance=149 dst-address=0.0.0.0/0 gateway=102.182.121.97 \
    routing-table=main scope=30 suppress-hw-offload=no target-scope=10
add disabled=no distance=150 dst-address=0.0.0.0/0 gateway=10.11.100.205 \
    routing-table=main scope=30 suppress-hw-offload=no target-scope=10
add disabled=no distance=149 dst-address=0.0.0.0/0 gateway=10.10.0.1 \
    routing-table=InternetVia1000 scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=149 dst-address=0.0.0.0/0 gateway=10.10.2.1 \
    routing-table=InternetVia1012 scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=149 dst-address=0.0.0.0/0 gateway=10.10.3.1 \
    routing-table=InternetVia1005 scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=120 dst-address=10.11.105.0/24 gateway=10.11.101.101 \
    routing-table=main scope=10 suppress-hw-offload=no target-scope=5
add disabled=no distance=120 dst-address=192.168.105.0/24 gateway=\
    10.11.100.245 routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=120 dst-address=192.168.11.0/24 gateway=\
    10.11.100.245 routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=yes distance=120 dst-address=10.11.50.0/24 gateway=10.99.100.241 \
    routing-table=main scope=30 suppress-hw-offload=no target-scope=10
add disabled=no distance=1 dst-address=10.11.100.254/32 gateway=ether1 \
    routing-table=main scope=30 suppress-hw-offload=no target-scope=10
/ip smb shares
set [ find default=yes ] directory=/pub
/ppp l2tp-secret
add
/ppp secret
add disabled=yes local-address=10.11.253.1 name=VriendVanGod remote-address=\
    10.11.253.2 service=sstp
add comment="Cobus Buckle" name=BW-0001 profile=IDNI.VPN-L2TP service=l2tp
add comment="Administrator: Charl Wiehahn" name=ADM-Charl profile=\
    IDNI.VPN-L2TP service=l2tp
add comment="Johan Scheepers" name=BW-0002 profile=IDNI.VPN-L2TP service=l2tp
add comment="BBID (Dormant)" disabled=yes name=BBID-0001 profile=\
    IDNI.VPN-L2TP remote-address=10.11.254.254 service=l2tp
add comment="BBID (Dormant)" disabled=yes name=BBID-0002 profile=\
    IDNI.VPN-L2TP service=l2tp
add comment="VCID (Dormant)" disabled=yes name=VCID-0001 profile=\
    IDNI.VPN-L2TP service=l2tp
add comment="BOLT OFFICE" name=BOLT-0001 profile=IDNI.VPN-L2TP service=l2tp
add disabled=yes name=NCID-0001 profile=IDNI.VPN-L2TP service=l2tp
add disabled=yes name=SJC-0001 profile=IDNI.VPN-L2TP service=l2tp
add comment="INITIAL DEVICE CONFIG ACCOUNT" name=DeviceToConfigure profile=\
    IDNI.VPN-L2TP service=l2tp
add disabled=yes name=SJC-0002 profile=IDNI.VPN-L2TP service=l2tp
add disabled=yes name=SJC-0004 profile=IDNI.VPN-L2TP service=l2tp
add disabled=yes name=SJC-0005 profile=IDNI.VPN-L2TP service=l2tp
add disabled=yes name=SJC-0006 profile=IDNI.VPN-L2TP service=l2tp
add name=BW-0003 profile=IDNI.VPN-L2TP service=l2tp
add name=BW-0004 profile=IDNI.VPN-L2TP service=l2tp
add comment="Malgas LPR" name=BW-0005 profile=IDNI.VPN-L2TP service=l2tp
add comment="SPAR Old Oak" name=BW-0006 profile=IDNI.VPN-L2TP service=l2tp
add comment="SPAR BRIGHTON" name=BW-0007 profile=IDNI.VPN-L2TP service=l2tp
add comment="Leon Brynard" name=ADM-Leon profile=IDNI.VPN-L2TP service=l2tp
add comment="VREDEKLOOF PRIMARY" disabled=yes name=VCID-0003 profile=\
    IDNI.VPN-L2TP service=l2tp
add comment="Leon Brynard" name=LeonBrynard profile=IDNI.VPN-L2TP service=\
    l2tp
add comment=BELMET name=BW-0008 profile=IDNI.VPN-L2TP service=l2tp
add comment="WAYNE - Skool" name=BW-0009 profile=IDNI.VPN-L2TP service=l2tp
add comment="Cobus Basson" name=BW-0010 profile=IDNI.VPN-L2TP service=l2tp
add comment="Administrator: Remote Config" name=ADM-RemoteConfig profile=\
    IDNI.VPN-L2TP service=l2tp
add comment="Cobus Buckle" name=ADM-CobusBuckle profile=IDNI.VPN-L2TP \
    service=l2tp
add comment="Cobus Basson - Kameras" name=BW-0011 profile=IDNI.VPN-L2TP \
    service=l2tp
add comment="BOLT BOERE SHIEK" name=BOLT-0002 profile=IDNI.VPN-L2TP service=\
    l2tp
add comment="Robert Wiehahn" name=BW-0012 profile=IDNI.VPN-L2TP service=l2tp
add comment="BBID Botlary" name=BBID-0003 profile=IDNI.VPN-L2TP service=sstp
add comment="BBID Protea Heights (Neighbourhood Watch)" name=BW-0013 profile=\
    IDNI.VPN-L2TP service=l2tp
add name=ADM-Paul
add comment="BBID KIOSK" name=BBID-0004 profile=IDNI.VPN-L2TP service=l2tp
add name=CLC-Azure profile=IDNI.VPN-L2TP service=l2tp
add comment="Administrator: Jessie Wiehahn" name=ADM-Jessie profile=\
    IDNI.VPN-L2TP service=l2tp
add comment="Jeanne Brynard" name=ADM-Jeanne profile=IDNI.VPN-L2TP service=\
    l2tp
add comment=Annique name=BW-0014 profile=IDNI.VPN-L2TP service=l2tp
add comment="Cobus Buckle" name=BW-0015 profile=IDNI.VPN-L2TP service=l2tp
add comment="BBID Protea Heights (Neighbourhood Watch)" name=NCID-001 \
    profile=IDNI.VPN-L2TP service=l2tp
add comment="WAYNE - Koshuis" name=BW-0016 profile=IDNI.VPN-L2TP service=l2tp
add comment="BBID Windmeul" disabled=yes name=BBID-0005 profile=IDNI.VPN-L2TP \
    service=l2tp
add comment="CHARL - UK_VPN" disabled=yes name=BW-0017 profile=IDNI.VPN-L2TP \
    service=l2tp
add comment=Annique name=BW-0014-SSTP profile=IDNI.VPN-L2TP service=sstp
add comment="Cobus Buckle" name=BW-0015-SSTP profile=IDNI.VPN-L2TP service=\
    sstp
add comment="Cobus Buckle" name=ADM-CobusBuckle-SSTP profile=IDNI.VPN-L2TP \
    service=sstp
add comment="CHARL - DINA" name=BW-0018 profile=IDNI.VPN-L2TP service=l2tp
add comment="Cobus Buckle" name=BW-0019 profile=IDNI.VPN-L2TP service=l2tp
add comment="Jeanne Brynard" name=VPS-RianaWessels profile=IDNI.VPN-L2TP \
    service=l2tp
/routing bfd configuration
add disabled=no interfaces=all min-rx=200ms min-tx=200ms multiplier=5
/routing bgp connection
add connect=yes disabled=no instance=bgp-instance-1 listen=yes local.address=\
    10.15.1.1 .role=ibgp-rr name=RAS5065-BBID_Windmeul nexthop-choice=\
    force-self output.network=BGP-OUT remote.address=10.15.1.2/32 .as=65000 \
    routing-table=main
add connect=yes disabled=no instance=bgp-instance-2 listen=yes local.address=\
    10.15.1.5 .role=ibgp-rr name=RAS5066-CLC_UK nexthop-choice=force-self \
    output.network=BGP-OUT remote.address=10.15.1.6/32 .as=65000 \
    routing-table=main
add connect=yes disabled=no instance=bgp-instance-3 listen=yes local.address=\
    10.15.1.9 .role=ibgp-rr name=RAS5068-CLC-3C_BELMET nexthop-choice=\
    force-self output.network=BGP-OUT remote.address=10.15.1.10/32 .as=65000 \
    routing-table=main
/system clock
set time-zone-autodetect=no time-zone-name=Africa/Harare
/system identity
set name=1100_MTIK-CCR1072-THE_CORE
/system ntp client
set enabled=yes
/system ntp server
set enabled=yes
/system ntp client servers
add address=51.145.123.29
add address=41.175.49.55
/system scheduler
add interval=5m name=SchedulerRemoveDynamicL2TP on-event=RemoveDynamicL2TP \
    policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
/system script
add dont-require-permissions=no name=NTP-Update owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    local primary \"10.11.102.200\"\r\
    \n\r\
    \n/system ntp client set primary-ntp \$primary"
add dont-require-permissions=no name=RemoveDynamicL2TP owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    foreach i in=[/interface l2tp-client find dynamic=yes] do={\r\
    \n    /interface l2tp-client remove \$i\r\
    \n}\r\
    \n"
/tool sniffer
set filter-interface=sfp-sfpplus3-8KBS-Switch1
