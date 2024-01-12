#!/bin/bash

clear
# List All Tables 
printAllTables(){
	Tables=()
	echo "++=============================================++"
	echo -e "\e[36m||           Delete From Table                 ||\e[0m"	
	echo "++=============================================++"
	echo "++=============================================++"
	echo -e "\e[32m||   Press( 0 ) Exit From Delete From Table    ||\e[0m"
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

####################################################################################################
####################################################################################################
#Delete All Data Function => Used in Main
deleteAllData(){
	#Check if Table Empty Or Not
	if [ `cat ${Tables[$Table_Name_Index]} | wc -l` -gt 2 ];then 
		
		# if Table not Empty show msg to user are you user
		read -p "Table Is Not Empty (Are You Sure Delete All Data? Y|N ) >> "  isDeleteAll
		
		if [[ $isDeleteAll =~ ^[yY]$ ]];then
		
			line1=`sed -n '1P' ${Tables[$Table_Name_Index]}`
			line2=`sed -n '2P' ${Tables[$Table_Name_Index]}`
			echo $line1 > ${Tables[$Table_Name_Index]}
			echo $line2 >> ${Tables[$Table_Name_Index]}
			
			clear
			echo "++=============================================++"
			echo -e "\e[32m||       All Data Deleted Successfully         ||\e[0m"
			echo "++=============================================++"
			../../Connect_DB.sh
			exit
			
		elif [[ $isDeleteAll =~ ^[nN]$ ]];then
			../../Connect_DB.sh
			exit
			
		else
			echo -e "\e[31mError : Please Enter Y For Yes | N For No ! \e[0m"
			deleteAllData
		fi
	else
		clear
		echo "++=============================================++"
		echo -e "\e[31m||              This Table Is Empty            ||\e[0m"
		echo "++=============================================++"
		../../Connect_DB.sh
		exit
	fi	
}

####################################################################################################
####################################################################################################
#check if is is found
idIsFound(){
	table=$1
	id=$2
	result=$(cut -f1 -d: $table | grep -w $id | wc -l)
	return $result
}
##############################
deleteRowFromTable(){
	idIsFound ${Tables[$Table_Name_Index]} $userinput
	if [ $? -eq 1 ];then
		# delete data by id
		awk -v uID="$userinput" -F: '{ 
			if ($1 != uID){ 
				print $0;
			}
		}' ${Tables[$Table_Name_Index]} > temp && mv temp ${Tables[$Table_Name_Index]}
		
		clear
		echo "++=============================================++"
		echo -e "\e[32m||    Selected Data Deleted Successfully       ||\e[0m"
		echo "++=============================================++"
		../../Connect_DB.sh
		exit
	else
		echo -e "\e[31mError : This ${pkName} is not found\e[0m"	
		echo "=================================================="
		../../Connect_DB.sh
		exit
	fi
}
#########################################################
#Delete By PK Function => Used in Main
deleteByPK(){

	pkName=`cut -f1 -d: ${Tables[$Table_Name_Index]} | head -1`
	pkType=`cut -f1 -d: ${Tables[$Table_Name_Index]} | head -2 | tail -1 `

	echo "=================================================="
	echo -e "\e[36mThis Filed Is PK must be unique\e[0m"	
	read -p "Enter ${pkName} (PK) field DataType(${pkType}) : " userinput
	
	# if datatype of field is int 
	if [[ ${pkType} =~ ^int$ ]];then
		if [[ $userinput =~ ^[0-9]+$ ]];then	

			# delete row from table		
			deleteRowFromTable
				
		else
			echo -e "\e[31mError : DataType Must be Integer\e[0m"	
			deleteByPK		
		fi
		
	elif [[ ${pkType} =~ ^str$ ]];then
		if [[ $userinput =~ ^[a-zA-Z0-9_]+$ ]];then 
		
			# delete row from table		
			deleteRowFromTable
			
		else
			echo -e "\e[31mError : DataType Must be String\e[0m"
			deleteByPK			
		fi		
	fi	
}
####################################################################################################
####################################################################################################
#check if column is found
columnIsFound(){
	table=$1
	column=$2
	result=$(sed -n '1p' $table | grep -w "$column" | wc -l)
	return $result
}
#########################################################

#Delete By Column Function => Used in Main
deleteByColumn(){
	read -p "Enter Column Name : " columnName
	columnIsFound ${Tables[$Table_Name_Index]} $columnName
	if [ $? -eq 1 ];then
		read -p "Enter Entry Value : " entryValue
		awk -F: -v col="$columnName" -v val="$entryValue"   '
			BEGIN{ col_Num=0 }
			{ 
				if(NR==1){
					print $0;
					for(i=1;i<=NF;i++)
					{
						if($i==col){
							col_Num=i
						}
					}
				}else if (NR==2){
					print $0;
				}else{
					if ($col_Num != val){ 
						print $0;
					}
				}	
			}' ${Tables[$Table_Name_Index]} > temp && mv temp ${Tables[$Table_Name_Index]}
		clear
		echo "++=============================================++"
		echo -e "\e[32m||    Selected Data Deleted Successfully       ||\e[0m"
		echo "++=============================================++"
		../../Connect_DB.sh
		exit
	else
		echo -e "\e[31mError : This Column Name is not found\e[0m"
		echo "=================================================="	
		deleteByColumn
	fi
}

####################################################################################################
####################################################################################################
####################################################################################################
# Main Function 
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
		
		if [ $Table_Name_Index -le ${#Tables[@]} ];then 
		
			#Print Tables Name You Want insert into
			echo "++=============================================++"
			echo "You Select Table Name : " ${Tables[$Table_Name_Index]}
			
			# if table not Empty
			if [ `cat ${Tables[$Table_Name_Index]} | wc -l` -gt 2 ];then 
				select choice in "Delete All Data" "Delete by PK" "Delete by Column" "Exit"
					do     
						case $choice in 
							"Delete All Data" )
						    		#DeleteAllData Function
						    		deleteAllData
							;;
							"Delete by PK" )
						    		#Delete By PK Function
						    		deleteByPK
							;;
							"Delete by Column" )
								#Delete By Column Function
						    		deleteByColumn
							;;					
							"Exit" )
						    		echo -e "\e[31mExit Delete From Table \e[0m"
						    		../../Connect_DB.sh
						    		exit
							;;
							* )
						    		echo -e "\e[31mError..Input (Please Select Right Input)\e[0m"
							;;
					    	esac
					done 		
			else
				clear
				echo "++=============================================++"
				echo -e "\e[31m||              This Table Is Empty            ||\e[0m"
				echo "++=============================================++"
				../../Connect_DB.sh
				exit
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

# back main page
../../Connect_DB.sh
exit
