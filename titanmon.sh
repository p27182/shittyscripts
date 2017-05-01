#!/bin/bash

echo "Press Ctl+C to Stop..."

while sleep 1

do

#------------------------
# SNMP QUERIES -> Variables
#------------------------

cpu1=$(snmpget -v2c -c mycommunity 10.0.0.2 .1.3.6.1.2.1.25.3.3.1.2.5)
cpu2=$(snmpget -v2c -c mycommunity 10.0.0.2 .1.3.6.1.2.1.25.3.3.1.2.6)
cpu3=$(snmpget -v2c -c mycommunity 10.0.0.2 .1.3.6.1.2.1.25.3.3.1.2.7)
cpu4=$(snmpget -v2c -c mycommunity 10.0.0.2 .1.3.6.1.2.1.25.3.3.1.2.8)
cpu5=$(snmpget -v2c -c mycommunity 10.0.0.2 .1.3.6.1.2.1.25.3.3.1.2.9)
cpu6=$(snmpget -v2c -c mycommunity 10.0.0.2 .1.3.6.1.2.1.25.3.3.1.2.10)
cpu7=$(snmpget -v2c -c mycommunity 10.0.0.2 .1.3.6.1.2.1.25.3.3.1.2.11)
cpu8=$(snmpget -v2c -c mycommunity 10.0.0.2 .1.3.6.1.2.1.25.3.3.1.2.12)

uptime=$(snmpget -v2c -c mycommunity 10.0.0.1 .1.3.6.1.2.1.1.3.0)
#repsonse: iso.3.6.1.2.1.1.3.0 = Timeticks: (661096) 1:50:10.96

eth0in=$(snmpget -v2c -c mycommunity 10.0.0.2 .1.3.6.1.2.1.2.2.1.10.10)
eth0out=$(snmpget -v2c -c mycommunity 10.0.0.2 .1.3.6.1.2.1.2.2.1.16.10)
#repsonse: iso.3.6.1.2.1.2.2.1.10.2 = Counter32: 3471811086
#eth0status=$(snmpget -v2c -c mycommunity 10.0.0.1 .1.3.6.1.2.1.2.2.1.8.2)
#response: iso.3.6.1.2.1.2.2.1.8.2 = INTEGER: 1

#------------------------
# Debug
#------------------------

#echo "cpu1 = $cpu1"
#echo "cpu2 = $cpu2"
#echo "cpu3 = $cpu3"
#echo "cpu4 = $cpu4"
#echo "cpu5 = $cpu5"
#echo "cpu6 = $cpu6"
#echo "cpu7 = $cpu7"
#echo "cpu8 = $cpu8"
#echo "uptime = $uptime"

#echo "eth0in = $eth0in"
#echo "eth0out = $eth0out"

#------------------------
# PARSE CPU LOAD VALS
#------------------------

#response: iso.3.6.1.2.1.25.3.3.1.2.196608 = INTEGER: 18
IFS='INTEGER' read crap cl1  <<< "$cpu1"
IFS='INTEGER' read crap cl2  <<< "$cpu2"
IFS='INTEGER' read crap cl3  <<< "$cpu3"
IFS='INTEGER' read crap cl4  <<< "$cpu4"
IFS='INTEGER' read crap cl5  <<< "$cpu5"
IFS='INTEGER' read crap cl6  <<< "$cpu6"
IFS='INTEGER' read crap cl7  <<< "$cpu7"
IFS='INTEGER' read crap cl8  <<< "$cpu8"

IFS=' ' read crap cpu1  <<< "$cl1"
IFS=' ' read crap cpu2  <<< "$cl2"
IFS=' ' read crap cpu3  <<< "$cl3"
IFS=' ' read crap cpu4  <<< "$cl4"
IFS=' ' read crap cpu5  <<< "$cl5"
IFS=' ' read crap cpu6  <<< "$cl6"
IFS=' ' read crap cpu7  <<< "$cl7"
IFS=' ' read crap cpu8  <<< "$cl8"

#debug
#echo "$cpu1, $cpu2, $cpu3, $cpu4, $cpu5, $cpu6, $cpu7, $cpu8"

	curl -s -XPOST "http://10.0.0.116:8086/write?db=TITAN" --data-binary "system,metric=cpu1 value=$cpu1"
	curl -s -XPOST "http://10.0.0.116:8086/write?db=TITAN" --data-binary "system,metric=cpu2 value=$cpu2"
	curl -s -XPOST "http://10.0.0.116:8086/write?db=TITAN" --data-binary "system,metric=cpu3 value=$cpu3"
	curl -s -XPOST "http://10.0.0.116:8086/write?db=TITAN" --data-binary "system,metric=cpu4 value=$cpu4"
	curl -s -XPOST "http://10.0.0.116:8086/write?db=TITAN" --data-binary "system,metric=cpu5 value=$cpu5"
	curl -s -XPOST "http://10.0.0.116:8086/write?db=TITAN" --data-binary "system,metric=cpu6 value=$cpu6"
	curl -s -XPOST "http://10.0.0.116:8086/write?db=TITAN" --data-binary "system,metric=cpu7 value=$cpu7"
	curl -s -XPOST "http://10.0.0.116:8086/write?db=TITAN" --data-binary "system,metric=cpu8 value=$cpu8"

#------------------------
# PARSE UPTIME
#------------------------

#repsonse: iso.3.6.1.2.1.1.3.0 = Timeticks: (661096) 1:50:10.96

IFS=' ' read crap crap1 crap2 days <<< "$uptime"
IFS=',' read days time <<< "$days"
IFS=' ' read ticks days crap <<< "$days"

#debug
#echo "$days"

	curl -s -XPOST "http://10.0.0.116:8086/write?db=TITAN" --data-binary "system,metric=uptime value=$days"

#------------------------
# PARSE INTERFACE IO VALS & STATUS
#------------------------

#repsonse: iso.3.6.1.2.1.2.2.1.10.2 = Counter32: 3471811086

#eth0
IFS=' ' read crap crap1 eth0i  <<< "$eth0in"
IFS=' ' read crap eth0in  <<< "$eth0i"
IFS=' ' read crap crap1 eth0o  <<< "$eth0out"
IFS=' ' read crap eth0out  <<< "$eth0o"

#debug eth0
#echo "$eth0in"
#echo "$eth0out"

	#send eth0
	curl -s -XPOST "http://10.0.0.116:8086/write?db=TITAN" --data-binary "interface,metric=eth0in value=$eth0in"
	curl -s -XPOST "http://10.0.0.116:8086/write?db=TITAN" --data-binary "interface,metric=eth0out value=$eth0out"


done
