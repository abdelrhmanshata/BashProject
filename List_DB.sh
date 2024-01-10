#! /usr/bin/bash

# List All Database 
clear
echo "++=============================================++"
echo -e "\e[36m||             Listing All DataBase            ||\e[0m"	
echo "++=============================================++"

index=1
if [ -d ./DataBase/ ]; then	
	for DB_Name in `ls ./DataBase/`
	do
		if [ -d ./DataBase/$DB_Name ]; then
			echo "$index) $DB_Name"
			index=$((index+1))
		fi
	done
else
	echo "++=============================================++"
	echo -e "\e[31mError : DataBase Not Found \e[0m"	
	echo "++=============================================++"
fi
# Retuen The Main Page
./DB_Engine.sh
exit
