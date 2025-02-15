function SITE00() 
{
 intpattern1='[[:alpha:]]{2}[[:digit:]](/[[:digit:]])?/[[:digit:]]{1,2}'
 rangepattern1='[[:alpha:]]{2}[[:digit:]](/[[:digit:]])?/[[:digit:]]{1,2}-[[:digit:]]{1,2}.*'
 rangepattern2='[[:alpha:]]{2}[[:digit:]](/[[:digit:]])?/[[:digit:]]{1,2},[[:alpha:]]{2}[[:digit:]](/[[:digit:]])?/[[:digit:]]{1,2}.*'
 read -p " ! Enter the hostname: " HOST
 if [[ -n "$HOST" && $HOST =~ '[[:alnum:]]+-[[:alnum:]]+-\.?35\.[[:alnum:]]{1,3}' ]]
  then echo "GOOD HOST: $HOST"
  echo
  else echo " * INVALID INPUT: $HOST"
  SITE00
 fi
 read -p " ! Enter ACCESS vlan ID#: " DATA
 if [[ -n "$DATA" && $DATA =~ '[[:digit:]]{1,2}' ]]
  then echo "GOOD VLAN INPUT: $DATA"
  else echo " * INVALD INPUT: $DATA"
  SITE00
 fi
 sh int status      |      cut -d " " -f 1
 read -p " ! Enter the interface for UPSTREAM TRUNK: " UPTRUNK
 if [[ -n "$UPTRUNK" && $UPTRUNK =~ $intpattern1 ]]
  then echo "GOOD INPUT: $UPTRUNK"
  echo
  else echo " * INVALID INPUT: $UPTRUNK"
  SITE00
 fi
 read -p " ? DOWN STREAM trunk interfaces? [y/n] " DOWNINPUT
 if [[ -n "$DOWNINPUT" && $DOWNINPUT =~ '[y|Y]' ]]
  then read -p " ! Enter the interface range for DOWN STREAM interfaces: " DSTRUNK
  if [[ $DSTRUNK =~ $rangepattern1 || $DSTRUNK =~ $rangepattern2 || $DSTRUNK =~ $intpattern1 ]]
   then echo "GOOD INPUT: $DSTRUNK"
   echo
   else echo " * INVALID INPUT: $DSTRUNK"
   echo
   SITE00
  fi
 fi       
 if [[ $DOWNINPUT =~ '[n|N]' ]]
  then echo "NO DOWNSTREAM TRUNKS"
  echo
 fi
 read -p " ? SHUT UNUSED interfaces? [y/n] " SHUTINPUT
 if [[ -n "$SHUTINPUT" && $SHUTINPUT =~ '[y|Y]' ]]
  then read -p " ! Enter the interface range for SHUT STREAM interfaces: " SHUTINT
  if [[ $SHUTINT =~ $rangepattern1 || $SHUTINT =~ $rangepattern2 || $SHUTINT =~ $intpattern1 ]]
   then echo "GOOD INPUT: $SHUTINT"
   echo
   else echo " * INVALID INPUT: $SHUTINT"
   echo
   SITE00
  fi
 fi
 if [[ $SHUTINPUT =~ '[n|N]' ]]
  then echo "NO INTERFACES TO SHUT"
  echo
 fi
 SITE01
}         

