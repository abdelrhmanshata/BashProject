#! /usr/bin/bash

clear

# List All Database 
printAllDatabase(){
	DataBase=()
	echo "++=============================================++"
	echo -e "\e[36m||          Select DataBase To Connect         ||\e[0m"	
	echo "++=============================================++"
	echo "++=============================================++"
	echo -e "\e[32m||    Press( 0 ) Exit From Connect Database    ||\e[0m"
	echo "++=============================================++"
	
	if [ -d ./DataBase/ ]; then
		index=1
		for DB_Name in `ls ./DataBase/`
		do
		if [ -d ./DataBase/$DB_Name ]; then
			echo "$index ) $DB_Name"
			DataBase[$index]=$DB_Name
			index=$((index+1))
			fi
		done
	else
		echo "++=============================================++"
		echo -e "\e[31mError : DataBase Not Found \e[0m"	
		echo "++=============================================++"
	fi
}

while true;
do
	#use Function To Display All Database
	printAllDatabase
	read -p "Please Enter DB_Index )>> "  DB_Name_Index
	
	if [[ $DB_Name_Index =~ ^[0-9]+$ ]];then
		
		if [ $DB_Name_Index -eq 0 ];then
			clear
			./DB_Engine.sh
			exit
		fi
		
		if [ $DB_Name_Index -lt $index ];then
		 
			export database_Name=${DataBase[$DB_Name_Index]}	
			cd ./DataBase/$database_Name
			../../Connect_DB.sh
			exit		
		else
			clear
			echo "++=============================================++"
			echo -e "\e[31mError : Index Not Found Please Select Valid Index\e[0m"	
			echo "++=============================================++"
		fi
	
	else
		clear
		echo "++=============================================++"
		echo -e "\e[31mError :       Input Must be a number\e[0m"	
		echo "++=============================================++"
	fi
done

