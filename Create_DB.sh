#! /usr/bin/bash


DB_NameIsFound(){
isfound=0;
for item in `ls ./DataBase/`
	do
		nameDB=$(echo "$item" | tr '[:lower:]' '[:upper:]')
		input=$(echo $1 | tr '[:lower:]' '[:upper:]')
		if [ $nameDB = $input ]; then
			isfound=1;
			break;
		else
			isfound=0;
		fi
	done
return $isfound	
}


clear
isValid='no'

while  [ $isValid = 'no' ]
do
	echo "++=============================================++"
	echo -e "\e[36m||    Instructions for Naming the DataBase     ||\e[0m"	
	echo "++=============================================++"
	echo "|| DB_Name Must Start By Char Not aNumber      ||"
	echo "|| DB_Name Must Not Contain Special Characters ||"
	echo "++=============================================++"
	echo -e "\e[32m||    Press( 0 ) Exit From Create Database     ||\e[0m"
	echo "++=============================================++"
	
	read -p "(Please Enter DB_Name )>> "  DB_Name
	
	# Exit Database
	if [ $DB_Name = "0" ];then
		clear
		./DB_Engine.sh
		exit
	fi
	
	DB_Name=`echo $DB_Name | tr ' ' '_'` # Replace All Space to _

	#check DB_Name Not Contain Special Characters and Start By Char Not Number 
	if [[ $DB_Name =~ ^[A-Za-z][A-Za-z0-9_]*$ ]];then
		
		# Check if DB exists Or Not
		#run Function
		DB_NameIsFound $DB_Name
		
		if [ $? -eq 0 ]; then #if Not Exists
    			# Create Database if not exist 
    			mkdir -p ./DataBase/$DB_Name
			
			clear
			echo "++=============================================++"
			echo -e "\e[32mCreated successfully\e[0m"
    			echo -e "\e[32mData Base Created: ./DataBase/$DB_Name\e[0m"
			echo "++=============================================++"

			isValid='yes'
		else
			clear
			echo "++=============================================++"
			echo -e "\e[31mError : Data Base Already Exists\e[0m"
			echo "++=============================================++"
		fi	
			
	else
		clear
		echo "++=============================================++"
		echo -e "\e[31mError : Data Base DataBase Name Is Not Valid\e[0m"	
		echo "++=============================================++"
	fi
done	

# Retuen The Main Page
./DB_Engine.sh
exit
