#! /usr/bin/bash

clear

Table_NameIsFound(){
isfound=0;
for item in `ls`
	do
		if [ -f $item ]; then
			nameTable=$(echo "$item" | tr '[:lower:]' '[:upper:]')
			input=$(echo $1 | tr '[:lower:]' '[:upper:]')
			if [ $nameTable = $input ]; then
				isfound=1;
				break;
			else
				isfound=0;
			fi
		fi
	done
return $isfound	
}

isValid='no'
while  [ $isValid = 'no' ]
do
	echo "++=============================================++"
	echo -e "\e[36m||    Instructions for Naming the Tables       ||\e[0m"	
	echo "++=============================================++"
	echo "|| Table_Name Must Start By Char Not aNumber   ||"
	echo "|| Table_Name Must Not Contain Special Chars   ||"
	echo "++=============================================++"
	echo -e "\e[32m||      Press( 0 ) Exit From Create Table      ||\e[0m"
	echo "++=============================================++"


	read -p "(Please Enter Table_Name )>> "  T_Name
	
	# Exit Create Table
	if [ $T_Name = "0" ];then
		clear
		../../Connect_DB.sh
		exit
	fi
	
	T_Name=`echo $T_Name | tr ' ' '_'` # Replace All Space to _

	#check T_Name Not Contain Special Characters and Start By Char Not Number 
	if [[ $T_Name =~ ^[A-Za-z][A-Za-z0-9_]*$ ]];then
		
		# Check if Table exists Or Not
		#run Function
		Table_NameIsFound $T_Name
		
		if [ $? -eq 0 ]; then #if Not Exists
			
			while true;
			do
				echo "Table Name : "$T_Name
				read -p "(Please Enter Num Of Filed )>> "  t_NumField
						
					filedsName=();
					filedsType=();
						
					if [[ $t_NumField =~ ^[0-9]+$ ]];then
						for((i=0;i < $t_NumField; i++)) 
						do 
							while true;
							do	
							
								echo "=================================================="
								if [ $i -eq 0 ];then
									echo "This Filed Is PK"
								fi
								read -p "Enter Name Of field $((i+1)) : " filedsName[$i]
								if [[ ${filedsName[$i]} =~ ^[A-Za-z][A-Za-z0-9_]*$ ]];then						
									while true;
									do	
										echo "=================================================="
										echo "Please enter the field type (int) or (str)"
										read -p "Enter type Of field $((i+1)) : " filedsType[$i]
										if [[ ${filedsType[$i]} =~ ^int$ ]] ;then
											# exit while
											break	
										elif 	[[ ${filedsType[$i]} =~ ^str$ ]];then
											# exit while
											break		
										else
											echo -e "\e[31mError Please enter the field type (int) or (str) \e[0m"
										fi
									done
									
									# exit while
									break
											
								else
									echo -e "\e[31mError Please enter the field name in correct format \e[0m"
								fi
							done
						done
							
						# exit while
						break	
					else
						echo "++=============================================++"
						echo -e "\e[31mError : Num Of Fileds must be a Number\e[0m"
						echo "++=============================================++"
					fi
			done
		
			# Create Table if not exist 
			touch $T_Name 
			
			# Create Metadata in same file
			line1=''
			for((i=0;i < ${#filedsName[@]}; i++)) 
			do 
				line1=$line1${filedsName[i]}
				if [ $i -lt $(( ${#filedsName[@]}-1 )) ]; then
				 line1=$line1:
				fi
			done
			echo $line1 >> $T_Name
			
			line2=''
			for((j=0;j < ${#filedsType[@]}; j++)) 
			do 
				line2=$line2${filedsType[j]}
				if [ $j -lt $(( ${#filedsType[@]}-1 )) ]; then
				 line2=$line2:
				fi
			done
			echo $line2 >> $T_Name
		
						
			clear
			echo "++=============================================++"
			echo -e "\e[32mCreated successfully\e[0m"
			echo -e "\e[32mTable Created: ./DataBase/$database_Name/$T_Name\e[0m"
			echo "++=============================================++"

			isValid='yes'
		
		else
			clear
			echo "++=============================================++"
			echo -e "\e[31mError : Table Already Exists\e[0m"
			echo "++=============================================++"
		fi	
			
	else
		clear
		echo "++=============================================++"
		echo -e "\e[31mError : Table Name Is Not Valid\e[0m"	
		echo "++=============================================++"
	fi
done	
# Retuen The Main Page
../../Connect_DB.sh
exit
