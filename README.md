# Bash on Cisco IOS     
|     |
| --- |
|_ _ _ _ _ _ _<img width="648" alt="ThisIsFine" src="https://github.com/user-attachments/assets/157a8b74-98f8-466f-bb77-176fa81c4725" />_ _ _ _ _ _ _|
|     |    
## [ 1 ] **Intro:**   
IOS.sh has been available in Cisco since *early* IOS 15.    
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
- environment [ SWCFG ](https://github.com/plmcdowe/Cisco-and-Bash/blob/b8ec35e9fc6876c00d25d746d1dbb7792a7b0706/SWCFG.sh)      
- environment [ SWFIX ](https://github.com/plmcdowe/Cisco-and-Bash/blob/b8ec35e9fc6876c00d25d746d1dbb7792a7b0706/SWFIX.sh)
- environment [ CAPWAP ](https://github.com/plmcdowe/Cisco-and-Bash/tree/fc4dc301a5ceb7108a0e45faa3f0f25abffe5942/DHCP-Pool)       
- 🚧 [ STIG-CHALLENGE ]()        
- 🚧 [ RTRCFG ]()       

You may notice that the shell environments in the repository are saved with the shell <i>'.sh'</i> extension.     
I only saved these as shell files for presentation in GitHub. In production, I save them as extentionless files.     
But, they will run in IOS.sh as <i>'.sh'</i> files, as well.    

I won't be deliberately covering any regex basics.      
At times, I may point out a basic regex concept for the sake of explaining IOS.sh mechanics.    
    
<i>I highly recommend these excellent resources</i>:
- [ REXEGG ](https://www.rexegg.com/regex-quickstart.php)    
- [ TLDP, Basic Regex ](https://tldp.org/LDP/Bash-Beginners-Guide/html/chap_04.html)     
- [ TLDP, Advanced Regex ](https://tldp.org/LDP/abs/html/abs-guide.html#REGEXP)     

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
>> ### *❗***There's the problem! It returns `grep [pattern that fails to match]`**
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
>>> ![stig-disconnected-trunks-func-R](https://github.com/user-attachments/assets/20c880f8-0c83-4c7c-bc9a-530f3c445724)
> ### ↘️[ 2.3 ] <ins>Setup for FIPS check and config</ins>:
>> **FIPS mode is *huge* in DoDIN compliance. Failure to run routers, switches, WLCs, etc. in FIPS mode results in:**
>>> - <b>A CAT-1 per device discovered to not be in FIPS {<i>rule IDs vary by device family for this finding</i>}</b>
>>> - <b>A Key Indicator of Risk (KIOR)</b>
>>>   - <b>KIORs were added in Command Cyber Readiness Inspection 3.0 (CCRI)</b>
>>>   - <b>if your enterprise recieves arbitrarily too many KIORs,</br></b>
>>>     <b>your enterprise (state of Indiana in my case) will be disconnected.</b>
>>>   - <b>certain KIORs are easy to remediate (non-secure services/protocols: FTP)</b>
>>>     - <b>others are difficult (FIPS)</b>
>>>     - <b>some are <i>nearly</i> impossible (replacing EOL devices mid-CCRI)</b>
>>     
>> ####  Here is the build up to a function that checks for, and configures FIPS:
>>> 1. <b>Check if the switch is a stack:</b>
>>>     - <b>If a stack, it must be unstacked, FIPS configured on each individual switch, then restacked..</b>
>>>     - <b>Obviously, requires touch labor, can't proceed remotely through the script.</b>
>>> 2. <b>If non-stack, check if already running in FIPS mode.</b>
>>> 3. <b>If already running FIPS, do nothing. If not running FIPS...</b>
>>> 4. <b>Check for a FIPS key.</b>
>>>    - <b>If there is a FIPS key, the switch just needs to be reloaded.</b>
>>>    - <b>If there is no FIPS key, configure the key; reload the switch.</b>
>>    
>> Let's check for a stack:     
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
>> **Now, let's consider what we learned earlier about `if` tests directly on a command's return.**    
>> **`sh sw | e \\*` is going to give us trouble.**    
>> **No matter what, it will always return the formatted Switch MAC & column headers.**    
>> **We can more easily work around a bum `grep` return than that default Cisco output.**    
>> ```bash
>> function stack(){
>>  if [[ ! `sh sw|grep ^[[:blank:]][[:digit:]]` =~ "grep" ]]; then printf '\nSTACK\n';
>>    else printf '\nNOT A STACK\n'; fi;
>> }
>> ```
>>> ![not-a-stack-func-R](https://github.com/user-attachments/assets/5588f6b6-b561-45da-a068-5d0e7cd8b3ff)
>> **Sweet, not a stack - let's proceed to step 2. checking FIPS status and key:**    
>> ```bash
>> # Full: ( show fips [authorization-key || status] )
>> # Shortest: ( sh fip a || sh fip s )
>>   sh fip a
>>    # "FIPS: No key installed."
>>   sh fip s
>>    # "Switch and Stacking are not running in fips mode"
>> ```
>> **Easy enough, we'll check based on 'not' and 'no'. Let's skip ahead to the complete function:**     
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
> **I needed to configure over 60 DHCP Pools on an IOS XE router, so I wrote the function CAPWAP.**     
> **<ins>What the CAPWAP function does</ins>:**
>> 1. Read line for line with `more` from a file in bootflash, containing:</b>
>>    - <b>Site Name: as an all-caps string (stores in `$NAME` within the function)</b>
>>    - <b>Network IP: as a sting in octets (stores in `$NET` within the function)</b>
>>    - <b>Network Mask: a string in octets (stores in `$MASK` within the function)</b>
>>        - <b>[Note]: the CAPWAPNETS file in [ DHCP-Pools directory ](DHCP-Pool) has placeholder Net IPs and masks.</b>
>> 2. Use a running count of loops and a modulo test to "pause" the loop to:</b>
>>    - <b>Calculate `$IP` from `$NET`</b>
>>    - <b>Configure the `dhcp exluded address` and the `pool` with `network` and `default router`</b>
> **I'll highlight the key bits here:**
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
>   # I wanted to simply perform an if conditioned on return, with:
>   #   if (( n % 3 ))
>   # But, about a dozen variations of (( and [[ expansions later, and
>   #   I am quite sure that IOS.sh has not fully implemented modulo %.
>   # In the CLI, send 'man "((" to see the IOS.sh man page for arithmetic expansion.
>   # The nearest alternative I could come up with for a divisibility test without storing in a variable is:
>   if [[ "0" == ( n - ( n / 3 * 3 ) ) ]]
>
> # Break out each octet of the Network IP into a, b, c, d
>   a=`echo $NET|cut -d "." -f 1`; b=`echo $NET|cut -d "." -f 2`; c=`echo $NET|cut -d "." -f 3`; d=`echo $NET|cut -d "." -f 4`;
> ```
> **<ins>To sum it up</ins>:**
> 1. <b>For line `l` in file, increment `n` by 1</b>
>     - <b>If `n` is less than or equal to 198, test for remainder of `n` by 3</b>
>     - <b>If there is a remainder, then `l` must contain either `SITENAME` or `NET IP`</b>
> 2. <b>Else there is no remainder:</b>
>     - <b>Then `l` is on 3rd and final loop of a site and contains `NET MASK`</b>
>     - <b>Add 1 to last octet of `NET IP` for `Default Router`</b>
>     - <b>Configure the DHCP Pool for that site</b>
> 3. <b>Continue the loop</b>
