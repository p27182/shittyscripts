#!/bin/bash
# This script checks the health of disks

echo 'Looping C5 Error Check'
echo 'Press Ctrl+C to Stop...'

# Disks to check
disks="/dev/sda
/dev/sdb
/dev/sdc
/dev/sdd
/dev/sde
/dev/sdf
/dev/sdg
/dev/sdh
"

#run 2x a day
while sleep 42300 
do
	# Checking disk
	for disk in $disks
	do
		status=$(smartctl -a $disk | grep Reallocated_Sector_Ct)
  		#Checking that we do not have any Reallocated Sectors
		IFS=' ' read v1 v2 v3 v4 v5 v6 v7 v8 v9 count<<< $status

	if [ $count -gt 0 ]
	then
		error="Disk $disk has C5 errors: $count"
#		echo $error
		mail -s "ananke Disk $disk C5 SMART Errors!" p27182@gmail.com <<< "$error"
	fi

	done

done
