# Shell Environment File.
# Environment Variables:
?=0
prc_change_mode=PRC_INVALID
prc_change_type=PRC_INVALID
prc_error_code=PRC_INVALID
prc_failure_type=PRC_INVALID
prc_ha_sync=PRC_INVALID
# Environment Functions:
function GRADE()
{
 kior=0
 cat1o=0
 cat2o=0
 cat3o=0
 a=0
 b=0
 c=0
 g=0
 i=0
 n=0
 s=0
 t=0
 v=0
 x=0
 y=0
 z=0
 read -p " Enter answer-key-password: " i
 if [[ "$i" == "ImaFilthyRottenCheater" ]]
  then test="TRUE"
  else test="FALSE"
 fi
 (( i = 0 ))
 \# FIPS
 if [[ `sh fips status | i not` ]]
  then (( kior = kior + 1 ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n Key Indicator of Risk (KIOR): Not in FIPS mode.\n\n'
   else printf '. '
  fi
 fi
 \# common-criteria
 for i in `grep "^aaa.common-c" system:running-config|cut -d " " -f 4`
  do if [[ -n "$i" ]]
   then (( c++ ))
   \# MINIMUM LENGTH
   if [[ `sh aaa common-criteria policy name $i | i Mini.*:_1[5-9]|Mini.*:_1[0-9][0-9]|Mini.*:_2[0-9]` ]]
    then printf '. '
    else (( n++ ))
    if [[ "$test" == "TRUE" ]]
     then printf '\n  [min-length 15]  : CAT2 SV-220537r991912 - minimum is 15\n'
     else printf '. '
    fi   
   fi
   \# UPPERCASE
   if [[ `sh aaa common-criteria policy name $i | i Upp.*:_1|Upp.*:_[1|2][0-9]|Upp.*:_[1|2][0-9][0-9]` ]]
    then printf '. '
    else (( n++ ))
    if [[ "$test" == "TRUE" ]]
     then printf '\n  [upper-case 1]   : CAT2 SV-220538r991915 - minimum is 1\n'
     else printf '. '
    fi   
   fi
   \# LOWERCASE
   if [[ `sh aaa common-criteria policy name $i | i Low.*:_1|Low.*:_[1|2][0-9]|Low.*:_[1|2][0-9][0-9]` ]]
    then printf '. '
    else (( n++ ))
    if [[ "$test" == "TRUE" ]]
     then printf '\n  [lower-case 1]    : CAT2 SV-220539r991918 - minimum is 1\n'
     else printf '. '
    fi   
   fi
   \# NUMERIC COUNT
   if [[ `sh aaa common-criteria policy name $i | i Num.*c_C.*:_1|Num.*c_C.*:_[1|2][0-9]|Num.*c_C.*:_[1|2][0-9][0-9]` ]]
    then printf '. '
    else (( n++ ))
    if [[ "$test" == "TRUE" ]]
     then printf '\n  [numeric-count 1]  : CAT2 SV-220540r991919 - minimum is 1\n'
     else printf '. '
    fi
   fi
   \# CHAR CHANGES
   if [[ `sh aaa common-criteria policy name $i | i Num.*char.*changes_[8|9]|Num.*char.*changes_[1-9][0-9]|Num.*char.*changes_[1|2][0-9][0-9]` ]]
    then printf '. '
    else (( n++ ))
    if [[ "$test" == "TRUE" ]]
     then printf '\n  [char-changes 8]  : CAT2 SV-220540r991919 - minimum is 8\n'
     else printf '. '
    fi
   fi
   \# SPECIAL COUNT
  if [[ `sh aaa common-criteria policy name $i | i Spec.*l_C.*:_1|Spec.*l_C.*:_[1|2][0-9]|Spec.*l_C.*:_[1|2][0-9][0-9]` ]]
    then printf '. '
    else (( n++ ))
    if [[ "$test" == "TRUE" ]]
     then printf '\n  [special-case 1]  : CAT2 SV-220541r991920 - minimum is 1\n'
     else printf '. '
    fi
   fi   
   else (( n++ ))
  fi
 done
 \# inner loop local accounts for outer loop of i common-criteria
 for a in `grep "^username" system:running-config|cut -d " " -f 2`
  do (( v++ ))
  \# check that current user accout has current policy applied
  z=`grep "^username.$a.*com.*-crit.*-pol.*$i" system:running-config|cut -d " " -f 2`
  if [[ $n == 0 && -n "$z" ]]
   then printf 'Compliant policy [%s] is applied to %s\n\n' $i $a
  fi
  if [[ $n > 0 && -n "$z" ]]
   then (( t++ ))
   if [[ "$test" == "TRUE" ]]
    then printf 'Non-compliant policy [%s] is applied to %s\n\n' $i $a
    else printf '. '
   fi 
  fi
  if [[ $n >= 0 && -z "$z" ]]
   then (( t++ ))
  fi
 done
done
 \# if there is no common-criteria policy configured
 if [[ $c == 0 ]]
  then (( s++ ))
 fi
 \# if local account/s have either noncompliant or no policy applied
 if [[ $t > 0 ]]
  then (( s++ ))
 fi
 if [[ $s > 0 ]]
  then (( cat2o = cat2o + 1 ))
 fi
 \# CHECK FOR username secret - enable secret - service password-encryption
 for i in `grep "((^username|^enable).*secret|^ser.*password-encryption)" system:running-config|cut -d " " -f 1`
  do if [[ -z "$i" ]]
   then (( cat1o++ ))
   if [[ "$test" == "TRUE" ]]
    then printf '{CAT1 SV-220543r991922:\n  [service password-encryption]\n  [enable secret]}\n  {CAT2 SV-220535r960969}\n  [username secret]\n\n'
    else printf '. '
   fi
  fi
  if [[ "$i" == "service" ]]
   then (( a++ ))
  fi  
  if [[ "$i" == "enable" ]]
   then (( b++ ))
  fi
  if [[ "$i" == "username" ]]
   then (( z++ ))
  fi
 done
 if [[ "$a" == "1" && "$b" == "1"  ]]
  then printf '. '
 fi
 if [[ "$a" == "0" && "$b" == "1"  ]]
  then (( cat1o + 1 ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  [enable secret] is configured, but [service password-encryption] is not.\n  This is a CAT1: SV-220543r991922, and if found on several switches - a KIOR.\n'
   else printf '. '
  fi
 fi
 if [[ "$a" == "1" && "$b" == "0"  ]]
  then (( cat1o + 1 ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  [service password-encryption] is configured, but [enable secret] is not.\n  This is a CAT1: SV-220543r991922, and if found on several switches - a KIOR.\n'
   else printf '. '
  fi
 fi
 \# CHECK FOR ftp passive AND tftp source OR ftp source
 for i in `sh run all | grep "^ip..?ftp.(p|s)"|cut -d " " -f 3`
  do if [[ -n "$i" ]]
   then if [[ $i =~ "passive" ]]
    then (( x++ ))
    if [[ "$test" == "TRUE" ]]
     then printf '  [ip ftp '"$i"'] : CAT1 SV-220534r960966\n'
     else printf '. '
    fi
   fi
   else  if [[ "$test" == "TRUE" ]]
    then printf '  [ip (t|f)tp '"$i"'] : CAT1 SV-220534r960966\n'
    else printf '. '
   fi
  fi
 done
 if [[ $x != 0 ]]
  then (( cat1o = cat1o + 1 ))
  if [[ "$test" == "TRUE" ]]
   then printf '  '"$x"' lines for 1 CAT1\n'
   else printf '. '
  fi
 fi
 \# CHECK SSH SERVER and CLIENT for WEAK CRYPTO
 if [[ `sh run | i ip_ssh_[s|c].*(sha1|ssh-rsa)` ]]
  then for i in `grep "ip.ssh.s.*(mac|encryption).*(sha1|3des)" system:running-config`
   do if [[ "$i" == "mac" ]]
    then (( cat1o++ ))
    if [[ "$test" == "TRUE" ]]
     then printf '\n\n  [ip ssh server algorithm '"$i"'] :  CAT1 SV-220555r961554\n'
     else printf '. '
    fi
   fi
   if [[ "$i" == "encryption" ]]
    then (( cat1o++ ))
    if [[ "$test" == "TRUE" ]]
     then printf '  [ip ssh server algorithm '"$i"'] : CAT1 SV-220556r961557\n'
     else printf '. '
    fi
   fi
  done
 fi
 if [[ -z `sh run | i 900.*s.3.*120` ]]
  then (( cat2o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '  CAT2 : SV-220524r960840\n  [login block-for 900 attempts 3 within 120] not configured\n\n'
   else printf '. '
  fi
 fi
 \# SV-220568r961863 logging x.x.x.x 
 a=`grep "logging host 55.71.254.175" system:running-config`
 b=`grep "logging host 55.71.100.2" system:running-config`
 if [[ -z "$a" && -z "$b" ]]
  then (( cat1o++ ))
 if [[ "$test" == "TRUE" ]]
   then printf '  [logging host (55.71.254.175 && 55.71.100.2)] not configured\n\n'
   else printf '. '
  fi
  else if [[ -n "$a" && -n "$b" ]]
   then printf '. '
   else (( cat1o++ ))
   if [[ "$test" == "TRUE" ]]
    then printf '  One [logging host] not configured\n\n'
    else printf '. '
   fi
  fi
 fi
 \# SV-220561r961827 - SV-220559r961812 - SV-220545r961290 - achive, log 
 if [[ ! `grep "^  logging enable" system:running-config` ]]
  then (( cat2o = cat2o + 7 ))
 if [[ "$test" == "TRUE" ]]
   then printf '\n\n  [archive\n   log config\n    logging enable] is not configured.. ouch:\n\n'
   printf '  CAT2 : SV-220519r960777\n'
   printf '  CAT2 : SV-220520r960780\n'
   printf '  CAT2 : SV-220521r960783\n'
   printf '  CAT2 : SV-220522r960786\n'
   printf '  CAT2 : SV-220526r960864\n'
   printf '  CAT2 : SV-220545r961290\n'
   printf '  CAT2 : SV-220559r961812\n'
   printf '  CAT2 : SV-220561r961827\n'
   else printf '. '
  fi
  else  if [[ ! `grep "^logging userinfo" system:running-config` ]]
   then (( cat2o = cat2o + 1 ))
   if [[ "$test" == "TRUE" ]]
    then printf '\n\n  CAT2 : SV-220526r960864\n  [archive\n   log config\n    logging enable] is configured.. but not [logging userinfo]:\n\n'
    else printf '. '
   fi
  fi
 fi
 \# SV-220560r961824 login on-failure
 if [[ ! `sh run | i ^log.*on-f.*g` || ( ! `sh run | i ^log.*on-s.*g` ) ]]
  then (( cat2o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  CAT2 : SV-220560r961824\n  must configure [login on-failure log] and [login on-success log]\n\n'
   else printf '. '
  fi
 fi
fi
 \# SV-220548r991923 logging trap critical
 if [[ `sh run | i logging.trap.(ale|crit|emerg|warn)` ]]
  then (( cat2o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  CAT2 : SV-220548r991923\n  must configure [logging trap (critical|errors|warnings|notifications|informational|debugging)]\n'
   else printf '. '
  fi
 fi
 \# logging buffered 4096 alerts
 if [[ `sh run | i logging.buff.*(ale|crit|emerg|warn|notif)` ]]
  then (( cat2o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  CAT2 : SV-220547r961392\n  must configure [logging buffered <4096-2147483647> (informational|debugging)]\n'
   else printf '. '
  fi
 fi
 \# CAT2 SV-220661r929003 - ip arp inspection vlan 
 if [[ ! `sh run | i ^ip arp.*vlan` ]]
  then (( cat2o++ ))
 if [[ "$test" == "TRUE" ]]
   then printf '\n\n  CAT2 : SV-220661r929003\n  must configure [ip arp inspection vlan ID-list]\n\n'
   else printf '. '
  fi  
  else for b in `sh vlan ifind|grep "^[[:digit:]]{1,3}[[:blank:]]"|cut -d " " -f 1`
   do if [[ $b =~ "^(2|[4-6]|8|1(2|[5-8])|20|71|9(5|7|9)|107|11[1-3]|119|171|25(5|6))$" ]]
    then for a in `grep "^ip arp.*vlan" system:running-config|cut -d " " -f 5|cut -d "," -f 1-20`
     do if [[ $a =~ "(^$b$|^.*-$b$)" ]]
      then if [[ $b == 20 ]]
       then (( z++ ))
      fi
      if [[ $b == 71 ]]
       then (( z++ ))
      fi
      if [[ $b == 95 ]]
       then (( z++ ))
      fi
      if [[ $b == 97 ]]
       then (( z++ ))
      fi
      if [[ $b == 99 ]]
       then (( z++ ))
      fi
      if [[ $b == 107 ]]
       then (( z++ ))
      fi
      if [[ $b == 113 ]]
       then (( z++ ))
      fi
      if [[ $b == 171 ]]
       then (( z++ ))
      fi
      if [[ $b == 255 ]]
       then (( z++ ))
      fi
      if [[ $b == 256 ]]
       then (( z++ ))
      fi
     fi
    done
   fi
  done
  if [[ $z >= 9 ]]
   then printf '. '
   else (( cat2o++ ))
   if [[ "$test" == "TRUE" ]]
    then printf '\n\n  CAT2 : SV-220661r929003\n'
    else printf '. '
   fi
  fi
 fi
 \# CAT2 SV-220659r928999 - ip dhcp snooping 
 if [[ ! `sh run | i ^ip dhcp snooping\$` ]]
  then (( cat2o++ ))
 if [[ "$test" == "TRUE" ]]
   then printf '\n\n  CAT2 : CAT2 SV-220659r928999\n  must configure [ip dhcp snooping] and [ip dhcp snooping vlan ID-list]\n\n'
   else printf '. '
  fi
  else if [[ `sh run | i ^ip.*snoop.*vlan` ]]
   then for b in `sh vlan ifind|grep "^[[:digit:]]{1,3}[[:blank:]]"|cut -d " " -f 1`
    do if [[ $b =~ "^(2|[4-6]|8|1(2|[5-8])|20|71|9(5|7|9)|107|11[1-3]|119|171|25(5|6))$" ]]
     then for a in `grep "^ip.*snoop.*vlan" system:running-config|cut -d " " -f 5|cut -d "," -f 1-20`
      do if [[ $a =~ "(^$b$|^.*-$b$)" ]]
       then if [[ $b == 20 ]]
        then (( z++ ))
       fi
       if [[ $b == 71 ]]
        then (( z++ ))
       fi
       if [[ $b == 95 ]]
        then (( z++ ))
       fi
       if [[ $b == 97 ]]
        then (( z++ ))
       fi
       if [[ $b == 99 ]]
        then (( z++ ))
       fi
       if [[ $b == 107 ]]
        then (( z++ ))
       fi
       if [[ $b == 113 ]]
        then (( z++ ))
       fi
       if [[ $b == 171 ]]
        then (( z++ ))
       fi
       if [[ $b == 255 ]]
        then (( z++ ))
       fi
       if [[ $b == 256 ]]
        then (( z++ ))
       fi
      fi
     done
    fi
   done
   else (( cat2o++ ))
   if [[ "$test" == "TRUE" ]]
    then printf '\n  [ip dhcp snooping vlan ID-list] not configured\n\n'
    else printf '. '
   fi
  fi
  if [[ $z >= 9 ]]
   then printf '. '
   else (( cat2o++ ))
   if [[ "$test" == "TRUE" ]]
    then printf '\n\n  CAT2 : SV-220661r929003\n'
    else printf '. '
   fi
  fi
 fi
 \# SV-220650r539671 - VTP mode off
 i=`sh vtp status|grep "Oper.*: "|cut -d ":" -f 2|cut -d " " -f 2`
 if [[ ! `sh vtp status | i _Oper.*:_Off` ]]
  then (( cat2o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  CAT2 : SV-220650r539671\n  must disable VTP [vtp mode off]\n\n'
   else printf '. '
  fi
 fi
 \# SV-220656r856278 - spanning-tree portfast bpduguard default
 if [[ ! `sh run | i spann.*bpduguard default` ]]
  then (( cat2o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  CAT2 : SV-220656r856278\n  must configure [spanning-tree portfast bpduguard default]\n\n'
   else printf '. '
  fi
 fi
 \# SV-220665r539671
 if [[ ! `sh run | i udld.enable` ]]
  then (( cat2o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  CAT2 : SV-220665r539671\n  must configure [udld enable]\n\n'
   printf '. '
  fi
 fi
 \# CAT2 SV-220663r929005 - igmp
 if [[ ! `sh run | i ^no.igmp` ]]
  then (( cat2o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  CAT2 : SV-220663r929005\n  must not disable the default [igmp snooping]\n\n'
   else printf '. '
  fi
 fi
 \# CAT2 : SV-220664r539671  CAT2 : SV-220657r856279
 (( a = 0 ))
 (( b = 0 ))
 a=`sh run | i ^spann.*rapid-pvst`
 b=`sh run | i ^spann.*loopguard_default`
 if [[ -z "$a" ]]
  then (( cat2o + 2 ))
 if [[ "$test" == "TRUE" ]]
   then printf '\n\n  CAT2 : SV-220664r539671\n  CAT2 : SV-220657r856279\n  must configure [spanning-tree mode rapid-pvst]\n\n'
   else printf '. '
  fi
  else if [[ -z "$b" ]]
   then (( cat2o++ ))
   if [[ "$test" == "TRUE" ]]
    then printf '\n\n  CAT2 : SV-220657r856279\n  must configure [spanning-tree loopguard default]\n\n'
    else printf '. '
   fi
  fi
 fi
 \# CAT3 SV-220662r648766 - storm-control
 x=''
 y=''
 for i in `sh int status|cut -d " " -f 1`
  do if [[ ! `sh run int $i|grep "description.*ACCESS"` =~ "grep" ]]
   then x=''
   y=''
   x=`sh run int $i | i cont.*uni.*bps 225m`
   y=`sh run int $i | i cont.*broad.*bps 20m`
   if [[ -n "$x" && -n "$y" ]]
    then printf '. '
   fi
   if [[ -z "$x" && -z "$y" ]]
    then (( n++ ))
    if [[ "$test" == "TRUE" ]]
     then printf '\n\n  '"$i"' CAT3 : SV-220662r648766 [storm-control unicast level 225m] [storm-control broadcast level 20m]'
     else printf '. '
    fi
   fi
   if [[ -z "$x" && -n "$y" ]]
    then (( n++ ))
    if [[ "$test" == "TRUE" ]]
     then printf '\n\n  '"$i"' CAT3 : SV-220662r648766 [storm-control broadcast level 20m]'
     else printf '. '
    fi
   fi
   if [[ -n "$x" && -z "$y" ]]
    then (( n++ ))
    if [[ "$test" == "TRUE" ]]
     then printf '\n\n  '"$i"' CAT3 : SV-220662r648766 [storm-control unicast level 225m]'
     else printf '. '
    fi
   fi
  fi
 done
 if [[ $n > 0 ]]
  then (( cat3o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  '"$n"' lines for 1 CAT3 : SV-220662r648766\n'
   else printf '. '
  fi
 fi
 \# CAT2 SV-220660r929001 - ip source guard
 for i in `sh int status|cut -d " " -f 1`
  do if [[ ! `sh run int $i|grep "description.*ACCESS"` =~ "grep" ]]
   then  if [[ ! `sh run int $i | i ip verify source` ]]
    then (( n++ ))
    if [[ "$test" == "TRUE" ]]
     then printf '\n\n  '"$i"' CAT2 : SV-220660r929001 [ip verify source]'
     else printf '. '
    fi
   fi
  fi
 done
 if [[ $n > 0 ]]
  then (( cat3o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  '"$n"' lines for 1 CAT3 : SV-220662r648766\n'
  fi
 fi
 \# CAT2 SV-220658r856280 - switchport block unicast
 for i in `sh int status|cut -d " " -f 1`
  do if [[ ! `sh run int $i|grep "description.*ACCESS"` =~ "grep" ]]
   then if [[ ! `sh run int $i | i block unicast` ]]
    then (( n++ ))
    if [[ "$test" == "TRUE" ]]
     then printf '\n\n  '"$i"' CAT2 : SV-220658r856280 [switchport block unicast]'
     else printf '. '
    fi
   fi
  fi
 done
 if [[ $n > 0 ]]
  then (( cat3o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  '"$n"' lines for 1 CAT2 : SV-220658r856280\n'
  fi
 fi
 \# CAT2 SV-220668r991905 - non default access vlan || CAT3 SV-220673r991910 - access non native vlan ID
 (( y = 0 ))
 for i in `sh int status|cut -d " " -f 1`
  do if [[ ! `sh run int $i|grep "description.*ACCESS"` =~ "grep" ]]
   then if [[ ! `sh run int $i | i acc.*lan` ]]
    then (( n++ ))
   if [[ "$test" == "TRUE" ]]
     then printf '\n\n  '"$i"' CAT3 : SV-220673r991910 & CAT2 : SV-220668r991905 config access to non-production vlan [switchport access vlan 112] and not vlan 1'
     else printf '. '
    fi
    else if [[ ! `sh run int $i | i acc.*lan_112` ]]
     then (( y++ ))
     if [[ "$test" == "TRUE" ]]
      then printf '\n\n  '"$i"' CAT3 : SV-220673r991910 config access to non-production vlan [switchport access vlan 112]'
      else printf '. '
     fi
    fi
   fi
  fi
 done
 if [[ $y > 0 && $n > 0 ]]
  then (( cat2o++ ))
  (( cat3o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  '"$n"' lines for 1 CAT2 : SV-220668r991905 and '"$y"' lines for 1 CAT3 : SV-220673r991910\n'
   else printf '. '
  fi
 fi
 if [[ $n > 0 && "$y" == "0" ]]
  then (( cat2o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  '"$n"' lines for 1 CAT2 : SV-220668r991905\n'
   else printf '. '
  fi
 fi
 if [[ "$n" == "0" && $y > 0 ]]
  then (( cat2o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  '"$n"' lines for 1 CAT2 : SV-220668r991905\n'
   else printf '. '
  fi
 fi 
 \# 802.1x - CAT1 : SV-220649r863283
 \# aaa group server radius 8021XSERV
 i=`sh run aaa group server radius|grep "radius"|cut -d " " -f 5`
 if [[ -z "$i" ]]
  then (( x++ ))
 if [[ "$test" == "TRUE" ]]
   then printf '\n\n  CAT1 : [aaa group server radius], not configured\n'
   else printf '. '
  fi
  else i=`grep "^aaa.*auth.*dot1x.*group.$i" system:running-config`
  if [[ -z "$i" ]]
   then (( x++ ))
  if [[ "$test" == "TRUE" ]]
    then printf '\n\n  CAT1 : [aaa authentication dot1x default group], not configured\n'
    else printf '. '
   fi
   else for i in `sh run aaa group server radius|grep "name"|cut -d " " -f 4`
    do if [[ -n "$i" && $i != "grep" ]]
     then a=`grep "^radius.s.*$i" system:running-config`
     if [[ -n "$a" && $a != "grep" ]]
      then (( b++ ))
     fi
    fi
   done
  fi
  (( a = 0 ))
  y=`grep "dot.*sys.*control" system:running-config`
  if [[ $b < 2 && -n "$y" ]]
   then (( x++ ))
   if [[ "$test" == "TRUE" ]]
    then printf '\n\n  CAT1 : SV-220649r863283 and KIOR:\n    A minimum of named 2 radius servers must be configured,\n'
    printf '    The 2 named servers must be configured in a radius group,\n'
    printf '    And dot1x must use that group in [aaa authentication dot1x default group NAME].\n'
    else printf '. '
   fi
  fi
  if [[ $b < 2 && -z "$y" ]]
   then (( x++ ))
   if [[ "$test" == "TRUE" ]]
    then printf '\n\n  CAT1 : SV-220649r863283 and KIOR:\n    Missing [dot1x system-auth-control]\n'
    printf '    A minimum of 2 named radius servers must be configured,\n'
    printf '    The 2 named servers must be configured in a radius group,\n'
    printf '    And dot1x must use that group in [aaa authentication dot1x default group NAME].\n'
    else printf '. '
   fi
  fi
  if [[ $b > 2 && -z "$y" ]]
   then (( x++ ))
   if [[ "$test" == "TRUE" ]]
    then printf '\n\n  CAT1 : SV-220649r863283 and KIOR:\n    Missing [dot1x system-auth-control]\n'
    else printf '. '
   fi
  fi
  if [[ $b > 2 && -n "$y" ]]
   then if [[ "$test" == "TRUE" ]]
    then printf '\n\n  '"$y"' is configured and >= 2 radius servers are correctly configured for dot1x\n'
    else printf '. '
   fi
  fi
 fi
 (( y = 0 ))
 (( b = 0 ))
 for i in `sh int status|cut -d " " -f 1`
  do if [[ ! `sh run int $i|grep "description.*ACCESS"` =~ "grep" ]]
   then if [[ `sh run int $i | i open` ]]
    then (( n++ ))
    (( x++ ))
    (( y++ ))
    if [[ "$test" == "TRUE" ]]
     then printf '\n\n  '"$i"' [authentication open]'
     else printf '. '
    fi
   fi
   if [[ ! `sh run int $i | i port-control auto` ]]
    then (( n++ ))
    (( x++ ))
    if [[ "$test" == "TRUE" ]]
     then printf '\n\n  '"$i"' [authentication port-control auto]'
     else printf '. '
    fi
   fi
   if [[ ! `sh run int $i | i dot1x pae authenticator` ]]
    then (( n++ ))
    (( x++ ))
    if [[ "$test" == "TRUE" ]]
     then printf '\n\n  '"$i"' [dot1x pae authenticator]'
     else printf '. '
    fi
   fi
   if [[ ! `sh run int $i | i authentication order dot1x mab` ]]
    then (( n++ ))
    (( x++ ))
    if [[ "$test" == "TRUE" ]]
     then printf '\n\n  '"$i"' [authentication order dot1x mab]'
     else printf '. '
    fi
   fi
   if [[ `sh run int $i | i auth.*dead.*vlan` ]]
    then (( n++ ))
    (( x++ ))
    if [[ "$test" == "TRUE" ]]
     then printf '\n\n  '"$i"' [authentication event server dead action authorize vlan]'
     else printf '. '
    fi
   fi
   if [[ `sh run int $i| i auth.*event.*fail.*auth.*vlan 71` ]]
    then (( n++ ))
    (( x++ ))
    (( y++ ))
    if [[ "$test" == "TRUE" ]]
     then printf '\n\n  '"$i"' [authentication event fail action authorize vlan]'
     else printf '. '
    fi
   fi
  fi
 done
 (( b = n + x + y ))
 if [[ $n == 0 && $x == 0 && $y == 0 ]]
  then printf '\n\n  Wow.. good job\n'
  else (( cat1o++ ))
  (( kior++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  1 CAT1 : SV-220649r863283 from '"$b"' lines\n\n'
   else printf '. '
  fi
 fi
 (( a=0 ))
 (( b=0 ))
 (( c=0 ))
 (( g=0 ))
 (( i=0 ))
 (( n=0 ))
 (( s=0 ))
 (( t=0 ))
 (( v=0 ))
 (( x=0 ))
 (( y=0 ))
 (( z=0 ))
 if [[ ! `sh run | i ^cla.*Out` ]]
  then (( g++ ))
 if [[ "$test" == "TRUE" ]]
   then printf '\n\n  '"$i"' CAT2 : SV-220651r991903 [ service-policy output ]'
   else printf '. '
  fi
  else printf '. '
 fi
 if [[ ! `sh run | i ^pol.*Out` ]]
  then (( g++ ))
 if [[ "$test" == "TRUE" ]]
   then printf '\n\n  '"$i"' CAT2 : SV-220651r991903 [ service-policy output ]'
   else printf '. '
  fi
  else printf '. '
 fi 
 \# CAT3 SV-220655r917683 - spanning-tree guard root
 for i in `sh int status|cut -d " " -f 1`
  do  if [[ ! `sh run int $i | i ^_ser.*-p.*out` ]]
   then (( g++ ))
  if [[ "$test" == "TRUE" ]]
    then printf '\n\n  '"$i"' CAT2 : SV-220651r991903 [ service-policy output ]'
    else printf '. '
   fi
   else printf '. '
  fi
  if [[ `sh int $i | i DNLINK` ]]
   then if [[ ! `sh run int $i | i span.*gu.*ro` ]]
    then (( a++ ))
   if [[ "$test" == "TRUE" ]]
     then printf '\n\n  '"$i"' CAT3 : SV-220655r917683 [ spanning-tree guard root ]'
     else printf '. '
    fi
    else printf '. '
   fi
  fi
  if [[ `sh run int $i | i ^_sw.*mo.*tru` && `sh run int $i | i ^_sw.*tr.*all.*vlan_1,` ]]
   then (( b++ ))
   if [[ "$test" == "TRUE" ]]
    then printf '\n\n  '"$i"' CAT2 : SV-220669r991906 [ Prune VLAN 1 from any trunk links as necessary ]'
    else printf '. '
   fi
  fi 
  if [[ `sh run int $i | i ^_sw.*mo.*tru` && ( ! `sh run int $i | i ^_sw.*noneg` ) ]]
   then (( c++ ))
   if [[ "$test" == "TRUE" ]]
    then printf '\n\n  '"$i"' CAT2 : SV-220666r539671 [ switchport nonegotiate ]'
    else printf '. '
   fi
  fi   
  if [[ `sh run int $i | i ^_sw.*mo.*tru` && ( ! `sh run int $i | i tr.*ive.*vlan` ) ]]
   then (( v++ ))
   if [[ "$test" == "TRUE" ]]
    then printf '\n\n  '"$i"' CAT2 : SV-220672r991909 [ switchport trunk native vlan not 1 ]'
    else printf '. '
   fi
  fi
  if [[ `sh run int $i | i ^_sw.*mo.*acc` && ( ! `sh run int $i | i acc.*vlan` ) ]]
   then (( v++ ))
   if [[ "$test" == "TRUE" ]]
    then printf '\n\n  '"$i"' CAT2 : SV-220672r991909 [ switchport trunk native vlan not 1 ]'
    else printf '. '
   fi
  fi      
 done
 if [[ $a > 0 ]]
  then (( cat3o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  '"$a"' lines for 1 CAT3 : SV-220655r917683\n'
   else printf '. '
  fi
 fi  
 if [[ $b > 0 ]]
  then (( cat2o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  '"$b"' lines for 1 CAT2 : SV-220669r991906\n'
   else printf '. '
  fi
 fi
 if [[ $c > 0 ]]
  then (( cat2o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  '"$c"' lines for 1 CAT2 : SV-220666r539671\n'
   else printf '. '
  fi
 fi
 if [[ $g > 0 ]]
  then (( cat2o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  '"$g"' lines for 1 CAT2 : SV-220651r991903\n'
   else printf '. '
  fi
 fi
 if [[ $v > 0 ]]
  then (( cat2o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  '"$v"' lines for 1 CAT2 : SV-220672r991909\n'
   else printf '. '
  fi
 fi     
 (( n = 0 ))
 \# NTP - CAT2 : SV-220554r961506 
 if [[ ! `grep "(ntp.auth|ntp.*key)" system:running-config` ]]
  then (( cat2o = cat2o + 1 ))
 if [[ "$test" == "TRUE" ]]
   then printf '\n\n  CAT2 : SV-220554r961506\n\n  missing:\n    [ntp authentication-key]\n    [ntp authenticate]\n    [ntp trusted-key]\n    [ntp server x.x.x.x key]\n'
   else printf '. '
  fi
  else i=`grep "ntp.t.*key" system:running-config|cut -d " " -f 3`
  if [[ -z "$i"  ]]
   then if [[ `grep "ntp.a.*key" system:running-config|cut -d " " -f 3` ]]
    then (( cat2o = cat2o + 1 ))
    if [[ "$test" == "TRUE" ]]
     then printf '\n\n  CAT2 SV-220554r961506\n  [ntp authentication-key] configured but not trusted\n'
     else printf '. '
    fi
   fi
   else (( x += i ))
   if [[ "$test" == "TRUE" ]]
    then printf '\n x: '"$x"' i: '"$i"'\n'
    else printf '. '
   fi
   i=`grep "ntp.a.*key" system:running-config|cut -d " " -f 3`
   if [[ "$test" == "TRUE" ]]
    then printf '\n grep "ntp.a.*key" system:running-config|cut -d " " -f 3 i: '"$i"'\n'
    else printf '. '
   fi
   if [[ -n "$i" && "$i" != "$x" ]]
    then (( n++ ))
    if [[ "$test" == "TRUE" ]]
     then printf '\n [[ -n "$i" && "$i" != "$x" ]]\n\n  CAT2 SV-220554r961506\n '"$i"' key ID mismatch '"$x"''
     else printf '. '
    fi
   fi
   i=`grep "ntp.s.*key" system:running-config|cut -d " " -f 5`
   if [[ "$test" == "TRUE" ]]
    then printf '\n grep "ntp.s.*key" system:running-config|cut -d " " -f 5 i: '"$i"'\n'
    else printf '. '
   fi
   if [[ -n "$i" && "$i" != "$x" ]]
    then (( n++ ))
   if [[ "$test" == "TRUE" ]]
     then printf '\n [[ -n "$i" && "$i" != "$x" ]]\n\n  CAT2 SV-220554r961506 '"$i"' key ID mismatch '"$x"''
     else printf '. '
    fi
    else  if [[ -z "$i" ]]
     then (( n++ ))
     if [[ "$test" == "TRUE" ]]
      then printf '\n\n  CAT2 SV-220554r961506\n  no key applied to ntp server'
      else printf '. '
     fi
    fi
   fi
  fi
  if [[ $n != 0 ]]
   then (( cat2o = cat2o + 1 ))
   if [[ "$test" == "TRUE" ]]
    then printf '\n\n  '"$n"' lines for 1 CAT2 SV-220554r961506\n'
    printf '. '
   fi
  fi
 fi
 (( i = 0 ))
 (( a = 0 ))
 (( b = 0 ))
 (( c = 0 ))
 (( x = 0 ))
 \# CAT3 SV-220655r917683 - spanning-tree guard root
 for i in `sh int status|cut -d " " -f 1`
  do  if [[ `sh int $i | i DNLINK` ]]
   then if [[ ! `sh run int $i | i span.*gu.*ro` ]]
    then (( a++ ))
   if [[ "$test" == "TRUE" ]]
     then printf '\n\n  '"$i"' CAT3 : SV-220655r917683 [ spanning-tree guard root ]'
     else printf '. '
    fi
    else printf '. '
   fi
  fi
  if [[ `sh run int $i | i ^_sw.*mo.*tru` && `sh run int $i | i ^_sw.*tr.*all.*vlan_1,` ]]
   then (( b++ ))
   if [[ "$test" == "TRUE" ]]
    then printf '\n\n  '"$i"' CAT2 : SV-220669r991906 [ Prune VLAN 1 from any trunk links as necessary ]'
    else printf '. '
   fi
  fi 
  if [[ `sh run int $i | i ^_sw.*mo.*tru` && ( ! `sh run int $i | i ^_sw.*noneg` ) ]]
   then (( c++ ))
   if [[ "$test" == "TRUE" ]]
    then printf '\n\n  '"$i"' CAT2 : SV-220666r539671 [ switchport nonegotiate ]'
    else printf '. '
   fi
  fi
  \#
  if [[ `sh run int $i | i ^_sw.*noneg` && ( `sh run int $i | i ^_sw.*tr.*all.*vlan_.*,111-113,` || `sh run int $i | i ^_sw.*tr.*all.*vlan_.*,112,` ) ]]
   then (( x++ ))
   if [[ "$test" == "TRUE" ]]
    then printf '\n\n  '"$i"' CAT2 : SV-220666r539671 [ switchport nonegotiate ]'
    else printf '. '
   fi
  fi   
 done
 if [[ $a > 0 ]]
  then (( cat3o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  '"$a"' lines for 1 CAT3 : SV-220655r917683\n'
   else printf '. '
  fi
 fi  
 if [[ $b > 0 ]]
  then (( cat2o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  '"$b"' lines for 1 CAT2 : SV-220669r991906\n'
   else printf '. '
  fi
 fi
 if [[ $c > 0 ]]
  then (( cat2o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  '"$c"' lines for 1 CAT2 : SV-220666r539671\n'
   else printf '. '
  fi
 fi  
 if [[ $x > 0 ]]
  then (( cat2o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  '"$x"' lines for 1 CAT2 : SV-220666r539671\n'
   else printf '. '
  fi
 fi
 \# CAT2 SV-220660r929001 - ip source guard
 for i in `sh int status|cut -d " " -f 1`
  do if [[ ! `sh run int $i|grep "description.*ACCESS"` =~ "grep" ]]
   then  if [[ ! `sh run int $i | i ip verify source` ]]
    then (( n++ ))
    if [[ "$test" == "TRUE" ]]
     then printf '\n\n  '"$i"' CAT2 : SV-220660r929001 [ip verify source]'
     else printf '. '
    fi
   fi
  fi
 done
 if [[ $n > 0 ]]
  then (( cat3o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  '"$n"' lines for 1 CAT3 : SV-220662r648766\n'
  fi
 fi
 \# CAT2 SV-220658r856280 - switchport block unicast
 for i in `sh int status|cut -d " " -f 1`
  do if [[ ! `sh run int $i|grep "description.*ACCESS"` =~ "grep" ]]
   then if [[ ! `sh run int $i | i block unicast` ]]
    then (( n++ ))
    if [[ "$test" == "TRUE" ]]
     then printf '\n\n  '"$i"' CAT2 : SV-220658r856280 [switchport block unicast]'
     else printf '. '
    fi
   fi
  fi
 done
 if [[ $n > 0 ]]
  then (( cat3o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  '"$n"' lines for 1 CAT2 : SV-220658r856280\n'
  fi
 fi
 \# CAT2 SV-220668r991905 - non default access vlan || CAT3 SV-220673r991910 - access non native vlan ID
 (( y = 0 ))
 for i in `sh int status|cut -d " " -f 1`
  do if [[ ! `sh run int $i|grep "description.*ACCESS"` =~ "grep" ]]
   then if [[ ! `sh run int $i | i acc.*lan` ]]
    then (( n++ ))
   if [[ "$test" == "TRUE" ]]
     then printf '\n\n  '"$i"' CAT3 : SV-220673r991910 & CAT2 : SV-220668r991905 config access to non-production vlan [switchport access vlan 112] and not vlan 1'
     else printf '. '
    fi
    else if [[ ! `sh run int $i | i acc.*lan_112` ]]
     then (( y++ ))
     if [[ "$test" == "TRUE" ]]
      then printf '\n\n  '"$i"' CAT3 : SV-220673r991910 config access to non-production vlan [switchport access vlan 112]'
      else printf '. '
     fi
    fi
   fi
  fi
 done
 if [[ $y > 0 && $n > 0 ]]
  then (( cat2o++ ))
  (( cat3o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  '"$n"' lines for 1 CAT2 : SV-220668r991905 and '"$y"' lines for 1 CAT3 : SV-220673r991910\n'
   else printf '. '
  fi
 fi
 if [[ $n > 0 && "$y" == "0" ]]
  then (( cat2o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  '"$n"' lines for 1 CAT2 : SV-220668r991905\n'
   else printf '. '
  fi
 fi
 if [[ "$n" == "0" && $y > 0 ]]
  then (( cat2o++ ))
  if [[ "$test" == "TRUE" ]]
   then printf '\n\n  '"$n"' lines for 1 CAT2 : SV-220668r991905\n'
   else printf '. '
  fi
 fi
 printf '\n{ KIOR : '"$kior"' }{ CAT-1 : '"$cat1o"' }{ CAT-2 : '"$cat2o"' }{ CAT-3 : '"$cat3o"' }\n'
}
