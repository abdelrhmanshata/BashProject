#!/bin/bash

clear
# List All Tables 
printAllTables(){
	Tables=()
	echo "++=============================================++"
	echo -e "\e[36m||          Insert Into Tables                ||\e[0m"	
	echo "++=============================================++"
	echo "++=============================================++"
	echo -e "\e[32m||     Press( 0 ) Exit From Insert Table      ||\e[0m"
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

idIsFound(){
	table=$1
	id=$2
	result=$(cut -f1 -d: $table | grep -w $id | wc -l)
	return $result
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
		
			#Print Tables Name You Want insert into
			echo "++=================================================++"
			echo "You Select Table Name : " ${Tables[$Table_Name_Index]}
				
			fieldsName=();
			fieldsType=();
			
			index=0;
			for item in `sed -n '1P' ${Tables[$Table_Name_Index]} | tr ':' ' '`
			do
				fieldsName[index]=$item;
				index=$((index+1));
			done
			
			index=0;
			for item in `sed -n '2P' ${Tables[$Table_Name_Index]} | tr ':' ' '`
			do
				fieldsType[index]=$item;
				index=$((index+1));
			done

			fieldsValue=();
			for((i=0;i < ${#fieldsName[@]}; i++)) 
			do 
				while true;
				do	
					echo "=================================================="
					if [ $i -eq 0 ];then
						echo -e "\e[36mThis Filed Is PK must be unique\e[0m"	
					fi
					
					read -p "Enter ${fieldsName[$i]} field DataType(${fieldsType[$i]}) : " userinput
					
					# if datatype of field is int 
					if [[ ${fieldsType[$i]} =~ ^int$ ]];then
						
						if [[ $userinput =~ ^[0-9]+$ ]];then
							if [ $i -eq 0 ];then
								idIsFound ${Tables[$Table_Name_Index]} $userinput
								if [ $? -eq 0 ];then
									# insert data
									fieldsValue[$i]=$userinput
									break
								else
									echo -e "\e[31mError : This ${fieldsName[$i]} is found\e[0m"	
								fi
							else
									# insert data
									fieldsValue[$i]=$userinput
									break	
							fi
						else
							echo -e "\e[31mError : DataType Must be Integer\e[0m"			
						fi
						
					elif [[ ${fieldsType[$i]} =~ ^str$ ]];then
						
						if [[ $userinput =~ ^[a-zA-Z][a-zA-Z0-9_]+$ ]];then 
							if [ $i -eq 0 ];then
								idIsFound ${Tables[$Table_Name_Index]} $userinput
								if [ $? -eq 0 ];then
									# insert data
									fieldsValue[$i]=$userinput
									break
								else
									echo -e "\e[31mError : This ${fieldsName[$i]} is found\e[0m"			
								fi
							else
									# insert data
									fieldsValue[$i]=$userinput
									break	
							fi
						else
							echo -e "\e[31mError : DataType Must be start String\e[0m"			
						fi		
					fi
				done
			done

			line=''
			for((i=0;i < ${#fieldsValue[@]}; i++)) 
			do 
				line=$line${fieldsValue[i]}
				if [ $i -lt $(( ${#fieldsValue[@]}-1 )) ]; then
				 line=$line:
				fi
			done
			echo $line >> ${Tables[$Table_Name_Index]}
			echo "Row Inserted Successfully"	
			
			clear
			echo "++=============================================++"
			echo -e "\e[32mRow Inserted Successfully\e[0m"
			echo "++=============================================++"
			
			# Return The Main Page
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

# Return The Main Page
../../Connect_DB.sh
exit
