#! /usr/bin/bash

clear
# List All Tables 
printAllTables(){
	Tables=()
	echo "++=============================================++"
	echo -e "\e[31m||                 Drop Tables                 ||\e[0m"	
	echo "++=============================================++"
	echo "++=============================================++"
	echo -e "\e[32m||      Press( 0 ) Exit From Drop Table        ||\e[0m"
	echo "++=============================================++"
	
	index=1
		for DB_table in `ls`
		do
		if [ -f $D_table ]; then
			echo "$index ) $DB_table"
			Tables[$index]=$DB_table
			index=$((index+1))
			fi
		done
	
}

while true; 
do
	#use Function To Display All Tables
	printAllTables
	
	read -p "Please Enter Table_Index)>> "  Table_Name_Index
	
	if [[ $Table_Name_Index =~ ^[0-9]+$ ]];then
		
		if [ $Table_Name_Index -eq 0 ];then
			clear
			../../Connect_DB.sh
			exit
		fi
		
		if [ $Table_Name_Index -le ${#Tables[@]} ];then # ${#Tables[@]}-> length          (-le) used because   table index start with 1  
		
			#Print Tables Name You Want Drop
			echo "++=================================================++"
			echo "You Select Table Name : " ${Tables[$Table_Name_Index]}
			
			#Check if Table Empty Or Not
			# if Table not Empty show msg to user are you user
			if [ `cat ${Tables[$Table_Name_Index]} | wc -l` -gt 2 ];then 
			
				while true;
				do
					read -p "Table Is Not Empty (Are You Sure Drop? Y|N ) >> "  isDropTable
					
					if [[ $isDropTable =~ ^[yY]$ ]];then
						rm ${Tables[$Table_Name_Index]}
						
						clear
						echo "++=============================================++"
						echo -e "\e[32m||          Drop Table Successfully            ||\e[0m"
						echo "++=============================================++"
						break
						
					elif [[ $isDropTable =~ ^[nN]$ ]];then
						break
						
					else
						echo -e "\e[31mError : Please Enter Y For Yes | N For No ! \e[0m"
					fi
				done
				
			else
				clear
				rm ${Tables[$Table_Name_Index]}
				echo "++=============================================++"
				echo -e "\e[32m||           Drop Table Successfully           ||\e[0m"
				echo "++=============================================++"
			fi			
					
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

# Return The Main Page
../../Connect_DB.sh
exit
