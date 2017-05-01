#!/bin/bash

#NOTE: there are degree symbols in this script that will not show up if locale /= UTF-8
#add these lines below to .profile to change bash shell default
#export LC_ALL=en_US.UTF-8  
#export LANG=en_US.UTF-8

echo 'Querying HDD temps...'

#Dump hddtemp output into var
hddtemps=$(sudo hddtemp /dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdi)
#hddtemps=$(sudo hddtemp /dev/sda /dev/sdb /dev/sdc)

#Parse output into array with LF delim
readarray -t output <<<  "$hddtemps"

#parse each line into device, drive, and temp
for i in "${!output[@]}";
do

#parse each line of hddtemp output to device(), drive(), and temp()
IFS=: read dev drive temp <<< "${output[$i]}"

#remove trailing "°C" unit from temp value
IFS='°' read temp na <<< "$temp"
#remove leading space on temp
IFS=' ' read temp na <<< "$temp"

#debug
#echo "$temp"

#remove spaces from model
IFS=' ' read brand model <<< "$drive"

#Measurment=HDDtemps, Tag Keys=dev and drive type, tag value=temp
curl -s -XPOST 'http://10.0.0.116:8086/write?db=ananke' --data-binary "HDDtemps,name=$dev.$brand.$model value=$temp"

#echo "HDDtemps,name=$dev.$brand.$model value=$temp"

done
