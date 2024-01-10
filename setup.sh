#! /usr/bin/bash

for item in `ls`
do 
	if [ -f $item ]; then 
		if [ ! -x $item ]; then 
			chmod +x $item
		fi
	fi	
done
echo "Done"
