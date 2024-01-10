#! /usr/bin/bash

clear
# List All Database 
printAllDatabase(){
	DataBase=()
	echo "++=============================================++"
	echo -e "\e[31m||                Drop DataBase                ||\e[0m"	
	echo "++=============================================++"
	echo "++=============================================++"
	echo -e "\e[32m||     Press( 0 ) Exit From Drop Database      ||\e[0m"
	echo "++=============================================++"
	
	index=1
	if [ -d ./DataBase/ ]; then
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


Index_isValid='no'
while  [ $Index_isValid = 'no' ]
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
		
		if [ $DB_Name_Index -le ${#DataBase[@]} ];then # ${#DataBase[@]}-> length
		
			#Print Database Name You Want Drop
			echo "++========================================++"
			echo "You Select DataBase Name : " ${DataBase[$DB_Name_Index]}
			
			#Check if Database Empty Or Not
			# if database not Empty show msg to user are you suer
			if [ `ls ./DataBase/${DataBase[$DB_Name_Index]} | wc -l` -ge 1 ];then 
			
				while true;
				do
					read -p "Data Base Is Not Empty (Are You Sure Drop? Y|N ) >> "  isDropDB
					
					if [[ $isDropDB =~ ^[yY]$ ]];then
						rm -r ./DataBase/${DataBase[$DB_Name_Index]}
						
						clear
						echo "++=============================================++"
						echo -e "\e[32m||         Drop Database Successfully          ||\e[0m"
						echo "++=============================================++"
						break
						
					elif [[ $isDropDB =~ ^[nN]$ ]];then
						break
						
					else
						echo -e "\e[31mError : Please Enter Y For Yes | N For No ! \e[0m"
					fi
				done
				
			else
				clear
				rm -r ./DataBase/${DataBase[$DB_Name_Index]}
				echo "++=============================================++"
				echo -e "\e[32m||         Drop Database Successfully          ||\e[0m"
				echo "++=============================================++"
			fi			
					
			#Index_isValid='yes'
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

# Retuen The Main Page
./DB_Engine.sh
exit