function SITE01() 
{
 conf t
 hostname $HOST
 no logging console
 no ip telnet source-interface
 no ip ftp passive
 no ip ftp source-interface
 no ip tftp source-interface
 no service pad
 no service udp-small-servers
 no service tcp-small-servers
 no service finger
 service tcp-keepalives-in
 service timestamps debug datetime localtime
 service timestamps log datetime localtime
 service password-encryption
 no platform punt-keepalive disable-kernel-core
 no ip rcmd rcp-enable
 no ip rcmd rsh-enable
 no ip domain lookup
 no ip http authentication aaa
 no ip boot server
 no ip bootp server
 no ip dns server
 no ip finger
 no ip http server
 no ip http secure-server
 no ip rcmd rcp-enable
 no ip rcmd rsh-enable
 no service config
 no ip domain lookup
 no service dhcp
 vrf definition Mgmt-vrf
 address-family ipv4
 exit-address-family
 address-family ipv6
 exit-address-family
 aaa new-model
 aaa group server radius YOUR-RADIUS-GROUP
 server name RADIUS-SERVER-3
 server name RADIUS-SERVER-2
 server name RADIUS-SERVER-1
 aaa group server tacacs+ YOUR-TACACS-GROUP
 server name TACACS-SERVER-3
 server name TACACS-SERVER-2
 server name TACACS-SERVER-1
 aaa server radius dynamic-author
 client ip.ip.ip.ip server-key y0urR4d1u$PSK
 client ip.ip.ip.ip server-key y0urR4d1u$PSK
 client ip.ip.ip.ip server-key y0urR4d1u$PSK
 port 3799
 auth-type all
 aaa common-criteria policy PASSWORD_POLICY
 min-length 15
 max-length 127
 numeric-count 1
 upper-case 1
 lower-case 1
 special-case 1
 char-changes 8
 exit
 enable secret Y0urL0c4L3n4b13
 username innoc privilege 15 common-criteria-policy PASSWORD_POLICY secret Y0urL0c4L$3cRet
 aaa session-id common
 clock timezone EST -5 0
 aaa authentication login default group YOUR-TACACS-GROUP local
 aaa authentication enable default group YOUR-TACACS-GROUP enable
 aaa authentication dot1x default group YOUR-RADIUS-GROUP
 aaa accounting dot1x default start-stop group YOUR-RADIUS-GROUP
 aaa accounting exec default start-stop group YOUR-TACACS-GROUP
 aaa accounting commands 1 default start-stop group YOUR-TACACS-GROUP
 aaa accounting commands 15 default start-stop group YOUR-TACACS-GROUP
 tacacs server TACACS-SERVER-1
 address ipv4 ip.ip.ip.ip
 key y0urT4c4c$PSK
 tacacs server TACACS-SERVER-2
 address ipv4 ip.ip.ip.ip
 key y0urT4c4c$PSK
 tacacs server TACACS-SERVER-3
 address ipv4 ip.ip.ip.ip
 key y0urT4c4c$PSK
 radius server RADIUS-SERVER-1
 address ipv4 ip.ip.ip.ip auth-port 1812 acct-port 1813
 key y0urR4d1u$PSK
 radius server RADIUS-SERVER-2
 address ipv4 1ip.ip.ip.ip auth-port 1812 acct-port 1813
 key y0urR4d1u$PSK
 radius server RADIUS-SERVER-3
 address ipv4 ip.ip.ip.ip auth-port 1812 acct-port 1813
 key y0urR4d1u$PSK
 exit
 vtp domain NGIN
 vtp mode off
 ip name-server 123.45.67.8 123.45.67.9
 ip domain name your.domain.domain
 login block-for 900 attempts 3 within 120
 login on-failure log
 login on-success log
 udld enable                           
 end
 SITE02
}

function SITE02() 
{
 read -p " ? ROOT SWITCH? [y/n] " ROOT
 if [[ ! $ROOT =~ '[y|Y]' || ! $ROOT =~ '[n|N]' ]]
  then echo " * INVALID INPUT: $ROOT"
  SITE02
 fi
 conf t   
 dot1x system-auth-control
 diagnostic bootup level minimal
 spanning-tree mode rapid-pvst
 spanning-tree loopguard default
 spanning-tree portfast default
 spanning-tree portfast bpduguard default
 spanning-tree extend system-id
 if [[ $ROOT =~ '[y|Y]' ]]
  then spanning-tree vlan 1-4094 priority 8192
 fi
 if [[ $ROOT =~ '[n|N]' ]]
  then spanning-tree vlan 1-4094
 fi
 errdisable detect cause all
 errdisable recovery cause all
 errdisable recovery interval 3600
 device-tracking policy UPLINK_TRUNK
 trusted-port
 device-role switch
 device-tracking policy DOWNLINK_TRUNK
 data-glean recovery dhcp
 destination-glean recovery dhcp
 limit address-count 100
 security-level glean
 device-role node
 tracking enable
 device-tracking policy ACCESS
 data-glean recovery dhcp
 destination-glean recovery dhcp
 limit address-count 50
 security-level glean
 device-role node
 tracking enable
 exit
 table-map AutoQos-4.0-Trust-Cos-Table
 default copy
 flow exporter WUG22
 destination 123.45.68.141
 crypto key generate rsa general-keys modulus 2048
 ip ssh server algorithm mac hmac-sha2-256 hmac-sha2-256-etm@openssh.com hmac-sha2-512 hmac-sha2-512-etm@openssh.com
 ip ssh server algorithm encryption aes256-gcm aes128-gcm aes256-ctr aes192-ctr aes128-ctr
 ip ssh server algorithm kex ecdh-sha2-nistp521 ecdh-sha2-nistp384 ecdh-sha2-nistp256
 ip ssh server algorithm hostkey rsa-sha2-256 rsa-sha2-512
 ip ssh server algorithm publickey rsa-sha2-256 x509v3-ecdsa-sha2-nistp256 ecdsa-sha2-nistp256 x509v3-ecdsa-sha2-nistp384 ecdsa-sha2-nistp384 x509v3-ecdsa-sha2-nistp521 rsa-sha2-512 ecdsa-sha2-nistp521 
 ip ssh client algorithm mac hmac-sha2-256 hmac-sha2-256-etm@openssh.com hmac-sha2-512 hmac-sha2-512-etm@openssh.com
 ip ssh client algorithm encryption aes256-gcm aes128-gcm aes256-ctr aes192-ctr aes128-ctr
 ip ssh client algorithm kex ecdh-sha2-nistp256 ecdh-sha2-nistp521 ecdh-sha2-nistp384
 radius-server attribute 6 on-for-login-auth
 vlan $DATA
 name DATA
 vlan 20
 name IMAGING
 vlan 40
 name DATA
 vlan 50
 name PRINTER
 vlan 60
 name VOIP
 vlan 70
 name HVAC
 vlan 100
 name TRUNK_NATIVE
 vlan 110
 name ACCESS_DEFAULT
 vlan 200
 name MANAGEMENT
 vlan 210
 name CAPWAP
 end
 SITE03
}

