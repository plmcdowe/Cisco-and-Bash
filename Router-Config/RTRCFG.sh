# Shell Environment File.
# Environment Variables:
?=0
prc_change_mode=PRC_INVALID
prc_change_type=PRC_INVALID
prc_error_code=PRC_INVALID
prc_failure_type=PRC_INVALID
prc_ha_sync=PRC_INVALID
# Environment Functions:
function RTRCFG()
{
 t=0
 c=0
 cat bootflash:SiteNames
 printf '\n\nCopy & Paste from above into the prompt below.\n'
 read -p ": " s
 if [[ -z "$s" || ( ! $s =~ '^[A-Z]{3,17}$' ) ]]
  then  printf '\nIncorrect input!\n'
  sleep 2
  RTRCFG
  else printf ''
  if [[ `grep $s bootflash:SiteNames` ]]
   then for l in `more bootflash:SiteNets`
    do if [[ "$l" == "$s" ]]
     then t="TRUE"
    fi
    if [[ "$t" == "TRUE" ]]
     then (( c++ ))
     if [[ "$c" -le "31" ]]
      then if [[ "$c" == "1" ]]
       then HOSTNAME="$l"
      fi
      if [[ "$c" == "2" ]]
       then SITE_ID="$l"
      fi
      if [[ "$c" == "3" ]]
       then ISP_IP="$l"
      fi
      if [[ "$c" == "4" ]]
       then ISP_MASK="$l"
      fi
      if [[ "$c" == "5" ]]
       then ISP_GW="$l"
      fi
      if [[ "$c" == "6" ]]
       then PM1_NET="$l"
      fi
      if [[ "$c" == "7" ]]
       then PM1_MASK="$l"
      fi
      if [[ "$c" == "8" ]]
       then IOT1_NET="$l"
      fi
      if [[ "$c" == "9" ]]
       then IOT1_MASK="$l"
      fi
      if [[ "$c" == "10" ]]
       then VOIP_NET="$l"
      fi
      if [[ "$c" == "11" ]]
       then VOIP_MASK="$l"
      fi
      if [[ "$c" == "12" ]]
       then DATA1_NET="$l"
      fi
      if [[ "$c" == "13" ]]
       then DATA1_MASK="$l"
      fi
      if [[ "$c" == "14" ]]
       then DATA2_NET="$l"
      fi
      if [[ "$c" == "15" ]]
       then DATA2_MASK="$l"
      fi
      if [[ "$c" == "16" ]]
       then PM2_NET="$l"
      fi
      if [[ "$c" == "17" ]]
       then PM2_MASK="$l"
      fi
      if [[ "$c" == "18" ]]
       then IOT2_NET="$l"
      fi
      if [[ "$c" == "19" ]]
       then IOT2_MASK="$l"
      fi
      if [[ "$c" == "20" ]]
       then PRINT_NET="$l"
      fi
      if [[ "$c" == "21" ]]
       then PRINT_MASK="$l"
      fi
      if [[ "$c" == "22" ]]
       then IOT3_NET="$l"
      fi
      if [[ "$c" == "23" ]]
       then IOT3_MASK="$l"
      fi
      if [[ "$c" == "24" ]]
       then MGMT_NET="$l"
      fi
      if [[ "$c" == "25" ]]
       then MGMT_MASK="$l"
      fi
      if [[ "$c" == "26" ]]
       then CAPWAP_NET="$l"
      fi
      if [[ "$c" == "27" ]]
       then CAPWAP_MASK="$l"
      fi
      if [[ "$c" == "28" ]]
       then LO_DMVPN_IP="$l"
      fi
      if [[ "$c" == "29" ]]
       then LO_DMVPN_MASK="$l"
      fi
      if [[ "$c" == "30" ]]
       then LO_MGMT_IP="$l"
      fi
      if [[ "$c" == "31" ]]
       then LO_MGMT_MASK="$l"
      fi
      else break
     fi
    fi
   done
   a=`echo $PM1_NET|cut -d "." -f 1`
   b=`echo $PM1_NET|cut -d "." -f 2`
   c=`echo $PM1_NET|cut -d "." -f 3`
   d=`echo $PM1_NET|cut -d "." -f 4`
   (( d = d + 1 ))
   PM1_IP="$a.$b.$c.$d"
   a=`echo $IOT1_NET|cut -d "." -f 1`
   b=`echo $IOT1_NET|cut -d "." -f 2`
   c=`echo $IOT1_NET|cut -d "." -f 3`
   d=`echo $IOT1_NET|cut -d "." -f 4`
   (( d = d + 1 ))
   IOT1_IP="$a.$b.$c.$d"
   a=`echo $VOIP_NET|cut -d "." -f 1`
   b=`echo $VOIP_NET|cut -d "." -f 2`
   c=`echo $VOIP_NET|cut -d "." -f 3`
   d=`echo $VOIP_NET|cut -d "." -f 4`
   (( d = d + 1 ))
   VOIP_IP="$a.$b.$c.$d"
   a=`echo $DATA1_NET|cut -d "." -f 1`
   b=`echo $DATA1_NET|cut -d "." -f 2`
   c=`echo $DATA1_NET|cut -d "." -f 3`
   d=`echo $DATA1_NET|cut -d "." -f 4`
   (( d = d + 1 ))
   DATA1_IP="$a.$b.$c.$d"
   a=`echo $DATA2_NET|cut -d "." -f 1`
   b=`echo $DATA2_NET|cut -d "." -f 2`
   c=`echo $DATA2_NET|cut -d "." -f 3`
   d=`echo $DATA2_NET|cut -d "." -f 4`
   (( d = d + 1 ))
   DATA2_IP="$a.$b.$c.$d"
   a=`echo $PM2_NET|cut -d "." -f 1`
   b=`echo $PM2_NET|cut -d "." -f 2`
   c=`echo $PM2_NET|cut -d "." -f 3`
   d=`echo $PM2_NET|cut -d "." -f 4`
   (( d = d + 1 ))
   PM2_IP="$a.$b.$c.$d"
   a=`echo $IOT2_NET|cut -d "." -f 1`
   b=`echo $IOT2_NET|cut -d "." -f 2`
   c=`echo $IOT2_NET|cut -d "." -f 3`
   d=`echo $IOT2_NET|cut -d "." -f 4`
   (( d = d + 1 ))
   IOT2_IP="$a.$b.$c.$d"
   a=`echo $PRINT_NET|cut -d "." -f 1`
   b=`echo $PRINT_NET|cut -d "." -f 2`
   c=`echo $PRINT_NET|cut -d "." -f 3`
   d=`echo $PRINT_NET|cut -d "." -f 4`
   (( d = d + 1 ))
   PRINT_IP="$a.$b.$c.$d"
   a=`echo $IOT3_NET|cut -d "." -f 1`
   b=`echo $IOT3_NET|cut -d "." -f 2`
   c=`echo $IOT3_NET|cut -d "." -f 3`
   d=`echo $IOT3_NET|cut -d "." -f 4`
   (( d = d + 1 ))
   IOT3_IP="$a.$b.$c.$d"
   a=`echo $MGMT_NET|cut -d "." -f 1`
   b=`echo $MGMT_NET|cut -d "." -f 2`
   c=`echo $MGMT_NET|cut -d "." -f 3`
   d=`echo $MGMT_NET|cut -d "." -f 4`
   (( d = d + 1 ))
   MGMT_IP="$a.$b.$c.$d"
   a=`echo $CAPWAP_NET|cut -d "." -f 1`
   b=`echo $CAPWAP_NET|cut -d "." -f 2`
   c=`echo $CAPWAP_NET|cut -d "." -f 3`
   d=`echo $CAPWAP_NET|cut -d "." -f 4`
   (( d = d + 1 ))
   CAPWAP_IP="$a.$b.$c.$d"
   conf t
   hostname $HOSTNAME-RTR
   interface Loopback!DMVPN-ID
   description PM Systems Tunnel Source
   ip address $LO_DMVPN_IP !NET.MASK.NET.MASK
   no shut
   interface Loopback!MGMT-ID
   description MGMT Tunnel Source
   ip address $LO_MGMT_IP !NET.MASK.NET.MASK
   no shut
   no service pad
   no platform punt-keepalive disable-kernel-core
   no ip ftp passive
   no ip ftp source-interface
   no ip tftp source-interface
   no ip telnet source-interface
   no ip source-route
   no ip gratuitous-arps
   no platform punt-keepalive disable-kernel-core
   no ip domain lookup
   no ip http server
   no ip http secure-server
   no ip http client source-interface
   no ip bootp server
   no ip dhcp use vrf connected
   no ip forward-protocol udp netbios-ns
   no ip forward-protocol udp netbios-dgm
   service tcp-keepalives-in
   service timestamps debug datetime localtime
   service timestamps log datetime localtime
   service password-encryption
   service password-encryption
   service tcp-keepalives-in
   service timestamps debug datetime localtime
   service timestamps log datetime localtime
   platform qfp utilization monitor load 80
   ip tcp synwait-time 10
   ip forward-protocol nd
   vtp domain !DOMAIN
   vtp mode transparent
   authentication mac-move permit
   ipv6 unicast-routing
   diagnostic bootup level minimal
   archive
   log config
   logging enable
   notify syslog contenttype plaintext
   hidekeys
   clock timezone EST -5 0
   clock summer-time EST recurring 2 Sun Mar 2:00 2 Sun Nov 2:00
   ntp authenticate
   ntp authentication-key 123 hmac-sha2-256 !YourNTPauthKey
   ntp trusted-key 123
   ntp source Loopback!MGMT-ID
   ntp server !ALT.DMVPN.LO.IP key 123
   ntp server !PRIM.DMVPN.LO.IP key 123 prefer
   flow record FLOW_RS_RECORD
   match ipv4 tos
   match ipv4 protocol
   match ipv4 source address
   match ipv4 destination address
   match transport source-port
   match transport destination-port
   match interface input
   collect routing next-hop address ipv4
   collect ipv4 dscp
   collect ipv4 ttl minimum
   collect ipv4 ttl maximum
   collect transport tcp flags
   collect interface output
   collect counter bytes
   collect counter packets
   collect timestamp sys-uptime first
   collect timestamp sys-uptime last
   collect application name
   flow exporter FLOW_EXPORTER
   destination !IP.IP.IP.IP
   source Loopback!MGMT-ID
   dscp 63
   transport udp 9999
   flow monitor FLOW_MONITOR
   exporter FLOW_EXPORTER
   cache timeout active 60
   record FLOW_RS_RECORD
   logging source-interface Loopback!MGMT-ID
   ip tacacs source-interface Loopback!MGMT-ID
   ip name-server !DC.DNS.NTP.IP !DC.DNS.NTP.IP
   ip domain name !your.domain.here
   crypto key generate rsa general-keys modulus 2048
   aaa new-model
   aaa group server tacacs+ ISE_TACACS
   server YOUR-ISE-HOST
   server YOUR-ISE-HOST
   server YOUR-ISE-HOST
   aaa authentication login default group ISE_TACACS local
   aaa authentication enable default group ISE_TACACS enable
   aaa authorization console
   aaa authorization config-commands
   aaa accounting exec default start-stop group ISE_TACACS
   aaa accounting commands 1 default start-stop group ISE_TACACS
   aaa accounting commands 15 default start-stop group ISE_TACACS
   aaa common-criteria policy PASSWORD_POLICY
   min-length 15
   max-length 127
   numeric-count 1
   upper-case 1
   lower-case 1
   special-case 1
   char-changes 8
   aaa session-id common
   vrf definition !PM1
   description PM1
   rd $SITE_ID:!PM1-ID
   address-family ipv4
   exit-address-family
   address-family ipv6
   exit-address-family
   vrf definition DMVPN
   description Main DMVPN
   rd $SITE_ID:!DMVPN-ID
   address-family ipv4
   exit-address-family
   address-family ipv6
   exit-address-family
   vrf definition IOT1
   description IOT1
   rd $SITE_ID:!IOT1-ID
   address-family ipv4
   exit-address-family
   address-family ipv6
   exit-address-family
   vrf definition PM2
   description PM2
   rd $SITE_ID:!PM2-ID
   address-family ipv4
   exit-address-family
   address-family ipv6
   exit-address-family
   vrf definition !IOT2
   description !IOT2
   rd $SITE_ID:!IOT2-ID
   address-family ipv4
   exit-address-family
   address-family ipv6
   exit-address-family
   vrf definition MGMT
   description Network Management
   rd $SITE_ID:!MGMT-ID
   address-family ipv4
   exit-address-family
   address-family ipv6
   exit-address-family
   ip route vrf DMVPN !NET.MASK.NET.MASK !NET.MASK.NET.MASK $ISP_GW
   ip sla 1
   icmp-echo !PRIM.HUB.LO.IP source-interface Loopback!MGMT-ID
   frequency 10
   track 1 ip sla 1 reachability
   ip sla schedule 1 life forever start-time now
   ip route !NET.MASK.NET.MASK !NET.MASK.NET.MASK !PRIM.HUB.LO.IP track 1
   ip route !NET.MASK.NET.MASK !NET.MASK.NET.MASK !ALT.HUB.LO.IP 20
   crypto ikev2 proposal IKE-PROPOSAL-STD25
   encryption aes-cbc-256
   integrity sha256
   group 19
   crypto ikev2 policy IKE-POLICY-STD25
   proposal IKE-PROPOSAL-STD25
   match fvrf any
   crypto ikev2 dpd 10 3 periodic
   crypto ikev2 keyring IKE-KEYRING-STD25
   peer DMVPN-SF
   address !PRIM.SITE.ISP.IP
   pre-shared-key !YourIKEv2pskHere
   peer DMVPN-CA
   address !ALT.SITE.ISP.IP
   pre-shared-key !YourIKEv2pskHere
   peer DMVPN-SPOKE
   address !NET.MASK.NET.MASK !NET.MASK.NET.MASK
   pre-shared-key !YourIKEv2pskHere
   peer DMVPN-PEER-V6
   address ::/0
   pre-shared-key !YourIKEv2pskHere
   crypto ikev2 profile IKE-PROFILE-STD25
   match fvrf DMVPN
   match identity remote any
   authentication remote pre-share
   authentication local pre-share
   keyring local IKE-KEYRING-STD25
   crypto ipsec transform-set IPSEC-SET-STD25 esp-aes 256 esp-sha256-hmac
   mode transport
   crypto ipsec profile IPSEC-PROFILE-STD25
   set transform-set IPSEC-SET-STD25
   set ikev2-profile IKE-PROFILE-STD25
   set pfs group19
   crypto ipsec profile IPSEC-PROFILE-STD25-V6
   set transform-set IPSEC-SET-STD25
   set ikev2-profile IKE-PROFILE-STD25
   set pfs group19
   crypto ipsec df-bit set
   crypto ipsec fragmentation after-encryption
   key chain OSP
   key 1
   key-string !YourOSPFkeyString1Here
   accept-lifetime 00:00:00 31 Dec 2023 23:59:00 30 Jun 2024
   send-lifetime 00:00:00 31 Dec 2023 23:59:00 30 Jun 2024
   cryptographic-algorithm hmac-sha-256
   key 2
   key-string !YourOSPFkeyString2Here
   accept-lifetime 00:00:00 30 Jun 2024 23:59:00 31 Dec 2024
   send-lifetime 00:00:00 30 Jun 2024 23:59:00 31 Dec 2024
   cryptographic-algorithm hmac-sha-256
   key 3
   key-string !YourOSPFkeyString3Here
   accept-lifetime 00:00:00 31 Dec 2024 23:59:00 30 Jun 2025
   send-lifetime 00:00:00 31 Dec 2024 23:59:00 30 Jun 2025
   cryptographic-algorithm hmac-sha-256
   key 4
   key-string !YourOSPFkeyString4Here
   accept-lifetime 00:00:00 30 Jun 2025 23:59:00 31 Dec 2025
   send-lifetime 00:00:00 30 Jun 2025 23:59:00 31 Dec 2025
   cryptographic-algorithm hmac-sha-256
   ip dhcp excluded-address $PM1_IP
   ip dhcp excluded-address $IOT1_IP
   ip dhcp excluded-address $VOIP_IP
   ip dhcp excluded-address $IOT2_IP
   ip dhcp excluded-address $IOT3_IP
   ip dhcp pool !PM1
   network $PM1_NET $PM1_MASK
   default-router $PM1_IP
   ip dhcp pool !IOT1
   network $IOT1_NET $IOT1_MASK
   default-router $IOT1_IP
   ip dhcp pool !IOT2
   network $IOT2_NET $IOT2_MASK
   default-router $IOT2_IP
   ip dhcp pool !IOT3
   network $IOT3_NET $IOT3_MASK
   default-router $IOT3_IP
   ip dhcp pool !VOICE
   network $VOIP_NET $VOIP_MASK
   default-router $VOIP_IP
   option 150 ip !CUCM.PUB.IP.IP !CUCM.PUB.IP.IP !CUCM.PUB.IP.IP
   login block-for 900 attempts 3 within 120
   login quiet-mode access-class SSH
   login on-failure log
   login on-success log
   subscriber templating
   voice service voip
   ip address trusted list
   ipv4 !CUCM.PUB.IP.IP
   ipv4 !CUCM.PUB.IP.IP
   ipv4 !CUCM.PUB.IP.IP
   mode border-element
   allow-connections sip to sip
   trace
   sip
   registrar server
   transport switch udp tcp
   early-offer forced
   midcall-signaling passthru
   g729 annexb-all
   voice class uri ipRegex sip
   pattern (!pattern-removed)
   voice class codec 1
   codec preference 1 g711alaw
   codec preference 2 g729r8
   codec preference 3 g711ulaw
   voice class server-group 1
   ipv4 !CUCM.PUB.IP.IP preference 1
   ipv4 !CUCM.PUB.IP.IP preference 2
   ipv4 !CUCM.PUB.IP.IP preference 3
   voice iec syslog
   voice register global
   default mode
   no allow-hash-in-dn
   max-dn 20
   max-pool 20
   voice register pool  1
   translation-profile outgoing SRST
   id network !SITE.VOIP.NET.IP mask !NET.MASK.NET.MASK
   alias 1 11111 to 00000
   no digit collect kpml
   dtmf-relay rtp-nte
   voice-class codec 1
   voice translation-rule 1
   rule 1 /11111/ /00000/
   voice translation-profile SRST
   translate called 1
   application
   service default dsapp
   global
   service alternate default
   service default dsapp
   object-group network FORESCOUT
   host !FS.NODE.IP.IP
   host !FS.NODE.IP.IP
   host !FS.NODE.IP.IP
   host !FS.NODE.IP.IP
   host !FS.NODE.IP.IP
   object-group network ISE
   host !ISE.NODE.IP.IP
   host !ISE.NODE.IP.IP
   host !ISE.NODE.IP.IP
   object-group network AAA
   group-object FORESCOUT
   group-object ISE
   object-group network ACAS
   host !ACAS.SRV.IP.IP
   host !ACAS.SRV.IP.IP
   host !ACAS.SRV.IP.IP
   host !ACAS.SRV.IP.IP
   host !ACAS.SRV.IP.IP
   host !ACAS.SRV.IP.IP
   host !ACAS.SRV.IP.IP
   host !ACAS.SRV.IP.IP
   host !ACAS.SRV.IP.IP
   object-group network ADMIN_DEVICES
   !NET.MGMT.MNTR.NET !NET.MASK.NET.MASK
   !NET.MGMT.MNTR.NET !NET.MASK.NET.MASK
   !NET.MGMT.MNTR.NET !NET.MASK.NET.MASK
   !NET.MGMT.MNTR.NET !NET.MASK.NET.MASK
   object-group network SUBINTS
   host $PM1_IP
   host $IOT1_IP
   host $VOIP_IP
   host $DATA1_IP
   host $DATA2_IP
   host $PM2_IP
   host $IOT2_IP
   host $PRINT_IP
   host $IOT3_IP
   host $MGMT_IP
   host $CAPWAP_IP
   object-group network LOOPBACKS
   host !PRIM.DMVPN.LO.IP
   host !ALT.DMVPN.LO.IP
   !SPOKE.LO.MGMT.NET !NET.MASK.NET.MASK
   !HUB.LO.MGMT.NET !NET.MASK.NET.MASK
   object-group network BLOCK_INT
   group-object SUBINTS
   group-object LOOPBACKS
   object-group network BLOCK_PING
   group-object FORESCOUT
   group-object ACAS
   object-group network DATA_NETWORK
   !DATA.IP.IP.NET !NET.MASK.NET.MASK
   object-group network DMVPN_HUBS
   host !PRIM.SITE.ISP.IP
   host !ALT.SITE.ISP.IP
   object-group network DMVPN_SPOKES
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   host !SPOKE.ISP.IP.IP
   object-group network DOMAIN
   host !ALT.DMVPN.LO.IP
   host !PRIM.DMVPN.LO.IP
   host !DC.DNS.NTP.IP
   host !DC.DNS.NTP.IP
   host !DC.DNS.NTP.IP
   host !DC.DNS.NTP.IP
   host !DC.DNS.NTP.IP
   object-group network PUBLIC_MGMT
   !NET.MGMT.MNTR.NET !NET.MASK.NET.MASK
   object-group network PRIVATE_MGMT
   55.71.49.0 !NET.MASK.NET.MASK
   object-group network MGMT_NETWORK
   group-object PUBLIC_MGMT
   group-object PRIVATE_MGMT
   object-group service NETWORK_SERVICE
   tcp-udp gt 1024
   udp eq ntp
   udp eq domain
   udp range 1645 1646
   udp range 1812 1813
   udp eq 3799
   udp eq netbios-ns
   udp range snmp snmptrap
   udp eq syslog
   tcp eq 1514
   tcp eq 445
   icmp
   tcp eq tacacs
   ip access-list extended DMVPN_IN
   permit udp object-group DMVPN_HUBS eq non500-isakmp any eq non500-isakmp
   permit udp object-group DMVPN_HUBS eq isakmp any eq isakmp
   permit esp object-group DMVPN_HUBS any
   permit gre object-group DMVPN_HUBS any
   permit udp object-group DMVPN_SPOKES eq non500-isakmp any eq non500-isakmp
   permit udp object-group DMVPN_SPOKES eq isakmp any eq isakmp
   permit esp object-group DMVPN_SPOKES any
   permit gre object-group DMVPN_SPOKES any
   5000 deny ip any any log-input
   ip access-list standard DNA_SSH
   permit !NET.MGMT.MNTR.NET
   5000 deny any log
   ip access-list standard SNMP
   permit !NET.MGMT.MNTR.NET
   permit !FS.NODE.IP.IP
   permit !FS.NODE.IP.IP
   permit !FS.NODE.IP.IP
   permit !FS.NODE.IP.IP
   permit !FS.NODE.IP.IP
   permit !NET.MGMT.MNTR.NET !NET.MASK.NET.MASK log
   permit !NET.MGMT.MNTR.NET !NET.MASK.NET.MASK log
   5000 deny any log
   ip access-list standard SSH
   permit !NET.MGMT.MNTR.NET !NET.MASK.NET.MASK log
   permit !NET.MGMT.MNTR.NET !NET.MASK.NET.MASK log
   permit !NET.MGMT.MNTR.NET !NET.MASK.NET.MASK log
   permit !NET.MGMT.MNTR.NET !NET.MASK.NET.MASK log
   permit !NET.MGMT.MNTR.NET !NET.MASK.NET.MASK log
   permit !FS.NODE.IP.IP log
   permit !FS.NODE.IP.IP log
   permit !FS.NODE.IP.IP log
   permit !FS.NODE.IP.IP log
   permit !FS.NODE.IP.IP log
   permit !NET.MGMT.MNTR.NET log
   5000 deny any log
   ip access-list extended BLOCK
   deny icmp any object-group BLOCK_INT fragments log
   deny icmp object-group BLOCK_PING object-group BLOCK_INT log
   deny icmp object-group BLOCK_INT object-group BLOCK_PING log
   5000 permit ip any any
   ip access-list extended MGMT_!MGMT-ID_IN
   deny icmp any host $MGMT_IP fragments log
   deny icmp any host $LO_MGMT_IP fragments log
   deny icmp object-group BLOCK_PING object-group PRIVATE_MGMT
   deny icmp object-group PRIVATE_MGMT object-group BLOCK_PING
   permit icmp object-group ADMIN_DEVICES object-group MGMT_NETWORK
   permit icmp object-group MGMT_NETWORK object-group ADMIN_DEVICES
   deny icmp object-group DATA_NETWORK object-group MGMT_NETWORK
   deny icmp object-group MGMT_NETWORK object-group DATA_NETWORK
   permit tcp object-group MGMT_NETWORK object-group MGMT_NETWORK eq 22 log-input
   permit object-group NETWORK_SERVICE object-group MGMT_NETWORK object-group AAA
   permit object-group NETWORK_SERVICE object-group AAA object-group MGMT_NETWORK
   permit object-group NETWORK_SERVICE object-group MGMT_NETWORK object-group ADMIN_DEVICES
   permit object-group NETWORK_SERVICE object-group ADMIN_DEVICES object-group MGMT_NETWORK
   permit object-group NETWORK_SERVICE object-group MGMT_NETWORK object-group DOMAIN
   permit object-group NETWORK_SERVICE object-group MGMT_NETWORK object-group ACAS
   5000 deny ip any any log-input
   ip access-list extended MGMT_!MGMT-ID_OUT
   deny icmp any host $MGMT_IP fragments log
   deny icmp any host $LO_MGMT_IP fragments log
   deny icmp object-group BLOCK_PING object-group PRIVATE_MGMT
   deny icmp object-group PRIVATE_MGMT object-group BLOCK_PING
   permit icmp object-group ADMIN_DEVICES object-group MGMT_NETWORK
   permit icmp object-group MGMT_NETWORK object-group ADMIN_DEVICES
   deny icmp object-group DATA_NETWORK object-group MGMT_NETWORK
   deny icmp object-group MGMT_NETWORK object-group DATA_NETWORK
   permit tcp object-group ADMIN_DEVICES object-group MGMT_NETWORK eq 22 log-input
   permit tcp object-group FORESCOUT object-group MGMT_NETWORK eq 22 log-input
   permit object-group NETWORK_SERVICE object-group MGMT_NETWORK object-group MGMT_NETWORK
   permit object-group NETWORK_SERVICE object-group MGMT_NETWORK object-group AAA
   permit object-group NETWORK_SERVICE object-group AAA object-group MGMT_NETWORK
   permit object-group NETWORK_SERVICE object-group MGMT_NETWORK object-group ADMIN_DEVICES
   permit object-group NETWORK_SERVICE object-group ADMIN_DEVICES object-group MGMT_NETWORK
   permit object-group NETWORK_SERVICE object-group MGMT_NETWORK object-group DOMAIN
   permit object-group NETWORK_SERVICE object-group DOMAIN object-group MGMT_NETWORK
   permit object-group NETWORK_SERVICE object-group ACAS object-group MGMT_NETWORK
   5000 deny ip any any log-input
   spanning-tree extend system-id
   errdisable detect cause all
   errdisable recovery cause all
   errdisable recovery interval 60
   interface Gi0/0/0
   description DMVPN Uplink
   vrf forwarding !DMVPN
   ip flow monitor FLOW_MONITOR input
   ip address $ISP_IP $ISP_MASK
   no ip redirects
   no ip unreachables
   no ip proxy-arp
   ip nat outside
   ip access-group DMVPN_IN in
   negotiation auto
   no cdp enable
   no lldp transmit
   no shut
   interface Gi0/0/1
   description Internal Root $HOSTNAME-SW
   no ip address
   negotiation auto
   no shut
   interface Gi0/0/1.!PM1-ID
   description PM1
   encapsulation dot1Q !PM1-ID
   vrf forwarding !PM1
   ip flow monitor FLOW_MONITOR input
   ip address $PM1_IP $PM1_MASK
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   interface Gi0/0/1.!IOT1-ID
   description IOT1
   encapsulation dot1Q !PM1-ID
   vrf forwarding !IOT1
   ip flow monitor FLOW_MONITOR input
   ip address $IOT1_IP $IOT1_MASK
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   interface Gi0/0/1.!VOIP-ID
   description VOIP
   encapsulation dot1Q !VOIP-ID
   ip flow monitor FLOW_MONITOR input
   ip address $VOIP_IP $VOIP_MASK
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   interface Gi0/0/1.!DATA1-ID
   description DATA1
   encapsulation dot1Q !DATA1-ID
   ip flow monitor FLOW_MONITOR input
   ip address $DATA1_IP $DATA1_MASK
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !NET.MGMT.MNTR.NET
   ip helper-address !NET.MGMT.MNTR.NET
   interface Gi0/0/1.!DATA2-ID
   description DATA2
   encapsulation dot1Q !DATA1-ID
   ip flow monitor FLOW_MONITOR input
   ip address $DATA2_IP $DATA2_MASK
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !NET.MGMT.MNTR.NET
   ip helper-address !NET.MGMT.MNTR.NET
   interface Gi0/0/1.!PM2-ID
   description PM2
   encapsulation dot1Q !PM2-ID
   vrf forwarding !PM2
   ip flow monitor FLOW_MONITOR input
   ip address $PM2_IP $PM2_MASK
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   interface Gi0/0/1.!IOT2-ID
   description army-rcca-arng-env
   encapsulation dot1Q !IOT2-ID
   vrf forwarding !IOT2
   ip flow monitor FLOW_MONITOR input
   ip address $IOT2_IP $IOT2_MASK
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   interface Gi0/0/1.!PRINT-ID
   description PRINT
   encapsulation dot1Q !PRINT-ID
   ip flow monitor FLOW_MONITOR input
   ip address $PRINT_IP $PRINT_MASK
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !NET.MGMT.MNTR.NET
   ip helper-address !NET.MGMT.MNTR.NET
   interface Gi0/0/1.!IOT3-ID
   description !IOT3
   encapsulation dot1Q !IOT3-ID
   vrf forwarding !IOT2
   ip flow monitor FLOW_MONITOR input
   ip address $IOT3_IP $IOT3_MASK
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   interface Gi0/0/1.!MGMT-ID
   description MGMT
   encapsulation dot1Q !MGMT-ID
   ip flow monitor FLOW_MONITOR input
   ip address $MGMT_IP $MGMT_MASK
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip tcp adjust-mss 1360
   interface Gi0/0/1.!CAPWAP-ID
   description CAPWAP
   encapsulation dot1Q !CAPWAP-ID
   ip flow monitor FLOW_MONITOR input
   ip address $CAPWAP_IP $CAPWAP_MASK
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   ip helper-address !FS.NODE.IP.IP
   interface Tunnel!PM1-ID
   description PM1 Tunnel
   vrf forwarding !PM1
   ip flow monitor FLOW_MONITOR input
   ip address !IP.PM1.PM1.$SITE_ID !NET.MASK.NET.MASK
   no ip redirects
   ip nhrp authentication PM1
   ip nhrp map multicast !PRIM.SITE.SEG.IP
   ip nhrp map !IP.PM1.PM1.IP !PRIM.SITE.SEG.IP
   ip nhrp map multicast !ALT.SITE.SEG.IP
   ip nhrp map !IP.PM1.PM1.IP !ALT.SITE.SEG.IP
   ip nhrp nhs !IP.PM1.PM1.IP
   ip nhrp nhs !IP.PM1.PM1.IP
   ip nhrp network-id !PM1-ID
   ip nhrp shortcut
   ip mtu 1376
   ip tcp adjust-mss 1336
   ip ospf network point-to-multipoint
   ip ospf dead-interval 40
   ip ospf hello-interval 10
   ip ospf cost 50
   ip ospf priority 0
   tunnel source Loopback!DMVPN-ID
   tunnel mode gre multipoint
   tunnel key !PM1-ID
   interface Tunnel!IOT1-ID
   description !IOT1 Tunnel
   vrf forwarding !IOT1
   ip flow monitor FLOW_MONITOR input
   ip address !IP.IOT1.IOT1.$SITE_ID !NET.MASK.NET.MASK
   no ip redirects
   ip nhrp authentication !IOT1-ID
   ip nhrp map multicast !PRIM.SITE.SEG.IP
   ip nhrp map !IP.IOT1.IOT1.IP !PRIM.SITE.SEG.IP
   ip nhrp map multicast !ALT.SITE.SEG.IP
   ip nhrp map !IP.IOT1.IOT1.IP !ALT.SITE.SEG.IP
   ip nhrp nhs !IP.IOT1.IOT1.IP
   ip nhrp nhs !IP.IOT1.IOT1.IP
   ip nhrp network-id !IOT1-ID
   ip nhrp shortcut
   ip mtu 1376
   ip tcp adjust-mss 1336
   ip ospf network point-to-multipoint
   ip ospf dead-interval 40
   ip ospf hello-interval 10
   ip ospf cost 50
   ip ospf priority 0
   tunnel source Loopback!DMVPN-ID
   tunnel mode gre multipoint
   tunnel key !IOT1-ID
   interface Tunnel!DMVPN-ID
   description Base DMVPN Tunnel
   ip flow monitor FLOW_MONITOR input
   ip address !IP.DMVPN.DMVPN.$SITE_ID !NET.MASK.NET.MASK
   no ip redirects
   ip nhrp authentication DMVPN25
   ip nhrp map !IP.DMVPN.DMVPN.IP !PRIM.SITE.ISP.IP
   ip nhrp map multicast !PRIM.SITE.ISP.IP
   ip nhrp map !IP.DMVPN.DMVPN.IP !ALT.SITE.ISP.IP
   ip nhrp map multicast !ALT.SITE.ISP.IP
   ip nhrp nhs !IP.DMVPN.DMVPN.IP
   ip nhrp nhs !IP.DMVPN.DMVPN.IP
   ip nhrp network-id !DMVPN-ID
   ip nhrp shortcut
   ip mtu 1376
   ip tcp adjust-mss 1336
   ip ospf authentication key-chain OSP
   ip ospf network point-to-multipoint
   ip ospf dead-interval 40
   ip ospf hello-interval 10
   ip ospf cost 50
   ip ospf priority 0
   tunnel source GigabitEthernet0/0/0
   tunnel vrf DMVPN
   tunnel mode gre multipoint
   tunnel key !DMVPN-ID
   tunnel protection ipsec profile IPSEC-PROFILE-STD25
   interface Tunnel!PM2-ID
   description PM2 Tunnel
   vrf forwarding !PM2
   ip flow monitor FLOW_MONITOR input
   ip address !IP.PM2.PM2.$SITE_ID !NET.MASK.NET.MASK
   no ip redirects
   ip nhrp authentication GAIT95
   ip nhrp map multicast !PRIM.SITE.SEG.IP
   ip nhrp map !IP.PM2.PM2.IP !PRIM.SITE.SEG.IP
   ip nhrp map multicast !ALT.SITE.SEG.IP
   ip nhrp map !IP.PM2.PM2.IP !ALT.SITE.SEG.IP
   ip nhrp nhs !IP.PM2.PM2.IP
   ip nhrp nhs !IP.PM2.PM2.IP
   ip nhrp network-id !PM2-ID
   ip nhrp shortcut
   ip mtu 1376
   ip tcp adjust-mss 1336
   ip ospf network point-to-multipoint
   ip ospf dead-interval 40
   ip ospf hello-interval 10
   ip ospf cost 50
   ip ospf priority 0
   tunnel source Loopback!DMVPN-ID
   tunnel mode gre multipoint
   tunnel key !PM2-ID
   interface Tunnel!IOT2-ID
   description !IOT2-Tunnel
   vrf forwarding !IOT2
   ip flow monitor FLOW_MONITOR input
   ip address !IP.IOT2.IOT2.$SITE_ID !NET.MASK.NET.MASK
   no ip redirects
   ip nhrp authentication !IOT2
   ip nhrp map multicast !PRIM.SITE.SEG.IP
   ip nhrp map !IP.IOT2.IOT2.IP !PRIM.SITE.SEG.IP
   ip nhrp map multicast !ALT.SITE.SEG.IP
   ip nhrp map !IP.IOT2.IOT2.IP !ALT.SITE.SEG.IP
   ip nhrp nhs !IP.IOT2.IOT2.IP
   ip nhrp nhs !IP.IOT2.IOT2.IP
   ip nhrp network-id !IOT2-ID
   ip nhrp shortcut
   ip mtu 1376
   ip tcp adjust-mss 1336
   ip ospf network point-to-multipoint
   ip ospf dead-interval 40
   ip ospf hello-interval 10
   ip ospf cost 50
   ip ospf priority 0
   tunnel source Loopback!DMVPN-ID
   tunnel mode gre multipoint
   tunnel key !IOT2-ID
   interface Tunnel!MGMT-ID
   description Network Management Tunnel
   vrf forwarding !MGMT
   ip flow monitor FLOW_MONITOR input
   ip address !IP.MGMT.MGMT.$SITE_ID !NET.MASK.NET.MASK
   no ip redirects
   ip nhrp authentication !MGMT-ID
   ip nhrp map multicast !PRIM.HUB.LO.IP
   ip nhrp map !IP.MGMT.MGMT.IP !PRIM.HUB.LO.IP
   ip nhrp map multicast !ALT.HUB.LO.IP
   ip nhrp map !IP.MGMT.MGMT.IP !ALT.HUB.LO.IP
   ip nhrp nhs !IP.MGMT.MGMT.IP
   ip nhrp nhs !IP.MGMT.MGMT.IP
   ip nhrp network-id !MGMT-ID
   ip nhrp shortcut
   ip mtu 1376
   ip tcp adjust-mss 1336
   ip ospf network point-to-multipoint
   ip ospf dead-interval 40
   ip ospf hello-interval 10
   ip ospf cost 50
   ip ospf priority 0
   tunnel source Loopback!MGMT-ID
   tunnel mode gre multipoint
   tunnel key !MGMT-ID
   interface GigabitEthernet0/0/2
   no ip address
   shutdown
   negotiation auto
   interface GigabitEthernet0/0/3
   no ip address
   shutdown
   negotiation auto
   interface GigabitEthernet0/0/4
   no ip address
   shutdown
   negotiation auto
   interface GigabitEthernet0/0/5
   no ip address
   shutdown
   negotiation auto
   router ospf !PM2-ID vrf PM2
   router-id $SITE_ID.$SITE_ID.$SITE_ID.!PM2-ID
   redistribute connected
   redistribute static
   passive-interface default
   no passive-interface Tunnel!PM2-ID
   network !PUB.IP.NET.NET !NET.MASK.NET.MASK area 0
   network !PRIV.IP.NET.NET !NET.MASK.NET.MASK area 0
   router ospf !IOT2-ID vrf !IOT2
   router-id $SITE_ID.$SITE_ID.$SITE_ID.!IOT2-ID
   redistribute connected
   redistribute static
   passive-interface default
   no passive-interface Tunnel!IOT2-ID
   network !PUB.IP.NET.NET !NET.MASK.NET.MASK area 0
   network !PRIV.IP.NET.NET !NET.MASK.NET.MASK area 0
   router ospf !PM1-ID vrf !PM1
   router-id $SITE_ID.$SITE_ID.$SITE_ID.!PM1-ID
   redistribute connected
   redistribute static
   passive-interface default
   no passive-interface Tunnel2
   network !PRIV.IP.NET.NET !NET.MASK.NET.MASK area 0
   router ospf !IOT1-ID vrf IOT1
   router-id $SITE_ID.$SITE_ID.$SITE_ID.!IOT1-ID
   redistribute connected
   redistribute static
   passive-interface default
   no passive-interface Tunnel!IOT1-ID
   network !PUB.IP.NET.NET !NET.MASK.NET.MASK area 0
   network !PRIV.IP.NET.NET !NET.MASK.NET.MASK area 0
   router ospf !MGMT-ID vrf MGMT
   router-id $SITE_ID.$SITE_ID.$SITE_ID.!MGMT-ID
   redistribute connected
   redistribute static
   passive-interface default
   no passive-interface Tunnel!MGMT-ID
   network !PUB.IP.NET.NET !NET.MASK.NET.MASK area 1
   network !DATA.IP.IP.NET !NET.MASK.NET.MASK area 1
   network !PRIV.IP.NET.NET !NET.MASK.NET.MASK area 1
   router ospf !DMVPN-ID
   router-id $SITE_ID.$SITE_ID.$SITE_ID.!DMVPN-ID
   redistribute connected
   redistribute static
   passive-interface default
   no passive-interface Tunnel!DMVPN-ID
   network !PUB.IP.NET.NET !NET.MASK.NET.MASK area 0
   network !DMVPN.IP.IP.NET !NET.MASK.NET.MASK area 0
   network !PRIV.IP.NET.NET !NET.MASK.NET.MASK area 0
   logging userinfo
   logging buffered 40960
   logging trap syslog-format rfc5424
   logging host !NET.MGMT.MNTR.NET
   logging host !NET.MGMT.MNTR.NET
   username !YourLocalAccount privilege 15 common-criteria-policy PASSWORD_POLICY algorithm-type sha256 secret !YourLocalAccountSecret
   enable secret !YourEnableSecret
   ip ssh time-out 60
   ip ssh source-interface Loopback!MGMT-ID
   ip ssh version 2
   ip ssh server algorithm mac hmac-sha2-512 hmac-sha2-256 hmac-sha2-512-etm@openssh.com hmac-sha2-256-etm@openssh.com
   ip ssh server algorithm encryption aes256-gcm aes128-gcm aes256-ctr aes192-ctr aes128-ctr
   ip ssh server algorithm kex ecdh-sha2-nistp521 ecdh-sha2-nistp384 ecdh-sha2-nistp256
   ip ssh server algorithm hostkey rsa-sha2-512 rsa-sha2-256
   ip ssh server algorithm publickey x509v3-ecdsa-sha2-nistp256 ecdsa-sha2-nistp256 x509v3-ecdsa-sha2-nistp384 ecdsa-sha2-nistp384 x509v3-ecdsa-sha2-nistp521 ecdsa-sha2-nistp521 rsa-sha2-512 rsa-sha2-256
   ip ssh client algorithm mac hmac-sha2-512 hmac-sha2-256 hmac-sha2-512-etm@openssh.com hmac-sha2-256-etm@openssh.com
   ip ssh client algorithm encryption aes256-gcm aes128-gcm aes256-ctr aes192-ctr aes128-ctr
   ip ssh client algorithm kex ecdh-sha2-nistp521 ecdh-sha2-nistp384 ecdh-sha2-nistp256
   ip scp server enable
   ip radius source-interface Loopback!MGMT-ID
   tacacs server YOUR-ISE-HOST
   address ipv4 !ISE.NODE.IP.IP
   key 0 !YourTACACSkeyHere
   tacacs server YOUR-ISE-HOST
   address ipv4 !ISE.NODE.IP.IP
   key 0 !YourTACACSkeyHere
   tacacs server YOUR-ISE-HOST
   address ipv4 !ISE.NODE.IP.IP
   key 0 !YourTACACSkeyHere
   snmp-server view READ iso included
   snmp-server view WRITE iso included
   snmp-server group !SnmpGroup v3 priv read READ write WRITE access SNMP
   snmp-server group !SnmpGroup v3 priv context vlan
   snmp-server group !SnmpGroup v3 priv context vlan- match prefix
   snmp-server user !SnmpUser1 !SnmpGroup v3 auth sha !YourSNMPauthHere priv aes 256 !YourSNMPprivHere access SNMP
   snmp-server user !SnmpUser2 !SnmpGroup v3 auth sha !YourSNMPauthHere priv aes 128 !YourSNMPprivHere access SNMP
   snmp-server host !IP.IP.IP.IP version 3 priv !SnmpUser1
   snmp-server host !IP.IP.IP.IP version 3 priv !SnmpUser1
   snmp-server host !IP.IP.IP.IP version 3 priv !SnmpUser2
   snmp-server host !IP.IP.IP.IP version 3 priv !SnmpUser2
   snmp ifmib ifindex persist
   snmp-server trap-source Loopback!MGMT-ID
   snmp-server enable traps
   call-home
   no profile CiscoTAC-1
   profile CiscoTAC-1
   no reporting smart-call-home-data
   no reporting smart-licensing-data
   no reporting all
   exit
   contact-email-addr !your.email.distro@domain
   source-interface Loopback!MGMT-ID
   no http secure server-identity-check
   profile "!YourProfile"
   reporting smart-licensing-data
   destination address http https://!NET.MGMT.MNTR.NET/
   exit
   exit
   no control-plane host
   class-map match-any CoS3
   no match protocol ssh
   line con 0
   exec-timeout 5 0
   logging synchronous
   stopbits 1
   line aux 0
   no exec
   line vty 0 15
   privilege level 15
   no authorization exec CON
   access-class SSH in vrf-also
   exec-timeout 5 0
   logging synchronous
   transport input ssh
   transport output ssh
   netconf-yang ssh ipv4 access-list name DNA_SSH
   end
   if [[ `dir bootflash: | i packages.conf` ]]
    then if [[ `sh ver|head 1|cut -d " " -f 6` == `more bootflash:packages.conf|grep '^#.*Build: 17'|cut -d " " -f 4` ]]
     then conf t
     no boot system
     boot system bootflash:packages.conf
     end
    fi
    else printf '\n\n  !CHECK IOS INSTALL\n\n'
   fi
   conf t
   aaa authorization exec default group ISE_TACACS local if-authenticated
   aaa authorization exec CON none
   aaa authorization commands 1 default group ISE_TACACS local if-authenticated
   aaa authorization commands 15 default group ISE_TACACS local if-authenticated
   end
   exit
   else printf '\nIncorrect input!\n'
   sleep 2
   RTRCFG
  fi
 fi
}
