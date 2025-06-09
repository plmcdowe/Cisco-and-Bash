# Bash on Cisco IOS     
|     |
| --- |
|_ _ _ _ _ _ _<img width="648" alt="ThisIsFine" src="https://github.com/user-attachments/assets/157a8b74-98f8-466f-bb77-176fa81c4725" />_ _ _ _ _ _ _|
|     |    
## [ 1 ] **Intro:**   
IOS.sh has been available in Cisco since IOS 12.    
It is a shell environment that allows many familiar Bash/Shell commands, plus standard Cisco commands.   
IOS.sh can be enabled epehmerally with: `terminal shell` from privileged exec.     
Or, it can be configured as a permenant feature with:
```
conf t
shell processing full
```    
I chose the `shell processing full` route.    

<ins>With the feature enabled, you can save and load "shell environments", stored in bootflash</ins>.     
* to save: `shell environment save flash:EnvironmentName`
* to load: `shell environment load flash:EnvironmentName replace`
  
<ins>The documentation from Cisco isn't *great*. And, posts I've found online are from folks who either</ins>:
* copypasta from the Cisco doc's      
* *hardly* scrape the surface of this feature's capabilities.       

So, I put this readme togther with progressively more advanced examples and practical implementations.   

<ins>The examples in this README should help make sense of the Shell environments in the repository</ins>:
- environment [SWCFG](https://github.com/plmcdowe/Cisco-and-Bash/blob/b8ec35e9fc6876c00d25d746d1dbb7792a7b0706/SWCFG.sh)       
- environment [SWFIX](https://github.com/plmcdowe/Cisco-and-Bash/blob/b8ec35e9fc6876c00d25d746d1dbb7792a7b0706/SWFIX.sh)
- environment [CAPWAP](https://github.com/plmcdowe/Cisco-and-Bash/tree/fc4dc301a5ceb7108a0e45faa3f0f25abffe5942/DHCP-Pool)
  - <i>documented below at</i>: [\[ 3 \] DHCP Pool Function](https://github.com/plmcdowe/Cisco-and-Bash/blob/main/README.md#-3--dhcp-pool-function)
- environment [RTRCFG](https://github.com/plmcdowe/Cisco-and-Bash/tree/e0e4f82315d671b934fce4cb8525d6febec6ed69/Router-Config)
  - <i>documented below at</i>: [\[ 4 \] RTRCFG](https://github.com/plmcdowe/Cisco-and-Bash/tree/main#-4--rtrcfg)       
- 🚧 [STIG-CHALLENGE]()
- 🚧 [TRAINING-TROUBLESHOOTING]()        

You may notice that the shell environments in the repository are saved with the shell <i>'.sh'</i> extension.     
I only saved these as shell files for presentation in GitHub. In production, I save them as extentionless files.     
But, they will run in IOS.sh as <i>'.sh'</i> files, as well.    

I won't be deliberately covering any regex basics.      
At times, I may point out a basic regex concept for the sake of explaining IOS.sh mechanics.    
    
<i>I highly recommend these excellent resources</i>:     
[REXEGG](https://www.rexegg.com/regex-quickstart.php)    
[TLDP, Basic Regex](https://tldp.org/LDP/Bash-Beginners-Guide/html/chap_04.html)     
[TLDP, Advanced Regex](https://tldp.org/LDP/abs/html/abs-guide.html#REGEXP)     

## [ 2 ] **Intro Examples**     
> ### ↘️[ 2.1 ] <ins>IOS Version</ins>:    
>> ```Bash
>> # Full: ( show version )
>> # Shortest: sh ve
>> 
>> # Display all information about a switch or router:
>>   uname -a
>> ```
>>> ![uname-a-R](https://github.com/user-attachments/assets/5c84ea4c-cf3f-4e92-95fc-cfd2ea8a57cb)       
>> ```bash
>> # Display only the version number on routers and switches:
>>   uname -a|grep '1[5|7]'|cut -d "," -f 3|cut -d " " -f 3
>> ```
>>> ![uname-a-cut-R](https://github.com/user-attachments/assets/6b97b764-bfce-46d0-a84f-ff651d052b0e)     
>> ```bash
>> # Simple function example: $V is not empty, and $V regex match '17.12' or '17.09' -
>> #  - good where you allow any sub release within the dot release, such as 17.12.4 or 17.09.05a
>>   function version(){
>>    V=`uname -a|grep '1[5|7]'|cut -d "," -f 3|cut -d " " -f 3`
>>    if [[ -n "$V" && ( $V =~ '17.12' || $V =~ '17.09' ) ]]; then printf ''"$V"' is compliant';
>>    else printf ''"$V"' is not compliant'; fi;
>>   }
>> ```
>>> ![uname-func-1-R](https://github.com/user-attachments/assets/21a54686-85f4-4d4a-b128-061ed00e5982)     
>> ```Bash
>> # Alternatively, you could constrain to an exact release using `uname -a` with a "," in your pattern
>> # Note also, you can eliminate storing the retun and simply test the command's returned status
>>   function version(){
>>    if [[ `uname -a|grep '17.12.3,'` ]]; then printf 'compliant';
>>    else printf 'not compliant'; fi;
>>   }
>> ```
>>> ![uname-func-2-R](https://github.com/user-attachments/assets/20deb34b-2d7c-472b-b9c1-a4610ed13e9c)
>> ```Bash
>> # You can also use `( head | tail [#-of-lines] )`
>>   sh ve|head 1
>> ```
>>> ![sh-ve-head-1-R](https://github.com/user-attachments/assets/8dcdbf53-3ea1-4f7a-aa0b-fb49efec72b6)
>> ```Bash
>> # Let's try it in a function:
>>   function version(){
>>    if [[ `sh ve|grep  '17.12.04$'` ]]; then printf 'compliant';
>>    else printf 'not compliant'; fi;
>>   }
>> ```
>> ### 🔎 Our pattern is anchored with the "$" so it should return 'not compliant'.</br>A literal 17.12.04 will not match the returned 17.12.04a, but you can see in the output that our condition tested true!
>>> ![sh-ve-grep-bad-R](https://github.com/user-attachments/assets/32214d07-bc76-4bbb-b158-af5c3f8d9ba4)       
>> ```bash
>> # Let's try only the command in CLI:
>>   sh ve|grep  '17.12.04$'
>> ```
>>> ![sh-ve-grep-bad-cmd-R](https://github.com/user-attachments/assets/5ce67b27-a61d-44e7-bc8d-ea61c827c99b)    
>>
>> ### *❗***There's the problem! It returns `grep 'pattern that fails to match'`**
>> <b><ins>So, 3 main ways to handle this</ins>. (with additional options to implement that I won't dive into here)</b>
>> 1. <b>Store the cmd return in a variable, then `if [[ "$V" != "grep" && $V =~ "17.12.04" ]]; then ...`</b>
>>     * <b>Can be useful if you need the version later.</br>But, limiting loops and conditions may reduce runtime.</b>     
>> 2. <b>Use `!` for "not match": ```if [[ ! `sh ve|grep  '17.12.04a'` =~ "grep" ]]```</b>
>>     * <b>A little convoluted, but valid - I've had to use similar constructs before.</b>     
>> 3. <b>Use `i` for `include` instead of `grep` because Cisco's built in parser return's nothing.</b>
>>     * <b>Likely the best option in this case: ```if [[ `sh ve | i 17.12.04a` ]]```</b>
>>> ![sh-ve-inc-R](https://github.com/user-attachments/assets/b41e5b2c-dea3-4bf0-b1ee-4549bd9b452f)     
> ### ↘️[ 2.2 ] <ins>Interfaces</ins>:     
>> ```bash
>> # Full: ( show interface status )							
>> # Shortest: sh int statu
>>
>> # Display only connected trunk interfaces:
>>   sh int status|grep '^[[:alpha:]]{2}./.*connected[[:blank:]]{4}trunk'
>> ```
>>> ![full-only-connected-trunks-R](https://github.com/user-attachments/assets/1a3529e7-d34b-419d-9492-311155acfd7e)    
>>      
>> ```bash
>> # Display only the interface of connected trunk interfaces:
>>   sh int status|grep '^[[:alpha:]]{2}./.*connected[[:blank:]]{4}trunk'|cut -d ' ' -f 1
>> ```
>>> ![int-only-connected-trunks-R](https://github.com/user-attachments/assets/eab52130-f95f-4b90-a893-d768a605f912)
>>
>> The next block is the remaining combination of: [ <ins>connected</ins> | <ins>disconnected</ins> ] [ <ins>access</ins> | <ins>trunk</ins> ] interfaces.    
>> I'm not including screenshots for each because it will look the same as above.      
>> The `function trunks` includes a screenshot to demonstrate a simple use case for compliance.     
>> ```bash
>> # Display full output of only DISCONNECTED TRUNK interfaces *THIS SHOULD RETURN THE GREP PATTERN, NO INTERFACES*:
>>   sh int status|grep '^[[:alpha:]]{2}./.*not.*trunk'
>> # Display only the interfaces of DISCONNECTED TRUNKS *THIS SHOULD RETURN THE GREP PATTERN, NO INTERFACES*:
>>   sh int status|grep '^[[:alpha:]]{2}./.*not.*trunk'|cut -d ' ' -f 1
>> # Display full output of only CONNECTED ACCESS interfaces:
>>   sh int status|grep '^[[:alpha:]]{2}.*/.*[[:blank:]]connected[[:blank:]]{4}[[:digit:]]'
>> # Display only the interface of CONNECTED ACCESS interfaces:
>>   sh int status|grep '^[[:alpha:]]{2}.*/.*[[:blank:]]connected[[:blank:]]{4}[[:digit:]]'|cut -d ' ' -f 1
>> # Display full output of only DISONNECTED ACCESS interfaces:
>>   sh int status|grep '^[[:alpha:]]{2}.*/.*[[:blank:]]notconnect.*[[:blank:]]{3}[[:digit:]]' 
>> # Display only the interface of DISCONNECTED ACCESS interfaces:
>>   sh int status|grep '^[[:alpha:]]{2}.*/.*[[:blank:]]notconnect.*[[:blank:]]{3}[[:digit:]]'|cut -d ' ' -f 1
>> # Display the full output of CONNECTED ACCESS interfaces on vlan 84:
>>   sh int status|grep '^[[:alpha:]]{2}./.*connected[[:blank:]]{4}84'
>> # Display only the interface of CONNECTED ACCESS interfaces on vlan 84:
>>   sh int status|grep '^[[:alpha:]]{2}./.*connected[[:blank:]]{4}84'| cut -d ' ' -f 1
>> 
>> # Lets take a look at a function to introduce a simple compliance usecase:
>>   function trunks(){
>>    for t in `sh int status|grep '^[[:alpha:]]{2}./.*connected[[:blank:]]{4}trunk'| cut -d ' ' -f 1`
>>     do printf '\nMy name is '"$t"' and I am a connected trunk\n'; done;
>>    for t in `sh int status|grep '^[[:alpha:]]{2}./.*not.*trunk'|cut -d ' ' -f 1`
>>     do printf '\nDISCONNECTED trunk: '"$t"'\n  Defaulting and reconfiguring as 802.1x access\n  SV-220667r991904\n  SV-220671r991908\n'; done;
>>   }
>> ```
>>> ![stig-disconnected-trunks-func-R](https://github.com/user-attachments/assets/20c880f8-0c83-4c7c-bc9a-530f3c445724 "Can we agree to pretend that I didn't misspell disconnected?")
>>> <sup><i>Can we agree to pretend that I didn't misspell disconnected?</i></sup>
> ### ↘️[ 2.3 ] <ins>Setup for FIPS check and config</ins>:
>> **FIPS mode is *huge* in DoDIN compliance.</br>Failure to run routers, switches, WLCs, etc. in FIPS mode results in:**
>> - <b>A CAT-1 per device discovered to not be in FIPS {<i>rule IDs vary by device family for this finding</i>}</b>
>> - <b>A Key Indicator of Risk (KIOR)</b>
>>   - <b>KIORs were added in Command Cyber Readiness Inspection 3.0 (CCRI)</b>
>>   - <b>if your enterprise recieves arbitrarily too many KIORs,</br></b>
>>     <b>your enterprise (state of Indiana in my case) will be disconnected.</b>
>>   - <b>certain KIORs are easy to remediate (non-secure services/protocols: FTP)</b>
>>     - <b>others are difficult (FIPS)</b>
>>     - <b>some are <i>nearly</i> impossible (replacing EOL devices mid-CCRI)</b>
>>     
>> ####  Here is the outline of a function that checks for, and configures FIPS:
>> 1. <b>Check if the switch is a stack:</b>
>>     - <b>If a stack, it must be unstacked, FIPS configured on each individual switch, then restacked..</b>
>>     - <b>Obviously, requires touch labor, can't proceed remotely through the script.</b>
>> 2. <b>If non-stack, check if already running in FIPS mode.</b>
>> 3. <b>If already running FIPS, do nothing. If not running FIPS...</b>
>> 4. <b>Check for a FIPS key.</b>
>>    - <b>If there is a FIPS key, the switch just needs to be reloaded.</b>
>>    - <b>If there is no FIPS key, configure the key; reload the switch.</b>
>>    
>> <b><ins>Let's check for a stack</ins>:</b>
>> ```bash
>> # Full: ( show switch	)
>> # Shortest: sh sw
>> # Quickly tell if a switch is a stack:
>>   sh sw | e \\*
>>   # or
>>   sh sw|grep ^[[:blank:]][[:digit:]]
>> ```
>>> ![stack-sh-sw-e-R](https://github.com/user-attachments/assets/0c28ef97-98e6-4862-95d4-5dec5f44a908)    
>>> ![stack-sh-sw-grep-R](https://github.com/user-attachments/assets/5ee3aef1-62cd-4b2a-b1eb-bcd4016c3ce7)
>>    
>> **Now, let's consider what we learned earlier about `if` tests directly on a command's return.**
>> 
>> **`sh sw | e \\*` above, is going to give us trouble.**    
>>   - <b>No matter what, it will always return the formatted Switch MAC & column headers.</b>
>>
>> <b><ins>We can more easily work around a bad `grep` return than the default Cisco output</ins>:</b>
>> ```bash
>> function stack(){
>>  if [[ ! `sh sw|grep ^[[:blank:]][[:digit:]]` =~ "grep" ]]; then printf '\nSTACK\n';
>>    else printf '\nNOT A STACK\n'; fi;
>> }
>> ```
>>> ![not-a-stack-func-R](https://github.com/user-attachments/assets/5588f6b6-b561-45da-a068-5d0e7cd8b3ff)
>> 
>> <b><ins>Sweet, not a stack - let's proceed to step 2. checking FIPS status and key</ins>:</b>
>> ```bash
>> # Full: ( show fips [authorization-key || status] )
>> # Shortest: ( sh fip a || sh fip s )
>>   sh fip a
>>    # "FIPS: No key installed."
>>   sh fip s
>>    # "Switch and Stacking are not running in fips mode"
>> ```
>> <b><ins>Easy enough, we'll check based on 'not' and 'no'. Let's skip ahead to the complete function</ins>:</b>
>> ```bash
>> function fips(){
>>  if [[ ! `sh sw|grep ^[[:blank:]][[:digit:]]` =~ "grep" ]]; then printf '\n\nSTACK\n';
>>    else printf '\n\nNOT A STACK\n'
>>     if [[ `sh fip s | i not` ]]; then printf '\nNot in FIPS mode: CAT-1 + KIOR\n';
>>      if [[ `sh fip a | i no` ]]; then printf '\n  No FIPS Key configured\n'; 
>>       else printf '\n  FIPS Key configured, reload to put in FIPS mode\n\n'; fi; 
>>     else printf '\nFIPS mode enabled\n'; fi;
>>  fi
>> }
>> ```
>>> ![fips-func-R](https://github.com/user-attachments/assets/97eaf832-8888-43a7-8159-d18a2beb0a95)
## [ 3 ] **<ins>DHCP Pool Function</ins>:**     
> ### ↘️ I needed to configure over 60 DHCP Pools on an IOS XE router, so I wrote the function CAPWAP.
>> **<ins>What the CAPWAP function does</ins>:**
>> 1. <b>Read line for line with `more` from a file in bootflash, containing:</b>
>>    - <b>Site Name: as an all-caps string (stores in `$NAME` within the function)</b>
>>    - <b>Network IP: as a string in octets (stores in `$NET` within the function)</b>
>>    - <b>Network Mask: a string in octets (stores in `$MASK` within the function)</b>
>>        - <b>[Note]: the CAPWAPNETS file in [ DHCP-Pools directory ](DHCP-Pool) has placeholder Net IPs and masks.</b>
>> 2. <b>Use a running count of loops and a modulo test to "pause" the loop to:</b>
>>    - <b>Calculate `$IP` from `$NET`</b>
>>    - <b>Configure the `dhcp exluded address` and the `pool` with `network` and `default router`</b></br>
>
> <b><ins>I'll highlight the key bits here</ins>:</b>
> ```Bash
> # Loop lines from file in bootflash:
>   for l in `more bootflash:CAPWAPNETS`
> 
> # Constraining loops to total number of lines:
>   if [[ "$n" -le "198" ]]
>
> # Modulo test:
>   (( t = n % 3 ))
>   if [[ ! "$t" == "0" ]]
>     # I wanted to simply perform an if conditioned on return, with:
>     #   if (( n % 3 ))
>     # But, roughly a dozen variations of (( and [[ expansions later, and
>     #   I am quite sure that IOS.sh has not fully implemented modulo %.
>     # In the CLI, send 'man "((" to see the IOS.sh man page for arithmetic expansion.
> 
>     # The nearest alt. I could come up with test without storing in a variable is:
>   if [[ "0" == ( n - ( n / 3 * 3 ) ) ]]
>
> # Break out each octet of the Network IP into a, b, c, d
>   a=`echo $NET|cut -d "." -f 1`; b=`echo $NET|cut -d "." -f 2`; c=`echo $NET|cut -d "." -f 3`; d=`echo $NET|cut -d "." -f 4`;
> ```
> <b><ins>To sum it up</ins>:</b>
>> 1. <b>For line `l` in file, increment `n` by 1</b>
>>     - <b>If `n` is less than or equal to 198, test for remainder of `n` by 3</b>
>>     - <b>If there is a remainder, then `l` must contain either `SITENAME` or `NET IP`</b>
>> 2. <b>Else there is no remainder:</b>
>>     - <b>Then `l` is on 3rd and final loop of a site and contains `NET MASK`</b>
>>     - <b>Add 1 to last octet of `NET IP` for `Default Router`</b>
>>     - <b>Configure the DHCP Pool for that site</b>
>> 3. <b>Continue the loop</b>
## [ 4 ] **<ins>RTRCFG</ins>:**     
> ### ↘️ Completely configure a blank IOS 17.12 C8300 router with 3 files in +/- 10 seconds.
> 
> <b>[RTRCFG.sh](https://github.com/plmcdowe/Cisco-and-Bash/blob/e0e4f82315d671b934fce4cb8525d6febec6ed69/Router-Config/RTRCFG.sh): <b>The <i>shell environment</i> with the Bash function that:</b>
>> 1. <b>Reads in and displays all available site names with `cat bootflash:SiteNames`</b>
>> 2. <b>Reads in user input of site name as `$s`:</b>
>>     - <b>If `$s` is only capital letters 3 to 17 characters in length:</b>
>>       - <b>If `grep $s bootflash:SiteNames` is true:</b>
>>         - <b>Read in and store all IP's and masks from `more bootflash:SiteNets`</b>
>>       - <b>If `grep $s bootflash:SiteNames` is false:</b>
>>         - <b>Print error & call `RTRCFG` again</b>
>>     - <b>If `$s` is not only capital letters 3 to 17 characters in length:</b>    
>>       - <b>print error and call `RTRCFG` again</b>
>> 3. <b>With all networks stored:</b>
>>     - <b>Performs string manipulation to calulate Default Router IP's from Network IP's</b>    
>
> <b>[SiteNets](https://github.com/plmcdowe/Cisco-and-Bash/blob/9e954d4ac55003f3c1911e3dbde1994a4c2829e8/Router-Config/SiteNets): <b>extension-less file follwing the <i>sanitized</i> format below:</b>     
>> <sup><i>the `#` commented variable names are not in production, and only for correlating to the function in `RTRFCG`</i></sup>     
>> ```bash
>> UNIQUESITENAME       # $HOSTNAME
>> 123                  # unique $SITE_ID from 4th octet of MGMT/DMVPN
>> ISP.RTR.IP.IP        # $ISP_IP
>> ISP.NET.MASK.NET     # $ISP_MASK
>> ISP.GW.IP.IP         # $ISP_GW
>> PM1.RTR.NET.IP       # $PM1_NET
>> PM1.NET.MASK.NET     # $PM1_MASK
>> IOT1.RTR.NET.IP      # $IOT1_NET
>> IOT1.NET.MASK.NET    # $IOT1_MASK
>> VOIP.RTR.NET.IP      # $VOIP_NET
>> VOIP.NET.MASK.NET    # $VOIP_MASK
>> DATA1.RTR.NET.IP     # $DATA1_NET
>> DATA1.NET.MASK.NET   # $DATA1_MASK
>> DATA2.RTR.NET.IP     # $DATA2_NET
>> DATA2.NET.MASK.NET   # $DATA2_MASK
>> PM2.RTR.NET.IP       # $PM2_NET
>> PM2.NET.MASK.NET     # $PM2_MASK
>> IOT2.RTR.NET.IP      # $IOT2_NET
>> IOT2.NET.MASK.NET    # $IOT2_MASK
>> PRINT.RTR.NET.IP     # $PRINT_NET
>> PRINT.NET.MASK.NET   # $PRINT_MASK
>> IOT3.RTR.NET.IP      # $IOT3_NET
>> IOT3.NET.MASK.NET    # $IOT3_MASK
>> MGMT.RTR.NET.IP      # $MGMT_NET
>> MGMT.NET.MASK.NET    # $MGMT_MASK
>> CAPWAP.RTR.NET.IP    # $CAPWAP_NET
>> CAPWAP.NET.MASK.NET  # $CAPWAP_MASK
>> Lo.DMVPN.NET.IP      # $LO_DMVPN_IP
>> Lo.DMVPN.MASK.NET    # $LO_DMVPN_MASK
>> Lo.MGMT.NET.IP       # $LO_MGMT_IP
>> Lo.MGMT.MASK.NET     # $LO_MGMT_MASK
>> UNIQUESITENAME       # $HOSTNAME
>> # .
>> # . cut, but repeats for as many sites as necessary
>> # .
>> ```
> <b>[SiteNames](https://github.com/plmcdowe/Cisco-and-Bash/blob/d2d989c7516cf71e85fa03b716bd47677cfd4a4a/Router-Config/SiteNames): <b>extensionless file follwing the <i>sanitized</i> format below:</b>     
>> ```bash
>> ATLANTA       DETROIT         JACKSONVILLE    MINNEAPOLIS     PORTLAND        SONOMA
>> AUSTIN        DOVER           KINGSTON        MONACO          PRAGUE          SPA
>> BERLIN        DUBLIN          LEMANS          MONZA           RICHMOND        TALLADEGA
>> BIRMINGHAM    EDINBURGH       LIVERPOOL       MONTREAL        RIODEJANEIRO    TOKYO
>> BRISTOL       FLORENCE        LONDON          MUMBAI          ROME            TORONTO
>> CHARLOTTE     GLASGOW         LOSANGELES      NASHVILLE       SALZBURG        VIENNA
>> CHENNAI       GARY            LOUISVILLE      NEWORLEANS      SANDIEGO        WASHINGTON
>> CHICAGO       HAVANA          MANCHESTER      NEWYORK         SANFRANCISCO    WOODSTOCK
>> CLEVELAND     HOUSTON         MELBOURNE       OSAKA           SEATTLE         YOKOHAMA
>> DALLAS        INDIANAPOLIS    MEMPHIS         PARIS           SEBRING         ZANDVOORT
>> DAYTONA       ISTANBUL        MIAMI           PHILADELPHIA    SILVERSTONE     ZURICH
>> ```
> <b><ins>I'll highlight the key bits from `RTRCFG` here</ins>:</b>
> ```Bash
> function RTRCFG()
> {
>  t=0
>  c=0
>  cat bootflash:SiteNames
>  printf '\n\nCopy & Paste from above into the prompt below.\n'
>  read -p ": " s
>  if [[ -z "$s" || ( ! $s =~ '^[A-Z]{3,17}$' ) ]]
>   then  printf '\nIncorrect input!\n'
>   sleep 2
>   RTRCFG
>   else printf ''
>   if [[ `grep $s bootflash:SiteNames` ]]
>    then for l in `more bootflash:SiteNets`
>     do if [[ "$l" == "$s" ]]
>      then t="TRUE"
>     fi
>     if [[ "$t" == "TRUE" ]]
>      then (( c++ ))
>      if [[ "$c" -le "31" ]]
>       then if [[ "$c" == "1" ]]
>        then HOSTNAME="$l"
>       fi
>       if [[ "$c" == "2" ]]
>        then SITE_ID="$l"
>       fi
>       if [[ "$c" == "3" ]]
>        then ISP_IP="$l"
>       # .
>       # . cut for length
>       # .
>       if [[ "$c" == "31" ]]
>        then LO_MGMT_MASK="$l"
>       fi
>       else break
>      fi
>     fi
>    done
>    # String manipulation to calulate default router IP's
>    a=`echo $PM1_NET|cut -d "." -f 1`
>    b=`echo $PM1_NET|cut -d "." -f 2`
>    c=`echo $PM1_NET|cut -d "." -f 3`
>    d=`echo $PM1_NET|cut -d "." -f 4`
>    (( d = d + 1 ))
>    PM1_IP="$a.$b.$c.$d"
>    a=`echo $IOT1_NET|cut -d "." -f 1`
>    b=`echo $IOT1_NET|cut -d "." -f 2`
>    c=`echo $IOT1_NET|cut -d "." -f 3`
>    d=`echo $IOT1_NET|cut -d "." -f 4`
>    (( d = d + 1 ))
>    IOT1_IP="$a.$b.$c.$d"
>    a=`echo $VOIP_NET|cut -d "." -f 1`
>    b=`echo $VOIP_NET|cut -d "." -f 2`
>    c=`echo $VOIP_NET|cut -d "." -f 3`
>    d=`echo $VOIP_NET|cut -d "." -f 4`
>    (( d = d + 1 ))
>    VOIP_IP="$a.$b.$c.$d"      
>    # .
>    # . cut for length
>    # .
>    # Once all variables are set, the router configuration begins.
> ```