function SITE03() 
{
 conf t
 ip access-list standard SNMP
 permit ip.ip.ip.ip
 permit ip.ip.ip.ip
 permit ip.ip.ip.ip
 permit ip.ip.ip.ip
 permit ip.ip.ip.ip
 permit ip.ip.ip.ip
 permit ip.ip.ip.ip
 permit ip.ip.ip.ip mask.mask.mask.mask
 permit ip.ip.ip.ip mask.mask.mask.mask
 5000 deny any log
 ip access-list standard SSH
 permit ip.ip.ip.ip
 permit ip.ip.ip.ip mask.mask.mask.mask
 permit ip.ip.ip.ip mask.mask.mask.mask
 permit ip.ip.ip.ip mask.mask.mask.mask
 permit ip.ip.ip.ip mask.mask.mask.mask
 permit ip.ip.ip.ip
 permit ip.ip.ip.ip
 permit ip.ip.ip.ip
 permit ip.ip.ip.ip
 permit ip.ip.ip.ip
 5000 deny any log
 exit
 object-group network AAA
 description AAA appliances
 host ip.ip.ip.ip
 host ip.ip.ip.ip
 ip.ip.ip.ip mask.mask.mask.mask
 object-group network NAC
 description NAC appliances for ACLs
 host ip.ip.ip.ip
 host ip.ip.ip.ip
 host ip.ip.ip.ip
 host ip.ip.ip.ip
 host ip.ip.ip.ip
 exit
 login quiet-mode access-class SSH
 interface Vlan1
 no ip address
 shutdown
 for VER in `sh ver|grep \\*|cut -d " " -f 10`
  do if [[ $VER =~ 'C9.*00P$' ]]
   then conf t
   int GigabitEthernet 0/0
   no ip address
   shutdown
  fi
 done
 end
 SITE04
}

function SITE04() 
{
 conf t
 interface $UPTRUNK
 switchport mode trunk
 switchport trunk native vlan 100
 description TRUNK
 switchport trunk allowed vlan $DATA,20,40,50,60,70,100,110,200,210
 device-tracking attach-policy UPLINK_TRUNK
 ip dhcp snooping trust
 ip arp inspection trust
 ip arp inspection limit rate 2048
 if [[ -n "$DSTRUNK" ]]
  then interface range $DSTRUNK
  switchport mode trunk
  switchport trunk native vlan 100
  description TRUNK
  switchport trunk allowed vlan $DATA,20,40,50,60,70,100,110,200,210
  device-tracking attach-policy DOWNLINK_TRUNK
  ip dhcp snooping limit rate 2048
  ip arp inspection trust
  ip arp inspection limit rate 2048
  spanning-tree guard root
 fi        
 if [[ -n "$SHUTINT" ]]
  then interface range $SHUTINT
  description SHUTDOWN
  switchport access vlan 110
  switchport mode access
  switchport block unicast
  switchport voice vlan 20
  authentication host-mode multi-domain
  authentication order dot1x mab
  authentication port-control auto
  authentication periodic
  mab
  trust device cisco-phone
  dot1x pae authenticator
  storm-control broadcast level bps 20m
  storm-control unicast level bps 225m
  shutdown
 fi
 end
 SITE05     
}

