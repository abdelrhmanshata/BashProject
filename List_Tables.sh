#!/bin/bash

# List All tables 
clear
echo "++=============================================++"
echo -e "\e[36m||               Listing All Tables            ||\e[0m"	
echo "++=============================================++"

index=1

	for table_item in `ls`
	do
		if [ -f $table_item ]; then
			echo "$index) $table_item"
			index=$((index+1))
		fi
	done

# Return The Main Page
../../Connect_DB.sh
exit
