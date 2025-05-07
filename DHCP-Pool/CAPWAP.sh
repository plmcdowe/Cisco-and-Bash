function CAPWAP() {
n=0
for l in `more bootflash:CAPWAPNETS`
do
 (( n++ ))
 if [[ "$n" -le "198" ]]
 then
   (( t = n % 3 ))
   if [[ ! "$t" == "0" ]]
   then
    if [[ $l =~ '^[A-Z]+' ]]
    then
     NAME="$l"
    else
     NET="$l"
    fi
  else
   MASK="$l"
   a=`echo $NET|cut -d "." -f 1`; b=`echo $NET|cut -d "." -f 2`; c=`echo $NET|cut -d "." -f 3`; d=`echo $NET|cut -d "." -f 4`;
   (( d = d + 1 ))
   IP="$a.$b.$c.$d"
   conf t
   ip dhcp excluded address $IP
   ip dhcp pool $NAME
    network $NET $MASK
    default router $IP
    lease 5
    end
  fi
 fi
done
}