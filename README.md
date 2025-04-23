# Bash on Cisco IOS     
---    
<img width="648" alt="ThisIsFine" src="https://github.com/user-attachments/assets/157a8b74-98f8-466f-bb77-176fa81c4725" />       

---    

## [ 1 ] **Intro:**   
IOS.sh has been available in Cisco since *early* IOS 15.    
It is a shell environment that peels back the Cisco CLI, allowing many familiar Bash/Shell commands.   
IOS.sh can be enabled epehmerally with: `terminal shell` from privileged exec.
Or, it can be configured as a permenant feature with:
```
conf t
shell processing full
```    
I have implemented `shell processing full`.
With the feature enabled, you can save and load "shell environments", stored in bootflash.     
(More on this later).    

The documentation from Cisco isn't *great*... and, posts I've found online are from folks who either -       
* copypasta from the Cisco doc's or,      
* *hardly* scrape the surface of this feature's capabilities.       

So, I put this readme togther with progressively more advanced examples with practical implementations.   
These examples should help make better sense of the Shell environments [ SWCFG ](https://github.com/plmcdowe/Cisco-and-Bash/blob/b8ec35e9fc6876c00d25d746d1dbb7792a7b0706/SWCFG.sh) and [ SWFIX ](https://github.com/plmcdowe/Cisco-and-Bash/blob/b8ec35e9fc6876c00d25d746d1dbb7792a7b0706/SWFIX.sh)     

## [ 2 ] **Examples**
```Bash
#_____________________________________________________________________________________________________________________________________________________________________________________________________________________|
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
 # Full: ( show version )
 # Shortest: sh ver
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
 #
 # Display only the version number on routers and switches:
    uname -a|grep '1[5|7]'|cut -d "," -f 3|cut -d " " -f 3
 #
 # Simple function example: $V is not empty, and $V regex match '17.12' or '17.09'
function version(){
  V=`uname -a|grep '1[5|7]'|cut -d "," -f 3|cut -d " " -f 3`
  if [[ -n "$V" && ( $V =~ '17.12' || $V =~ '17.09' ) ]]
  then
    printf ''"$V"' is compliant'
  else
    printf ''"$V"' is not compliant'
  fi
}
```

```Bash

# Simple function example: $V is not empty, and $V does not regex match '16.06', and $V does regex match '15.10' or '17.12'
# This check is mostly just to give a simple exammple 
function version(){
  V=`uname -a|grep '1[5|6|7]'|cut -d "," -f 3|cut -d " " -f 3`
  if [[ -n "$V" && ( ! "$V" =~ '16.06' && ( $V =~ '15.10' || $V =~ '17.12' ) ) ]]
  # Alternatively: if [[ -n "$V" && ( $V != '16.06' && ( $V =~ '15.10' || $V =~ '17.12' ) ) ]]
  then
    printf ''"$V"' is compliant'
  else
    printf ''"$V"' is not compliant'
  fi
}
#_____________________________________________________________________________________________________________________________________________________________________________________________________________________|
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
 # Full: ( show interface status )							
 # Shortest: sh int statu
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
 #
 # Display only trunk interfaces:
    sh int status | i trunk
 
 # Display only connected trunk interfaces:
    sh int status|grep '^[[:alpha:]]{2}./.*connected[[:blank:]]{4}trunk'
 
 # Display only the interface of connected trunk interfaces:
    sh int status|grep '^[[:alpha:]]{2}./.*connected[[:blank:]]{4}trunk'|cut -d ' ' -f 1
 
 # Display only DISCONNECTED trunk interfaces *THIS SHOULD RETURN THE GREP PATTERN, NO INTERFACES*:
    sh int status|grep '^[[:alpha:]]{2}./.*not.*trunk'
 
 # Display only access interfaces:
    sh int status | e trunk
 
 # Display full output of only connected access interfaces:
    sh int status|grep '^[[:alpha:]]{2}.*/.*[[:blank:]]connected[[:blank:]]{4}[[:digit:]]'
 
 # Display only the interface of connected access interfaces:
    sh int status|grep '^[[:alpha:]]{2}.*/.*[[:blank:]]connected[[:blank:]]{4}[[:digit:]]'| cut -d ' ' -f 1
 
 # Display full output of only disconnected access interfaces:
    sh int status|grep '^[[:alpha:]]{2}.*/.*[[:blank:]]notconnect.*[[:blank:]]{3}[[:digit:]]'
 
 # Display only the interface of disconnected access interfaces:
    sh int status|grep '^[[:alpha:]]{2}.*/.*[[:blank:]]notconnect.*[[:blank:]]{3}[[:digit:]]'| cut -d ' ' -f 1
 
 # Display the full output of connected access interfaces on vlan 112, failing authentication:
    sh int status|grep '^[[:alpha:]]{2}./.*connected[[:blank:]]{4}112'
 
 # Display only the interface of connected access interfaces on vlan 112, failing authentication:
    sh int status|grep '^[[:alpha:]]{2}./.*connected[[:blank:]]{4}112'| cut -d ' ' -f 1
 #
#_____________________________________________________________________________________________________________________________________________________________________________________________________________________|
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
 # Full: ( show switch	)
 # Shortest: sh sw
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
 #
 # Quickly tell if a switch is a stack:
    sh sw | e \\*
    # or
    sh sw|grep ^[[:blank:]][[:digit:]]
 #
#_____________________________________________________________________________________________________________________________________________________________________________________________________________________|
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
 # Full: ( show fips [authorization-key || status] )
 # Shortest: ( sh fip a || sh fip s )
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
 #
    sh fip a
    # "FIPS: No key installed."

    sh fip s
    # "FIPS: No key installed."
  #
  # Simple example function demonstrating the ability to directly test a commands return status:
    function fips(){
      if [[ `sh fips s|grep not` ]]; then printf '\n\nOof, CAT 1: not in FIPS mode.. and a Key Indicator of Risk'; 
        if [[ `sh fips a|grep no` ]]; then printf '\n\nNo FIPS Key configured either\n\n'; else printf '\n\nFIPS Key is configured, reload to put in FIPS mode\n\n'; fi; fi;
    }
  #
#_____________________________________________________________________________________________________________________________________________________________________________________________________________________|
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
 # Full: ( show mac address table [ address <mac> || interface <Gi|Po|Te> || vlan <1-4094> ] )
 # Shortest: sh mac ad
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
 #
 # Return all information for only MAC addresses on a vlan number:
    sh mac ad | i _71
    sh mac ad|grep [[:blank:]]71
    sh mac ad|grep ' 71 '

 # Return only the MAC addreses of hosts on a vlan number:
    sh mac ad|grep ' 71 '|cut -d ' ' -f 7

 # Return only the interfaces of hosts on a vlan number:
    sh mac ad|grep ' 71 '|cut -d ' ' -f 16-17

 # Return all information for only specific OUI address(es):
    sh mac ad | i 605b.30
    sh mac ad | i 0001.f0 | 1862.e4 | 1893.d7 | 20d7.78 | 247d.4d | 28ec.9a | 3045.11 | 3408.e1 | 3484.e4 | 380b.3c
    sh mac ad|grep 605b.30
    sh mac ad|grep ' 605b.30'
    sh mac ad|grep ' 605b\.30'

 # Return all information for only specific OUI addresses:
    sh mac ad|grep '(0001.f0|1862.e4|1893.d7|20d7.78|247d.4d|28ec.9a|3045.11|3408.e1|3484.e4|380b.3c|3881.d7)'

 # Return all information for only specific OUI addresses on a specific vlan:
    sh mac ad|grep '107.*(0001.f0|1862.e4|1893.d7|20d7.78|247d.4d|28ec.9a|3045.11|3408.e1|3484.e4|380b.3c|3881.d7)'

 # Return all information for only specific OUI addresses NOT on a specific vlan or vlans, this example excludes 107 & 119:
    sh mac ad|grep '(^ 1[^0][^9]).*(0001.f0|1862.e4|1893.d7|20d7.78|247d.4d|28ec.9a|3045.11|3408.e1|3484.e4|380b.3c)'

 # extend this further to return only the interfaces of hvac devices not on 107 or 119:
    sh mac ad|grep '(^ 1[^0][^9].*(1862.e4|247d.4d|28ec.9a|3045.11|3408.e1|3484.e4|380b.3c|3881.d7)'|cut -d ' ' -f 15-17

 # Return all information for a specific MAC address ending in a unique last-4 characters:
    sh mac ad | i \.9526
    sh mac ad|grep \.9526

 # Return all information for a specific interface:
    sh mac ad int g1/0/1
    sh mac ad | i 1/0/1_
    sh mac ad | i 1/0/14
    sh mac ad|grep 1/0/14
 #


#Ln122
#_____________________________________________________________________________________________________________________________________________________________________________________________________________________|
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
 # Full: ( show authentication sessions database [ interface <Gi|Po|Te> || mac <address> || method <dot1x|mab> ] { details } )
 # Shortest: sh auth ses
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
 #
 # Return auth session for a specific interface:
    sh auth ses int g1/0/1 
    sh auth ses int g1/0/1 | i ^Gi
    sh auth ses | i 1/0/1_

 # Return auth session details for a specific interface:
    sh auth ses int g1/0/1 detail

 # Return formatted auth session details for a specific interface:
    sh auth ses int g1/0/1 detail | i Interface|MAC|IPv4|__Status:|Domain|Vlan|---|dot1x|mab|User-Name|Current Policy

 # Return formatted auth session details for 802.1x sessions:
    sh auth ses method dot1x detail | i Interface|MAC|IPv4|__Status:|Domain|Vlan|---|dot1x|mab|User-Name|Current Policy

 # Return formatted auth session details for MAB sessions:
    sh auth ses method mab detail | i Interface|MAC|IPv4|__Status:|Domain|Vlan|---|dot1x|mab|User-Name|Current Policy
 #
#_____________________________________________________________________________________________________________________________________________________________________________________________________________________|
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
 # Full: ( show device-tracking database [ address <all|A.B.C.D> || interface <Gi|Te|Vlan> || mac <H.H.H|details> || vlanid <0-4096> ]	)
 # Shortest: sh device-t d
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
 #
 # sh :
    sh device-t d | i 605b.30
    sh device-t d | i 55\.70\.

 # sh :
    sh device-t d mac detail | i 605b.30|IP

 # sh :
    sh device-t d | i DH4

 # sh :
    sh device-t d|grep '(^DH4.*7486.e2)'

 # sh :
    sh device-t|grep '(^ND.*[[:digit:]]/[[:digit:]]/?[[:digit:]]?[[:space:]]{3,4}71)'
    sh device-t|grep '(^ND.*[[:space:]]71[[:space:]])'

 # sh :
    sh device-t d d|grep 'access'
    sh device-t d d|grep '(^D|^N|^A).*(access)'|cut -c 1-138
    sh device-t d d|grep '(^D|^N|^A).*(access[[:space:]]{5}[^7])'|cut -c 1-138
 #
#_____________________________________________________________________________________________________________________________________________________________________________________________________________________|
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
 # Full: ( show ip arp inspection [ interfaces <Gi|Po|Te> || log || statistics || vlan <5,20,71,107,112> ] )
 # Shortest: sh ip ar ins
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
 #
 # sh :
    sh ip ar ins s|grep '(^ V|^ -|^[[:blank:]]{3}[2|7])'

 #
#_____________________________________________________________________________________________________________________________________________________________________________________________________________________|
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
 # Full: ( show ip dhcp snooping [ binding <A.B.C.D|H.H.H|interface|vlan> || database {detail} || statistics {detail} ] )
 # Shortest: sh ip dh sn
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
 #
 # sh :
    sh ip dh sn s
    sh ip dh sn d d
    sh ip dh sn b v 71
    sh ip dh sn b|grep C4:5A:B1
    sh ip dh sn b in g1/0/13

 #
#_____________________________________________________________________________________________________________________________________________________________________________________________________________________|
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
 # Full: ( show ip source binding [ A.B.C.D || H.H.H || dhcp-snooping || interface || vlan ] )
 # Shortest: sh ip sou b
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
 #
 # sh :
    sh ip sou b|grep '(74:86:E2)'
    sh ip sou b | i 74:86:E2

 #
#_____________________________________________________________________________________________________________________________________________________________________________________________________________________|
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

```   

## [ SWCFG ](https://github.com/plmcdowe/Cisco-and-Bash/blob/b8ec35e9fc6876c00d25d746d1dbb7792a7b0706/SWCFG.sh)
```Bash

```   


## [ SWFIX ](https://github.com/plmcdowe/Cisco-and-Bash/blob/b8ec35e9fc6876c00d25d746d1dbb7792a7b0706/SWFIX.sh)
```Bash

```   
