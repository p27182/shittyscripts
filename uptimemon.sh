#!/bin/bash

#query  uptime
output=$(uptime) 

#output format:
# 14:56:00 up 25 days, 21:44, 11 users,  load average: 0.48, 0.40, 0.27

#debug
#echo "$output"


#parse out 3rd line with data
IFS=',' read time_up_day_count hour_mins user_count LAvg1 LAvg2 LAvg3 <<< "$output"

#debug
#echo "$time_up_day_count $hour_mins"

#parse out 3rd line with data
IFS=' ' read x1 x2 days x3 <<< "$time_up_day_count"
IFS=' ' read hour_mins <<< "$hour_mins"
IFS=':' read hours mins <<< "$hour_mins"

#debug
#echo "$days $hours hours $mins mins"

#Measurment=Netbw, Tag Keys=dev and drive type, tag value=temp
curl -s -XPOST 'http://10.0.0.116:8086/write?db=ananke' --data-binary "uptime,name=days value=$days"
#curl -i -XPOST 'http://192.168.1.210:8086/write?db=ananke' --data-binary "uptime,name=hours value=$hours"
#curl -i -XPOST 'http://192.168.1.210:8086/write?db=ananke' --data-binary "uptime,name=mins value=$mins"


