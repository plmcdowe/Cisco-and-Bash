function pt00()
{
 conf t
 service password-encryption
 no password encryption aes
 ip scp server enable
 aaa common-criteria policy PASSWORD_POLICY
 min-length 15
 max-length 127
 numeric-count 1
 upper-case 1
 lower-case 1
 special-case 1
 char-changes 8
 end      
 for USER in `grep "^username" system:running-config | cut -d " " -f 2`
  do if [[ -n "$USER" && $USER =~ 'YourLocalAccount' ]]
   then for TYPE in `grep "YourLocalAccount" system:running-config`
    do if [[ $TYPE =~ 'password' ]]
     then conf t
     no username YourLocalAccount
     end
    fi
   done
  fi
  if [[ -n "$USER" && "$USER" != "YourLocalAccount" ]]
   then conf t
   no username "$USER"
   end
  fi
 done
 conf t
 username YourLocalAccount privilege 15 common-criteria-policy PASSWORD_POLICY secret Y0urL0c4L$3cRet
 enable secret Y0urL0c4L3n4b13
 end
 conf t
 no aaa group server radius YOUR-RADIUS-GROUP
 no aaa server radius dynamic-author
 end
 for SRV in `grep "radius server" system:running-config|cut -d " " -f 3`
  do conf t
  no radius server $SRV
  end
 done
 conf t
 radius server RADIUS-SERVER-1
 address ipv4 ip.ip.ip.ip auth-port 1812 acct-port 1813
 key y0urR4d1u$PSK
 radius server RADIUS-SERVER-2
 address ipv4 1ip.ip.ip.ip auth-port 1812 acct-port 1813
 key y0urR4d1u$PSK
 radius server RADIUS-SERVER-3
 address ipv4 ip.ip.ip.ip auth-port 1812 acct-port 1813
 key y0urR4d1u$PSK
 tacacs server TACACS-SERVER-1
 address ipv4 ip.ip.ip.ip
 key y0urT4c4c$PSK
 tacacs server TACACS-SERVER-2
 address ipv4 ip.ip.ip.ip
 key y0urT4c4c$PSK
 tacacs server TACACS-SERVER-3
 address ipv4 ip.ip.ip.ip
 key y0urT4c4c$PSK
 end
 conf t
 int vlan 200
 no ip access-group YOUR-MGMT-ACL-IN in
 no ip access-group YOUR-MGMT-ACL-OUT out
 end
 conf t
 no ip access-list extended YOUR-MGMT-ACL-IN
 no ip access-list extended YOUR-MGMT-ACL-OUT
 no ip access-list standard SNMP
 no ip access-list standard SSH
 ip access-list standard SNMP
 permit ip.ip.ip.ip
 permit ip.ip.ip.ip
 permit ip.ip.ip.ip
 permit ip.ip.ip.ip mask.mask.mask.mask
 5000 deny any log
 ip access-list standard SSH
 permit ip.ip.ip.ip
 permit ip.ip.ip.ip
 permit ip.ip.ip.ip
 permit ip.ip.ip.ip mask.mask.mask.mask
 permit ip.ip.ip.ip mask.mask.mask.mask
 5000 deny any log
 end
 for USER in `sh snmp user | grep U.*:|cut -d ":" -f 2|cut -d " " -f 2`
  do if [[ -n "$USER" ]]
   then conf t
   no snmp-server user $USER SNMP-VIEW-1 v3
   no snmp-server user $USER SNMP-VIEW-2 v3
   no snmp-server user $USER default v2c
   end
  fi
 done
 conf t
 no snmp-server
 end
 conf t
 object-group network AAA 
 description AAA appliances
 host ip.ip.ip.ip
 host ip.ip.ip.ip
 ip.ip.ip.ip mask.mask.mask.mask
 ip access-list extended YOUR-MGMT-ACL-IN
 permit icmp AAA ip.ip.ip.ip mask.mask.mask.mask
 permit tcp ip.ip.ip.ip mask.mask.mask.mask ip.ip.ip.ip mask.mask.mask.mask
 permit udp ip.ip.ip.ip mask.mask.mask.mask ip.ip.ip.ip mask.mask.mask.mask
 5000 deny any log
 ip access-list extended YOUR-MGMT-ACL-OUT
 permit icmp ip.ip.ip.ip mask.mask.mask.mask AAA
 permit tcp ip.ip.ip.ip mask.mask.mask.mask ip.ip.ip.ip mask.mask.mask.mask
 permit udp ip.ip.ip.ip mask.mask.mask.mask ip.ip.ip.ip mask.mask.mask.mask
 5000 deny any log
 end
 conf t
 aaa authentication login default group YOUR-TACACS-GROUP local
 aaa authentication enable default group YOUR-TACACS-GROUP enable
 aaa authentication dot1x default group YOUR-RADIUS-GROUP
 aaa authorization console
 aaa authorization config-commands
 aaa authorization exec default group YOUR-TACACS-GROUP local if-authenticated 
 aaa authorization exec CON none 
 aaa authorization commands 1 default group YOUR-TACACS-GROUP local if-authenticated 
 aaa authorization commands 15 default group YOUR-TACACS-GROUP local if-authenticated 
 aaa authorization network default group YOUR-RADIUS-GROUP 
 aaa accounting dot1x default start-stop group YOUR-RADIUS-GROUP
 aaa accounting exec default start-stop group YOUR-TACACS-GROUP
 aaa accounting commands 1 default start-stop group YOUR-TACACS-GROUP
 aaa accounting commands 15 default start-stop group YOUR-TACACS-GROUP
 end
 conf t
 radius-server attribute 6 on-for-login-auth
 end
 conf t
 line vty 0 15
 session-timeout 5 
 access-class SSH in vrf-also
 exec-timeout 5 0
 privilege level 15
 logging synchronous
 transport input ssh
 transport output ssh
 end
 conf t
 login block-for 900 attempts 3 within 120
 login quiet-mode access-class SSH
 login on-failure log
 login on-success log
 udld enable
 vtp domain YOURDOMAIN
 vtp mode off
 authentication mac-move permit
 dot1x system-auth-control
 no ip telnet source-interface
 no ip ftp passive
 no ip ftp source-interface
 no ip tftp source-interface
 no ip http server
 no ip http secure-server
 end
 for STR in `sh ver|grep \\*`
  do if [[ $STR =~ '17' ]]
   then conf t
   ip ssh server algorithm mac hmac-sha2-256 hmac-sha2-256-etm@openssh.com hmac-sha2-512 hmac-sha2-512-etm@openssh.com
   ip ssh server algorithm encryption aes256-gcm aes128-gcm aes256-ctr aes192-ctr aes128-ctr
   ip ssh server algorithm kex ecdh-sha2-nistp521 ecdh-sha2-nistp384 ecdh-sha2-nistp256
   ip ssh server algorithm hostkey rsa-sha2-256 rsa-sha2-512
   ip ssh server algorithm publickey rsa-sha2-256 x509v3-ecdsa-sha2-nistp256 ecdsa-sha2-nistp256 x509v3-ecdsa-sha2-nistp384 ecdsa-sha2-nistp384 x509v3-ecdsa-sha2-nistp521 rsa-sha2-512 ecdsa-sha2-nistp521 
   ip ssh client algorithm mac hmac-sha2-256 hmac-sha2-256-etm@openssh.com hmac-sha2-512 hmac-sha2-512-etm@openssh.com
   ip ssh client algorithm encryption aes256-gcm aes128-gcm aes256-ctr aes192-ctr aes128-ctr
   ip ssh client algorithm kex ecdh-sha2-nistp256 ecdh-sha2-nistp521 ecdh-sha2-nistp384
   end
  fi
  if [[ $STR =~ '15' ]]
   then conf t
   ip ssh server algorithm mac hmac-sha2-256 hmac-sha2-512
   ip ssh server algorithm encryption aes256-ctr aes192-ctr aes128-ctr
   ip ssh server algorithm kex diffie-hellman-group-exchange-sha1 diffie-hellman-group14-sha1
   ip ssh server algorithm hostkey x509v3-ssh-rsa ssh-rsa
   ip ssh server algorithm publickey x509v3-ssh-rsa ssh-rsa
   ip ssh client algorithm mac hmac-sha2-256 hmac-sha2-512 hmac-sha1 hmac-sha1-96
   ip ssh client algorithm encryption aes128-ctr aes192-ctr aes256-ctr
   ip ssh client algorithm kex diffie-hellman-group-exchange-sha1 diffie-hellman-group14-sha1
   end
  fi
 done     
 pt01
}
function pt01()
{
 for STR in `sh ver|grep \\*`
  do if [[ $STR =~ '17' ]]
   then for POLICY in `sh run | i device-.* policy`
    do if [[ -n "$POLICY" && $POLICY =~ 'IPDT' ]]
     then conf t
     no device-tracking policy $POLICY
     end
    fi
   done
   conf t
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
   end
   conf t
   logging source-interface vlan 200
   logging host ip.ip.ip.ip
   logging host ip.ip.ip.ip
   logging enable
   logging userinfo
   logging trap informational syslog-format rfc5424
   logging buffered 40960
   end
   for INT in `sh int status | grep '^[[:alpha:]]{2}./?.*not.*trunk'|cut -d " " -f 1`
    do if [[ -n "$INT" ]]
     then conf t
     default int $INT
     int $INT
     description SHUT-TRUNK
     shut
     switchport access vlan 110
     switchport mode access
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
     storm-control broadcast level bps 20m
     storm-control unicast level bps 225m
     end
    fi
   done
   for INT in `sh int status | grep '^Gi./.*connect.{3,6}[[:digit:]]{1,3}'| cut -d " " -f 1`
    do if [[ -n "$INT" ]]
     then conf t
     int $INT
     switchport access vlan 110
     no authentication event fail
     no authentication event server dead action authorize vlan
     no authentication open
     no switchport port-security
     no switchport port-security mac-address 
     no switchport port-security maximum
     no switchport port-security violation
     device-tracking attach-policy ACCESS
     dot1x timeout tx-period 5
     dot1x max-reauth-req 1
     no spanning-tree portfast
     no spanning-tree bpduguard enable
     no spanning-tree guard root
     storm-control broadcast level bps 20m
     storm-control unicast level bps 225m
     end
    fi
   done
   for INT in `sh int status | grep '^Gi./.*disabled.{5}[[:digit:]]{1,3}'| cut -d " " -f 1`
    do if [[ -n "$INT" ]]
     then conf t
     int $INT
     switchport access vlan 110
     no authentication event fail
     no authentication event server dead action authorize vlan
     no authentication open
     no switchport port-security
     no switchport port-security mac-address 
     no switchport port-security maximum
     no switchport port-security violation
     device-tracking attach-policy ACCESS
     dot1x timeout tx-period 5
     dot1x max-reauth-req 1
     no spanning-tree portfast
     no spanning-tree bpduguard enable
     no spanning-tree guard root
     storm-control broadcast level bps 20m
     storm-control unicast level bps 225m
     end
    fi
   done
  fi
  if [[ $STR =~ '15' ]]
   then conf t
   ip device tracking probe interval 60
   ip device tracking probe auto-source override
   ip device tracking probe delay 60
   end   
   conf t
   logging source-interface vlan 200
   logging host ip.ip.ip.ip
   logging host ip.ip.ip.ip
   logging enable
   logging userinfo
   logging trap informational syslog-format rfc5424
   logging buffered 40960
   end 
   for INT in `sh int status | grep '^[[:alpha:]]{2}./?.*not.*trunk'|cut -d " " -f 1`
    do if [[ -n "$INT" ]]
     then conf t
     default int $INT
     int $INT
     description SHUT-TRUNK
     shut
     switchport access vlan 110
     switchport mode access
     switchport block unicast
     switchport voice vlan 60
     ip device tracking maximum 100
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
     storm-control broadcast level bps 20m
     storm-control unicast level bps 225m
     end
    fi
   done
   for INT in `sh int status | grep '^Gi./.*connect.{3,6}[[:digit:]]{1,3}'| cut -d " " -f 1`
    do if [[ -n "$INT" ]]
     then conf t
     int $INT
     switchport access vlan 110
     no authentication event fail
     no authentication event server dead action authorize vlan
     no authentication open
     no switchport port-security
     no switchport port-security mac-address 
     no switchport port-security maximum
     no switchport port-security violation
     mls qos trust device cisco-phone
     mls qos trust cos
     ip device tracking maximum 100
     dot1x timeout tx-period 5
     dot1x max-reauth-req 1
     no spanning-tree portfast
     no spanning-tree bpduguard enable
     no spanning-tree guard root
     storm-control broadcast level bps 20m
     storm-control unicast level bps 225m
     end
    fi
   done
   for INT in `sh int status | grep '^Gi./.*disabled.{5}[[:digit:]]{1,3}'| cut -d " " -f 1`
    do if [[ -n "$INT" ]]
     then conf t
     int $INT
     switchport access vlan 110
     no authentication event fail
     no authentication event server dead action authorize vlan
     no authentication open
     no switchport port-security
     no switchport port-security mac-address 
     no switchport port-security maximum
     no switchport port-security violation
     mls qos trust device cisco-phone
     mls qos trust cos
     ip device tracking maximum 100
     dot1x timeout tx-period 5
     dot1x max-reauth-req 1
     no spanning-tree portfast
     no spanning-tree bpduguard enable
     no spanning-tree guard root
     storm-control broadcast level bps 20m
     storm-control unicast level bps 225m
     end
    fi
   done
  fi
 done
 conf t
 spanning-tree mode rapid-pvst
 spanning-tree vlan 1-4094
 spanning-tree loopguard default
 spanning-tree portfast default
 spanning-tree portfast bpduguard default
 spanning-tree extend system-id
 end
 pt02
}         
function pt02()
{
 for GRP in `grep "vlan group" system:running-config|cut -d " " -f 3`
  do if [[ -n "$GRP" ]]
   then conf t
   no vlan group $GRP vlan-list 1-4094
   no vlan group $GRP vlan-list 1-1005
   no vlan group $GRP vlan-list 1-500
   no vlan group $GRP vlan-list 501-1000
   no vlan group $GRP vlan-list 1-255
   no vlan group $GRP vlan-list 256-510
   no vlan group $GRP vlan-list 511-765
   end
  fi
 done
 for VLAN in `grep "^vlan.[[:digit:]]{1,4}" system:running-config|cut -d " " -f 2`
  do if [[ "$VLAN" != "200" && "$VLAN" != "100" && "$VLAN" != "110" ]]
   then conf t
   no vlan $VLAN
   end
  fi
 done     
 for GW in `grep "default-gateway" system:running-config|cut -d " " -f 3`
  do if [[ $GW =~ '123.45.6[7|8|9]' ]]
   then conf t
   aaa group server radius YOUR-RADIUS-GROUP
   server name RADIUS-SERVER-3
   server name RADIUS-SERVER-2
   server name RADIUS-SERVER-1
   aaa server radius dynamic-author
   client ip.ip.ip.ip server-key y0urR4d1u$PSK
   client 1ip.ip.ip.ip server-key y0urR4d1u$PSK
   client ip.ip.ip.ip server-key y0urR4d1u$PSK
   port 3799
   auth-type all
   end
   if [[ $GW =~ '123.45.7[8|9]' ]]
    then conf t
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
   for TRUNK in `sh int status|grep '^[[:alpha:]]{2}./.*connected[[:blank:]]{4}trunk'|cut -d " " -f 1`
     do conf t
     int $TRUNK
     switchport trunk allowed vlan 20,40,60,70,100,110,200,210
     end
    done  
    else conf t
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
    for TRUNK in `sh int status|grep '^[[:alpha:]]{2}./.*connected[[:blank:]]{4}trunk'|cut -d " " -f 1`
     do conf t
     int $TRUNK
     switchport trunk allowed vlan 20,40,60,70,100,110,200,210
     end
    done
   fi
  fi
  if [[ ! $GW =~ '123.45.8[2|3|4]' ]]
   then conf t
   aaa group server radius YOUR-RADIUS-GROUP
   server name RADIUS-SERVER-1
   server name RADIUS-SERVER-2
   server name RADIUS-SERVER-3
   aaa server radius dynamic-author
   client ip.ip.ip.ip server-key y0urR4d1u$PSK
   client 1ip.ip.ip.ip server-key y0urR4d1u$PSK
   client ip.ip.ip.ip server-key y0urR4d1u$PSK
   port 3799
   auth-type all
   end
   if [[ $GW =~ '123.45.9' ]]
    then conf t
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
   for TRUNK in `sh int status | grep '^[[:alpha:]]{2}./?.*connected.{4}trunk'| cut -d " " -f 1`
     do conf t
     int $TRUNK
     switchport trunk allowed vlan 20,40,60,70,100,110,200,210
     end
    done
    else conf t
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
    for TRUNK in `sh int status | grep '^[[:alpha:]]{2}./?.*connected.{4}trunk'| cut -d " " -f 1`
     do conf t
     int $TRUNK
     switchport trunk allowed vlan 20,40,60,70,100,110,200,210
     end
    done
   fi
  fi
 done
 pt03
}
function pt03()
{
 for VER in `sh ver|grep \\*`
  do if [[ $VER =~ '17' ]]
   then echo $VER
   for KEY in `sh run|grep ntp.*aut.*key|cut -d " " -f 3`
    do if [[ -n "$KEY" && "$KEY" != "123" ]]
     then conf t
     no ntp authentication-key $KEY
     ntp authentcation-key 123 hmac-sha2-256 Y0urSHA256NTPauthK3y
     end
    fi
   done
   for KEY in `sh run|grep ntp.trust|cut -d " " -f 3`
    do if [[ -n "$KEY" && "$KEY" != "123" ]]
     then conf t
     no ntp trusted-key $KEY
     end
    fi
   done
   for GW in `grep "default-gateway" system:running-config|cut -d " " -f 3`
    do if [[ $GW =~ '123.45.6[7|8|9]' ]]
     then conf t
     ntp authenticate
     ntp trusted-key 123
     ntp source vlan 200
     ntp server ip.ip.ip.ip key 123 prefer
     ntp server ip.ip.ip.ip key 123
     end
     wr
     else conf t
     ntp authenticate
     ntp trusted-key 123
     ntp source vlan 200
     ntp server ip.ip.ip.ip key 123
     ntp server ip.ip.ip.ip key 123 prefer
     end
    fi
   done
   for IP in `sh run|grep ntp.server|cut -d " " -f 3`
    do if [[ ! $IP =~ '192.168.12[0|1].[1|2].*' ]]
     then conf t
     no ntp server $IP
     end
    fi
   done
  fi
  if [[ $VER =~ '15' ]]
   then echo $VER
   for KEY in `sh run|grep ntp.*aut.*key|cut -d " " -f 3`
    do if [[ -n "$KEY" && "$KEY" != "321" ]]
     then conf t
     no ntp authentication-key $KEY
     ntp authentication-key 321 md5 Y0urMD5NTPk3y
     end
    fi
   done
   for KEY in `sh run|grep ntp.trust|cut -d " " -f 3`
    do if [[ -n "$KEY" && "$KEY" != "321" ]]
     then conf t
     no ntp trusted-key $KEY
     end
    fi
   done
   for GW in `grep "default-gateway" system:running-config|cut -d " " -f 3`
    do if [[ $GW =~ '123.45.6[7|8|9]' ]]
     then conf t
     ntp authenticate
     ntp trusted-key 321
     ntp source vlan 200
     ntp server ip.ip.ip.ip key 321 prefer
     ntp server ip.ip.ip.ip key 321
     end
     else conf t
     ntp authenticate
     ntp trusted-key 321
     ntp source vlan 200
     ntp server ip.ip.ip.ip key 321
     ntp server ip.ip.ip.ip key 321 prefer
     end
    fi
   done
   for IP in `sh run|grep ntp.server|cut -d " " -f 3`
    do if [[ ! $IP =~ '192.168.12[0|1].[1|2].*' ]]
     then conf t
     no ntp server $IP
     end
    fi
   done
  fi      
 done
 wr
 echo ""
 echo "VERIFY THAT GUARD ROOT IS APPLIED CORRECTLY TO THE FOLLOWING TRUNK INTERFACES"
 echo ""
 sleep 3
 echo "Current device:"
 echo "-------------------------------------------"
 HNAME=`uname -a | grep "C[2,3,9]"|cut -d " " -f 2`
 VER=`uname -a | grep "C[2,3,9]"|cut -d "," -f 3|cut -d " " -f 3`
 MOD=`uname -a | grep "C[2,3,9]"|cut -d " " -f 1`
 echo $HNAME,$MOD,$VER
 echo ""
 for TRUNK in `sh int status | grep '^[[:alpha:]]{2}./?.*connected.{4}trunk'| cut -d " " -f 1`
  do echo "LOCAL TRUNK: $TRUNK to > Neighbor:"
  for ITEM in `sh cdp ne $TRUNK detail`
   do if [[ $ITEM =~ '.*ng.ds.army.mil' ]]
    then HNAME=$ITEM
    if [[ $HNAME =~ 'RTR' ]]
     then echo "THIS SWITCH IS ROOT"
    fi
   fi
   if [[ $ITEM =~ '123.45.[6|7]' ]]
    then  IP=$ITEM
   fi
   if [[ $ITEM =~ '^[G|T].*[[:digit:]]/[[:digit:]].*' ]]
    then  INT=$ITEM
   fi
   if [[ $ITEM =~ '1[5|7]\..*,' ]]
    then VER=$ITEM
   fi
  done
  echo "-------------------------------------------"
  if [[ -n "$IP" && $IP =~ '123.45.[6|7]' ]]
   then echo $IP,$HNAME,$VER$INT
   else echo $HNAME,$VER$INT
  fi
  echo""
 done
}