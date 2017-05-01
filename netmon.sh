#!/bin/bash

#query ifstat
output=$(ifstat -i eth2 1 1) 

#output format:
#       eth2
# KB/s in  KB/s out
#   12.50   1431.62

#debug
#echo "$output"

#Parse output into array with LF delim
readarray -t lines <<<  "$output"

#debug
#echo "$lines"

#parse out 3rd line with data
IFS=' ' read inn out <<< "${lines[2]}"

#debug
#echo "$inn -- $out"

#Measurment=Netbw, Tag Keys=dev and drive type, tag value=temp
curl -s  -XPOST 'http://10.0.0.116:8086/write?db=ananke' --data-binary "net,name=inn value=$inn"
curl -s  -XPOST 'http://10.0.0.116:8086/write?db=ananke' --data-binary "net,name=out value=$out"

#debug
#echo "net,name=in value=$inn"
#echo "net,name=out value=$out"