function SITE05() 
{
 for INT in `sh int status | e TRUNK|SHUTDOWN`
  do if [[ $INT =~ "^[G|T][[:alpha:]][[:digit:]](/[[:digit:]])?/[[:digit:]]{1,2}" ]]
   then conf t
   interface $INT
   switchport mode access
   switchport access vlan 110
   switchport block unicast
   switchport voice vlan 60
   device-tracking attach-policy ACCESS
   authentication event server dead action authorize voice
   authentication event server alive action reinitialize 
   authentication host-mode multi-domain
   authentication order dot1x mab
   authentication port-control auto
   authentication periodic
   authentication violation replace
   mab
   trust device cisco-phone
   dot1x pae authenticator
   dot1x timeout tx-period 5
   dot1x max-reauth-req 1
   storm-control broadcast level bps 20m
   storm-control unicast level bps 225m
   auto qos voip cisco-phone 
   ip dhcp snooping limit rate 2048
   ip verify source
   end
  fi
 done
 SITE06
}

function SITE06() 
{
 read -p " ! Enter default gateway (RTR IP): " GATEWAY
 if [[ -n "$GATEWAY" && $GATEWAY =~ '123\.45\.[6|7][[:digit:]]\.[[:digit:]]{1,3}' ]]
  then conf t
  ip default-gateway $GATEWAY
  ip tcp synwait-time 10
  ip forward-protocol nd
  end
  else echo " * INVALD GATEWAY IP: $GATEWAY"
  SITE06
 fi
 read -p " ! Enter the MANAGEMENT IP and subnet: " MGMT
 if [[ -n "$MGMT" && $MGMT =~ '123\.45\.[6|7][[:digit:]]\.[[:digit:]]{1,3}[[:blank:]]255\.255\.[[:digit:]]{3}\..*' ]]
  then conf t
  interface Vlan200
  ip address $MGMT
  no ip proxy-arp
  end
  else echo " * INVALID NETWORK INPUT: $MGMT"
  SITE06
 fi
 SITE07
}

function SITE07()
{
 conf t
 call-home
 no profile CiscoTAC-1
 profile CiscoTAC-1
 no reporting smart-call-home-data
 no reporting smart-licensing-data
 no reporting all
 exit
 contact-email-addr your.org.email@domain
 source-interface Vlan200
 vrf Mgmt-vrf
 no http secure server-identity-check
 profile "PROFILENAME"
 reporting smart-licensing-data
 destination address http https://192.168.200.43/
 exit
 exit
 ip tacacs source-interface Vlan200
 ip ssh maxstartups 5
 ip ssh time-out 60
 ip ssh source-interface Vlan200
 ip ssh version 2
 ip scp server enable
 ip radius source-interface Vlan200 
 logging source-interface Vlan200
 logging host 192.168.100.10
 logging host 192.168.200.43
 snmp-server view READ iso included
 snmp-server view WRITE iso included
 snmp-server group SNMPGRP v3 priv read READ write WRITE access SNMP
 snmp-server group SNMPGRP v3 priv context vlan
 snmp-server group SNMPGRP v3 priv context vlan- match prefix
 snmp-server user USERSNMP SNMPGRP v3 auth sha Y0r4thK3y priv aes 256 Y0rPr1vK3y access SNMP
 snmp ifmib ifindex persist
 snmp-server trap-source Vlan200
 snmp-server enable traps
 snmp-server enable traps mac-notification
 archive
 log config
 logging enable
 notify syslog contenttype plaintext
 hidekeys
 memory free low-watermark processor 87534
 logging userinfo
 logging trap informational syslog-format rfc5424
 logging buffered 40960
 control-plane
 service-policy input system-cpp-policy
 line con 0
 exec-timeout 5 0
 logging synchronous
 stopbits 1
 end
 for AUX in `sh line|grep AUX|cut -d " " -f 8`
  do        if [[ -n "$AUX" ]]
   then conf t
   line aux 0
   no exec
   exec-timeout 5 0
   stopbits 1
   end
  fi
 done
 conf t
 line vty 0 15
 session-timeout 5
 access-class SSH in vrf-also
 exec-timeout 5 0
 privilege level 15
 logging synchronous
 transport input ssh
 transport output ssh
 exit
 ntp authentication-key 123 hmac-sha2-256 Y0rNTPk3y
 ntp authenticate
 ntp trusted-key 123
 ntp source Vlan200
 ntp server 192.168.100.240 key 123
 ntp server 192.168.100.250 key 123 prefer
 mac address-table notification change
 aaa authorization console
 aaa authorization config-commands
 aaa authorization exec default group YOUR-TACACS-GROUP local if-authenticated
 aaa authorization exec CON none
 aaa authorization network default group YOUR-RADIUS-GROUP
 aaa authorization commands 1 default group YOUR-TACACS-GROUP local if-authenticated
 aaa authorization commands 15 default group YOUR-TACACS-GROUP local if-authenticated
 end
}
