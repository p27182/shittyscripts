#!/bin/bash

echo 'Querying md output...'
echo 'Press Ctrl-C to exit'


while sleep 10
do

#Dump hddtemp output into var
md126=$(sudo mdadm --detail /dev/md126)
md127=$(sudo mdadm --detail /dev/md127)

#Parse md126
IFS=':' read v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20<<< $md126
IFS=' ' read active1 d1 d2 <<< $v18
IFS=' ' read working1 d1 d2 <<< $v19
IFS=' ' read failed1 d1 d2 <<< $v20

#echo "Active = $active1"
#echo "Workin = $working1"
#echo "Failed = $failed1"

curl -s XPOST 'http://10.0.0.116:8086/write?db=ananke' --data-binary "Zeus,name=active value=$active1"
curl -s XPOST 'http://10.0.0.116:8086/write?db=ananke' --data-binary "Zeus,name=working value=$working1"
curl -s XPOST 'http://10.0.0.116:8086/write?db=ananke' --data-binary "Zeus,name=failed value=$failed1"

#Parse md127
IFS=':' read v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20<<< $md127
IFS=' ' read active2 d1 d2 <<< $v18
IFS=' ' read working2 d1 d2 <<< $v19
IFS=' ' read failed2 d1 d2 <<< $v20

#echo "Active = $active2"
#echo "Workin = $working2"
#echo "Failed = $failed2"

curl -s XPOST 'http://10.0.0.116:8086/write?db=ananke' --data-binary "Locum,name=active value=$active2"
curl -s XPOST 'http://10.0.0.116:8086/write?db=ananke' --data-binary "Locum,name=working value=$working2"
curl -s XPOST 'http://10.0.0.116:8086/write?db=ananke' --data-binary "Locum,name=failed value=$failed2"

d1=$(date +%F)

curl -s XPOST 'http://10.0.0.116:8086/write?db=ananke' --data-binary "mdmon,name=time value=$d1"

done
