#!/bin/bash

echo 'Querying share use output...'
echo 'Press Ctrl-C to exit'

#query use every hour
while sleep 3600

do

#Dump hddtemp output into var
md126=$(df /dev/md126)
md127=$(df /dev/md127)

#parse percentages
IFS=' ' read v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 percent126 v13 <<< $md126
IFS=' ' read v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 percent127 v13 <<< $md127

#verify percent echo $v12

IFS='%' read val126 sign <<< $percent126
IFS='%' read val127 sign <<< $percent127

#echo $val126
#echo $val127

curl -s XPOST 'http://10.0.0.116:8086/write?db=ananke' --data-binary "Zeus,name=pused value=$val126"
curl -s XPOST 'http://10.0.0.116:8086/write?db=ananke' --data-binary "Locum,name=pused value=$val127"

done
