#!/bin/bash

echo "Press Ctl+C to Stop..."

while sleep 1

do

#------------------------
# SNMP QUERIES -> Variables
#------------------------

cpu1=$(snmpget -v2c -c mycommunity 10.0.0.1 .1.3.6.1.2.1.25.3.3.1.2.196608)
cpu2=$(snmpget -v2c -c mycommunity 10.0.0.1 .1.3.6.1.2.1.25.3.3.1.2.196609)
#response: iso.3.6.1.2.1.25.3.3.1.2.196608 = INTEGER: 18

uptime=$(snmpget -v2c -c mycommunity 10.0.0.1 .1.3.6.1.2.1.1.3.0)
#repsonse: iso.3.6.1.2.1.1.3.0 = Timeticks: (661096) 1:50:10.96

eth0in=$(snmpget -v2c -c mycommunity 10.0.0.1 .1.3.6.1.2.1.2.2.1.10.2)
eth0out=$(snmpget -v2c -c mycommunity 10.0.0.1 .1.3.6.1.2.1.2.2.1.16.2)
#repsonse: iso.3.6.1.2.1.2.2.1.10.2 = Counter32: 3471811086
eth0status=$(snmpget -v2c -c mycommunity 10.0.0.1 .1.3.6.1.2.1.2.2.1.8.2)
#response: iso.3.6.1.2.1.2.2.1.8.2 = INTEGER: 1

eth1in=$(snmpget -v2c -c mycommunity 10.0.0.1 .1.3.6.1.2.1.2.2.1.10.3)
eth1out=$(snmpget -v2c -c mycommunity 10.0.0.1 .1.3.6.1.2.1.2.2.1.16.3)
#repsonse: iso.3.6.1.2.1.2.2.1.10.2 = Counter32: 3471811086
eth1status=$(snmpget -v2c -c mycommunity 10.0.0.1 .1.3.6.1.2.1.2.2.1.8.3)
#response: iso.3.6.1.2.1.2.2.1.8.2 = INTEGER: 1

eth2in=$(snmpget -v2c -c mycommunity 10.0.0.1 .1.3.6.1.2.1.2.2.1.10.4)
eth2out=$(snmpget -v2c -c mycommunity 10.0.0.1 .1.3.6.1.2.1.2.2.1.16.4)
#repsonse: iso.3.6.1.2.1.2.2.1.10.2 = Counter32: 3471811086
eth2status=$(snmpget -v2c -c mycommunity 10.0.0.1 .1.3.6.1.2.1.2.2.1.8.4)
#response: iso.3.6.1.2.1.2.2.1.8.2 = INTEGER: 2 (1=up 2=down)

#------------------------
# Debug
#------------------------

#echo "cpu1 = $cpu1"
#echo "cpu2 = $cpu2"
#echo "uptime = $uptime"

#echo "eth0in = $eth0in"
#echo "eth0out = $eth0out"
#echo "eth0status = $eth0status"

#echo "eth1in = $eth1in"
#echo "eth1out = $eth1out"
#echo "eth1status = $eth1status"

#echo "eth2in = $eth2in"
#echo "eth2out = $eth2out"
#echo "eth2status = $eth2status"

#------------------------
# PARSE CPU LOAD VALS
#------------------------

#response: iso.3.6.1.2.1.25.3.3.1.2.196608 = INTEGER: 18
IFS='INTEGER' read crap cl1  <<< "$cpu1"
IFS='INTEGER' read crap cl2  <<< "$cpu2"
IFS=' ' read crap cpu1  <<< "$cl1"
IFS=' ' read crap cpu2  <<< "$cl2"

#debug
#echo "$cpu1, and $cpu2"

	curl -s -XPOST "http://10.0.0.116:8086/write?db=ERL" --data-binary "system,metric=cpu1 value=$cpu1"
	curl -s -XPOST "http://10.0.0.116:8086/write?db=ERL" --data-binary "system,metric=cpu2 value=$cpu2"

#------------------------
# PARSE UPTIME
#------------------------

#repsonse: iso.3.6.1.2.1.1.3.0 = Timeticks: (661096) 1:50:10.96

IFS=' ' read crap crap1 crap2 days <<< "$uptime"
IFS=',' read days time <<< "$days"
IFS=' ' read ticks days crap <<< "$days"

#debug
#echo "$days"

	curl -s -XPOST "http://10.0.0.116:8086/write?db=ERL" --data-binary "system,metric=uptime value=$days"

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

#eth1
IFS=' ' read crap crap1 eth1i  <<< "$eth1in"
IFS=' ' read crap eth1in  <<< "$eth1i"
IFS=' ' read crap crap1 eth1o  <<< "$eth1out"
IFS=' ' read crap eth1out  <<< "$eth1o"

#debug eth1
#echo "$eth1in"
#echo "$eth1out"

#eth2
IFS=' ' read crap crap1 eth2i  <<< "$eth2in"
IFS=' ' read crap eth2in  <<< "$eth2i"
IFS=' ' read crap crap1 eth2o  <<< "$eth2out"
IFS=' ' read crap eth2out  <<< "$eth2o"

#debug eth2
#echo "$eth2in"
#echo "$eth2out"

#response: iso.3.6.1.2.1.2.2.1.8.2 = INTEGER: 2 (1=up 2=down)
IFS=' ' read crap c1 c2 eth0s  <<< "$eth0status"
IFS=' ' read crap c1 c2 eth1s  <<< "$eth1status"
IFS=' ' read crap c1 c2 eth2s  <<< "$eth2status"

#debug status
#echo "$eth0s"
#echo "$eth1s"
#echo "$eth2s"

	#send eth0
	curl -s -XPOST "http://10.0.0.116:8086/write?db=ERL" --data-binary "interface,metric=eth0in value=$eth0in"
	curl -s -XPOST "http://10.0.0.116:8086/write?db=ERL" --data-binary "interface,metric=eth0out value=$eth0out"
	curl -s -XPOST "http://10.0.0.116:8086/write?db=ERL" --data-binary "interface,metric=eth0status value=$eth0s"
	#send eth1
	curl -s -XPOST "http://10.0.0.116:8086/write?db=ERL" --data-binary "interface,metric=eth1in value=$eth1in"
	curl -s -XPOST "http://10.0.0.116:8086/write?db=ERL" --data-binary "interface,metric=eth1out value=$eth1out"
	curl -s -XPOST "http://10.0.0.116:8086/write?db=ERL" --data-binary "interface,metric=eth1status value=$eth1s"
	#send eth2
	curl -s -XPOST "http://10.0.0.116:8086/write?db=ERL" --data-binary "interface,metric=eth2in value=$eth2in"
	curl -s -XPOST "http://10.0.0.116:8086/write?db=ERL" --data-binary "interface,metric=eth2out value=$eth2out"
	curl -s -XPOST "http://10.0.0.116:8086/write?db=ERL" --data-binary "interface,metric=eth2status value=$eth2s"

done
