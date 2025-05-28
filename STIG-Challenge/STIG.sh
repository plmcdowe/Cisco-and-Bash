# Shell Environment File.
# Environment Variables:
?=0
prc_change_mode=PRC_INVALID
prc_change_type=PRC_INVALID
prc_error_code=PRC_INVALID
prc_failure_type=PRC_INVALID
prc_ha_sync=PRC_INVALID
# Environment Functions:
function FOUR00()
{
 \# THIS IS A COMMENT
 \# the pound sign must be escaped
 \# DO NOT use comments INSIDE of CONF T
 \# DO NOT use comments INSIDE of conditional logic
 \# function 00 includes services that are unsecure, improperly configured, or unecessary
 \# it also configures only 1 radius and 1 tacacs server in the new-model server groups
 \# an extra local account is configured, and both accounts use password instead of secret
 conf t
 hostname ST1G-Ch4ll3nge
 no logging console
 ip ftp passive
 service pad
 service udp-small-servers
 service tcp-small-servers
 no service finger
 service tcp-keepalives-in
 no platform punt-keepalive disable-kernel-core
 no ip rcmd rcp-enable
 no ip rcmd rsh-enable
 ip domain lookup
 ip http authentication aaa
 ip boot server
 ip bootp server
 ip dns server
 ip finger
 ip http server
 ip http secure-server
 ip routing
 no ip rcmd rcp-enable
 no ip rcmd rsh-enable
 no service config
 ip domain lookup
 service dhcp
 vrf definition Mgmt-vrf
 address-family ipv4
 exit-address-family
 address-family ipv6
 exit-address-family
 aaa new-model
 aaa group server radius !YourRadius_ServerGroup
 server name !YourRadiusServerName
 aaa group server tacacs+ !YourTACACS_ServerGroup
 server name !PRI-TACACS-PSN1
 aaa server radius dynamic-author
 client !Radius.IP.IP.IP server-key !YourRadiusKeyHere
 client !Radius.IP.IP.IP server-key !YourRadiusKeyHere
 client !Radius.IP.IP.IP server-key !YourRadiusKeyHere
 port 3799
 auth-type all
 exit
 enable password !YourEnablePassword
 username !YourLocalAccount privilege 15 password !YourLocalAccountPassword
 username !AnOldLocalAccount privilege 15 password !AnOldLocalPassword
 aaa session-id common
 clock timezone EST -5 0
 aaa authentication login default group !YourTACACS_ServerGroup local
 aaa authentication enable default group !YourTACACS_ServerGroup enable
 tacacs server !PRI-TACACS-PSN1
 address ipv4 !TACACS.IP.IP.IP
 key !YourTacacsKeyHere
 tacacs server !PRI-TACACS-PSN2
 address ipv4 !TACACS.IP.IP.IP
 key !YourTacacsKeyHere
 tacacs server ALT-TACACS-PSN
 address ipv4 !TACACS.IP.IP.IP
 key !YourTacacsKeyHere
 radius server FSAPP1
 address ipv4 !Radius.IP.IP.IP auth-port 1812 acct-port 1813
 key !YourRadiusKeyHere
 radius server FSAPP2
 address ipv4 !RADIUS.IP.IP.IP auth-port 1812 acct-port 1813
 key !YourRadiusKeyHere
 radius server !YourRadiusServerName
 address ipv4 !RADIUS.IP.IP.IP auth-port 1812 acct-port 1813
 key !YourRadiusKeyHere
 exit
 vtp domain !VTPdomain
 vtp mode server vlan
 ip name-server !DOMAIN.IP.IP.IP !DOMAIN.IP.IP.IP
 ip domain name !your.domain
 end
 FOUR01
}
function FOUR01()
{
 \# function 01 includes unsecure SSH crypto algorithms
 conf t
 diagnostic bootup level minimal
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
 flow exporter !ExportName
 destination !Net.Mon.IP.IP
 crypto key generate rsa general-keys modulus 2048
 ip ssh server algorithm mac hmac-sha2-256 hmac-sha2-256-etm@openssh.com hmac-sha2-512 hmac-sha2-512-etm@openssh.com hmac-sha1
 ip ssh server algorithm encryption aes256-gcm aes128-gcm aes256-ctr aes192-ctr aes128-ctr 3des-cbc
 ip ssh server algorithm kex ecdh-sha2-nistp521 ecdh-sha2-nistp384 ecdh-sha2-nistp256 diffie-hellman-group14-sha1
 ip ssh server algorithm hostkey rsa-sha2-256 rsa-sha2-512 ssh-rsa
 ip ssh server algorithm publickey rsa-sha2-256 x509v3-ecdsa-sha2-nistp256 ecdsa-sha2-nistp256 x509v3-ecdsa-sha2-nistp384 ecdsa-sha2-nistp384 x509v3-ecdsa-sha2-nistp521 rsa-sha2-512 ecdsa-sha2-nistp521 ssh-rsa
 ip ssh client algorithm mac hmac-sha2-256 hmac-sha2-256-etm@openssh.com hmac-sha2-512 hmac-sha2-512-etm@openssh.com hmac-sha1
 ip ssh client algorithm encryption aes256-gcm aes128-gcm aes256-ctr aes192-ctr aes128-ctr 3des-cbc
 ip ssh client algorithm kex ecdh-sha2-nistp256 ecdh-sha2-nistp521 ecdh-sha2-nistp384 diffie-hellman-group14-sha1
 vlan !VoIP-ID
  name VOIP
 vlan !Data-ID
  name DATA
 vlan !IOT-ID
  name IOT
 vlan !Remediation-Net-ID
  name REMEDIATION
 vlan !Trunk-Native-ID
  name TRUNK_NATIVE
 vlan !Dead-Access-Default
  name ACCESS_DEFAULT
 vlan !Printer-Net-ID
  name PRINTERS
 vlan !Wireles-Access-ID
  name DATA_WIRELESS
 vlan !MGMT-Net-ID
  name MANAGEMENT
 vlan !AP-Net-ID
  name CAPWAP
 end
 FOUR02
}
function FOUR02()
{
 intpattern='[[:alpha:]]{2}[[:digit:]](/[[:digit:]])?/[[:digit:]]{1,2}'
 \# z for even/odd test result
 z=0
 \# i for total number of interfaces, likely 12, 24, 28, 48, 52
 i=0
 for INT in `sh int status | cut -d " " -f 1`
  do if [[ $INT =~ $intpattern ]]
   then (( i++ ))
  fi
 done
 \# a1 is last access interface
 (( a1 = i - 3 ))
 \# t1 are trunk interfaces version one
 (( t1 = i - 2 ))
 \# t2 is trunk interface version two
 (( t2 = i - 1 ))
 \#
 \# there will always be one unconfigured interface
 \# ex, 9200CX has Gi 1/0/1-12, Gi 1/1/1, Gi 1/1/2, Te 1/1/3, Te 1/1/4 totaling 16 interfaces
 \# 1/1/4 will be unconfigured, t2 is 1/1/3, t1 is 1/1/2 and 3, a1 is 1/0/12
 \#
 \# test even-ness (( z = a & 1 ))
 \# test divisibility (( b = a % 3 ))
 \#
 a=0
 for INT in `sh int status | cut -d " " -f 1`
  do if [[ $INT =~ $intpattern ]]
   then (( a++ ))
   if [[ "$a" -lt "$a1" ]]
    then (( z = a & 1 ))
    (( b = a % 3 ))
    \# EVEN and DIVISIBLE by 3
    if [[ "$z" == "0" && "$b" == "0" ]]
     then conf t
     interface $INT
     description ACCESS-DIS
     switchport trunk allowed !vlan 1,9,10,.,.,.,.YourVlans
     switchport mode access
     switchport voice vlan !VoIP-ID
     device-tracking attach-policy DOWNLINK_TRUNK
     authentication event fail action authorize vlan !Data-ID
     authentication event server dead action authorize voice
     authentication event server alive action reinitialize
     authentication host-mode multi-host
     authentication open
     authentication order mab dot1x
     authentication periodic
     trust device cisco-phone
     dot1x timeout server-timeout 10
     dot1x timeout tx-period 5
     dot1x timeout supp-timeout 10
     dot1x timeout start-period 5
     spanning-tree guard root
     end
    fi
    \# EVEN and NOT DIVISIBLE by 3
    if [[ "$z" == "0" && $b != "0" ]]
     then conf t
     interface $INT
     description ACCESS-DIS
     switchport access vlan !Dead-Access-Default
     switchport mode access
     switchport voice vlan !VoIP-ID
     device-tracking attach-policy ACCESS
     authentication control-direction in
     authentication event fail action authorize vlan !Data-ID
     authentication event server alive action reinitialize
     authentication host-mode multi-host
     authentication order mab dot1x
     authentication periodic
     authentication timer reauthenticate 6400
     authentication timer restart 120
     authentication timer inactivity server
     authentication violation replace
     mab eap
     trust device cisco-phone
     dot1x timeout server-timeout 10
     dot1x timeout tx-period 5
     dot1x timeout supp-timeout 10
     dot1x max-req 5
     dot1x max-reauth-req 1
     dot1x timeout start-period 5
     auto qos voip cisco-phone
     spanning-tree bpdufilter enable
     spanning-tree portfast
     end
    fi
    \# ODD and DIVISIBLE by 3
    if [[ $z != "0" && "$b" == "0" ]]
     then conf t
     interface $INT
     description ACCESS-DIS
     switchport access vlan !Printer-Net-ID
     switchport mode access
     device-tracking attach-policy ACCESS
     authentication event fail action authorize vlan !Data-ID
     authentication event server dead action authorize vlan !VoIP-ID
     authentication event server dead action authorize voice
     authentication event server alive action reinitialize
     authentication host-mode multi-host
     authentication order mab dot1x
     authentication periodic
     authentication timer reauthenticate 6400
     authentication timer restart 120
     authentication timer inactivity server
     dot1x timeout server-timeout 10
     dot1x timeout tx-period 5
     dot1x timeout supp-timeout 10
     dot1x max-req 5
     dot1x max-reauth-req 1
     dot1x timeout start-period 5
     end
    fi
    \# ODD and NOT DIVISIBLE by 3
    if [[ $z != "0" && $b != "0" ]]   then printf '\n\nOpt \n\n'
     then conf t
     interface $INT
     description ACCESS-CON
     switchport access vlan !Printer-Net-ID
     switchport mode access
     device-tracking attach-policy ACCESS
     authentication control-direction in
     authentication event fail action authorize vlan !VoIP-ID
     authentication event server dead action authorize vlan !VoIP-ID
     authentication event server dead action authorize voice
     authentication event server alive action reinitialize
     authentication host-mode multi-host
     authentication open
     authentication order mab dot1x
     authentication timer reauthenticate 6400
     authentication timer restart 120
     authentication timer inactivity server
     authentication violation replace
     mab eap
     trust device cisco-phone
     dot1x timeout server-timeout 10
     dot1x timeout tx-period 5
     dot1x timeout supp-timeout 10
     dot1x max-req 5
     dot1x max-reauth-req 1
     dot1x timeout start-period 5
     spanning-tree bpdufilter enable
     end
    fi
   fi
   if [[ "$a" -ge "$a1" && "$a" -lt "$t1" ]]
    then conf t
    int $INT
    description UPLINK-CON
    switchport mode trunk
    switchport trunk allowed !vlan 1,9,10,.,.,.,.YourVlans
    device-tracking attach-policy DOWNLINK_TRUNK
    end
   fi
   if [[ "$a" -ge "$t1" && "$a" -le "$t2" ]]
    then (( z = a & 1 ))
    if [[ "$z" == "0" ]]
     then conf t
     int $INT
     description DNLINK-CON
     switchport mode trunk
     switchport trunk allowed !vlan 1,9,10,.,.,.,.YourVlans
     device-tracking attach-policy DOWNLINK_TRUNK
     end
     else conf t
     int $INT
     description DNLINK-DIS
     switchport mode trunk
     switchport trunk allowed !vlan 1,9,10,.,.,.,.YourVlans
     device-tracking attach-policy DOWNLINK_TRUNK
     end
    fi
   fi
  fi
 done
 FOUR03
}
function FOUR03()
{
 \# function 03 includes unsecure services like ftp, tftp, http and http specific misconfigs
 \# also includes SNMP v2c community and users
 \# and cryptographically weak v3 schemes md5 and des
 \# also leaves available con 0 with -gt 5 min exec-timeout and aux 0 depending on the model
 \# and configures 97 vty lines with 10 min timeouts, and input-output all instead of only SSH
 \# also configures md5 NTP key, does not configure ntp authentication, and does not associate the key to a source
 conf t
 ip default-gateway !MGMT.GW.IP.IP
 ip tcp synwait-time 10
 ip forward-protocol nd
 interface Vlan !MGMT-SVI-ID
 ip address !SW.MGMT.IP.IP !MGMT.NET.MASK.IP
 no ip proxy-arp
 exit
 ip tacacs source-interface Vlan !MGMT-SVI-ID
 ip ssh maxstartups 5
 ip ssh time-out 60
 ip ssh source-interface Vlan !MGMT-SVI-ID
 ip ssh version 2
 ip scp server enable
 ip radius source-interface Vlan !MGMT-SVI-ID
 ip telnet source-interface Vlan !MGMT-SVI-ID
 ip ftp source-interface Vlan !MGMT-SVI-ID
 ip tftp source-interface Vlan !MGMT-SVI-ID
 ip http client source-interface Vlan !MGMT-SVI-ID
 ip http authentication local
 ip http timeout-policy idle 600 life 86400 requests 86400
 snmp-server view READ iso included
 snmp-server view WRITE iso included
 snmp-server community !FakeV2cOmmUniTyStRinG rw
 snmp-server group !v2cGroup v2c read READ write WRITE
 snmp-server group !v3RealGroup v3 priv read READ write WRITE
 snmp-server group !v3RealGroup v3 priv context vlan
 snmp-server group !v3RealGroup v3 priv context vlan- match prefix
 snmp-server user !v2cUser !v2cGroup v2c
 snmp-server user !FakeUser !v3RealGroup v3 auth md5 !FAKEauth0 priv des !FAKEpriv0
 snmp-server user !RealUser1 !v3RealGroup v3 auth sha !FAKEauth1 priv aes 256 !FAKEpriv1
 snmp-server user !RealUser2 !v3RealGroup v3 auth sha !FAKEauth2 priv aes 256 !FAKEpriv2
 snmp-server user !RealUser3 !v3RealGroup v3 auth sha !FAKEauth3 priv aes 128 !FAKEpriv3
 snmp-server user !RealUser4 !v3RealGroup v3 auth sha !FAKEauth4 priv aes 128 !FAKEpriv4
 snmp-server host !IP.IP.IP.IP version 3 priv !RealUser4
 snmp-server host !Net.Mon.IP.IP version 3 priv !RealUser2
 snmp-server host !Net.Mon.IP.IP version 2c !FakeV2cOmmUniTyStRinG
 snmp-server host !RADIUS.IP.IP.IP version 3 priv !RealUser1
 snmp-server host !Radius.IP.IP.IP version 3 priv !RealUser1
 snmp-server host !RADIUS.IP.IP.IP version 3 priv !RealUser1
 snmp-server host !RADIUS.IP.IP.IP version 3 priv !RealUser1
 snmp-server host !RADIUS.IP.IP.IP version 3 priv !RealUser1
 snmp-server host !IP.IP.IP.IP version 3 priv !RealUser3
 snmp ifmib ifindex persist
 snmp-server trap-source !MGMT-SVI-ID
 snmp-server enable traps
 snmp-server enable traps mac-notification
 memory free low-watermark processor 87534
 logging trap alerts syslog-format rfc5424
 logging buffered 4096 alerts
 control-plane
 service-policy input system-cpp-policy
 line con 0
 exec-timeout 10 0
 stopbits 1
 end
 for AUX in `sh line|grep AUX|cut -d " " -f 8`
  do if [[ -n "$AUX" ]]
   then conf t
   line aux 0
   exec-timeout 10 0
   stopbits 1
   end
  fi
 done
 conf t
 line vty 0 97
 session-timeout 10
 exec-timeout 10 0
 privilege level 15
 transport input all
 transport output all
 exit
 ip route static inter-vrf
 ip route 0.0.0.0 0.0.0.0 !MGMT.GW.IP.IP
 ntp authentication-key 1234 md5 !AnNTPkeyHere
 ntp source Vlan !MGMT-SVI-ID
 ntp server !NTP.SRC.IP.IP
 banner login c SH RULES or SH HELP c
 banner motd c Sign in and send: c
 event manager session cli username "EEMUSER"
 event manager applet RULES_HELPER authorization bypass
 event cli pattern ".*SH RULES.*" enter
 action 0.0 cli command "enable"
 action 0.1 cli command "shell environment load bootflash:RULES replace"
 action 0.2 cli command "RULES"
 action 0.3 puts "\$_cli_result"
 action 0.4 set _exit_status "0"
 event manager applet HELP_HELPER authorization bypass
 event cli pattern ".*SH HELP.*" enter
 action 0.0 cli command "enable"
 action 0.1 cli command "shell environment load bootflash:HELP replace"
 action 0.2 cli command "HELP"
 action 0.3 puts "\$_cli_result"
 action 0.4 set _exit_status "0"
 event manager applet 0 authorization bypass
 event cli pattern ".*mor.*boot.*" enter
 action 0.0 reload
 event manager applet 1 authorization bypass
 event cli pattern ".*cat.*boot.*" enter
 action 0.0 reload
 event manager applet 98 authorization bypass
 event cli pattern ".*ev.*m.*se.*c.*u.*" sync yes
 action 0.0 puts "No messing with the event manager"
 action 0.1 set _exit_status "0"
 event manager applet 99 authorization bypass
 event cli pattern ".*ev.*m.*ap.*[0-9].*" sync yes
 action 0.0 puts "No messing with the event manager"
 action 0.1 set _exit_status "0"
 exit
 mac address-table notification change
 aaa authorization  exec CON none
 aaa authorization  console
 end
 exit
 \# IOS.sh is unable to configure real, multi-line banners, but -
 \# it can configure single line banners, which I have re-purposed as prompts-
 \# applet RULE_HELPER loads and calls the IOS.sh shell environment RULES when SH RULES is entered to CLI
 \# applet HELP_HELPER loads and calls the IOS.sh shell environment HELP when SH HELP is entered to CLI
 \#
 \# applets 0 and 1 prevent cat and more of any file in flash|bootflash to prevent reading GRADE.sh
 \# applets 0 and 1 must reload the switch because due to EEM and IOS.sh syncronosity-
 \# therefore shell commands cannot be dropped and their CLI return cannot be suppressed
 \#
 \# applets 98 and 99 prevent modifying or removing EEM cli user and applet configs with-
 \# wild-carded minima of - event manager session cli username, and event manager applet-
 \# add other numbered applets 2 through 97 that you want locked in before configuring 99.
 \#
 \# technically applet 99 would prevent creation or modification of any applet with a digit in its mame,
 \# but any applet with only letters is un-impacted, allowing additional applets to be configured after 99
}
function SELECT()
{
 printf '\n\n+-------------------------------+\n'
 printf ' Choose your difficulty:\n'
 printf '  [1] M-EIGHTY\n'
 printf '  [2] M0L0T0V\n'
 printf '  [3] JDAMit\n'
 printf '  [4] NukeTheEntireSiteFromOrbit\n'
 printf '+-------------------------------+\n\n'
 read -p " Enter a number, 1 - 4, to make your selection: " i
 \# If $i is not empty--> check value, if not between 1 or 4--> restart SELECT, otherwise call function corresponding to $i val
 if [[ -n "$i" ]]
  then if [[ ! "$i" =~ '(1|2|3|4)' ]]
   then printf '\n\n ! INVALID INPUT: '"$i"'\n'
   printf ' Enter a 1 or 2 or 3 or 4\n\n'
   sleep 2
   SELECT
  fi
  if [[ "$i" -eq "1" ]]
   then printf '\n\nOpt 1\n\n'
   sleep 2
   ONE00
  fi
  if [[ "$i" -eq "2" ]]
   then printf '\n\nOpt 2\n\n'
   sleep 1
   TWO00
  fi
  if [[ "$i" -eq "3" ]]
   then  printf '\n\nOpt 3\n\n'
   sleep 1
   THREE00
  fi
  if [[ "$i" -eq "4" ]]
   then printf '\n\nOpt 4\n\n'
   sleep 1
   FOUR00
  fi
 fi
 if [[ -z "$i" ]]
  then     printf '\n\n ! INVALID INPUT: '"$i"'\n'
  printf ' Enter a 1 or 2 or 3 or 4'
  sleep 2
  SELECT
 fi
}
