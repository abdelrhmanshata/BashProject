#!/bin/bash
clear
# List All Tables 
printAllTables(){
	Tables=()
	echo "++=============================================++"
	echo -e "\e[36m||            Update From Table                ||\e[0m"	
	echo "++=============================================++"
	echo "++=============================================++"
	echo -e "\e[32m||      Press( 0 ) Exit From Insert Table      ||\e[0m"
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

# Search ID IS Found 1 Or Not 0
idIsFound(){
	table=$1
	id=$2
	result=$(cut -f1 -d: $table | grep -w $id | wc -l)
	return $result
}

####################################################################################################
# Update Row Data IN Table
####################################################################################################

updateRowByID(){
	pkInput=$1
	fieldsValue=();
	# this id value
	fieldsValue[0]=$pkInput
	for((i=1;i < ${#fieldsName[@]}; i++)) 
	do 
		while true;
		do	
			echo "=================================================="
			read -p "Enter ${fieldsName[$i]} field DataType(${fieldsType[$i]}) : " userinput
			
			# if datatype of field is int 
			if [[ ${fieldsType[$i]} =~ ^int$ ]];then
				
				if [[ $userinput =~ ^[0-9]+$ ]];then
					# add data in fieldsValue
					fieldsValue[$i]=$userinput
					break	
				else
					echo -e "\e[31mError : DataType Must be Integer\e[0m"			
				fi
				
			elif [[ ${fieldsType[$i]} =~ ^str$ ]];then
				
				if [[ $userinput =~ ^[a-zA-Z][a-zA-Z0-9_]+$ ]];then 
					# add data in fieldsValue
					fieldsValue[$i]=$userinput
					break	
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
			
	# Update Row By ID Using awk
	awk -F: -v uID="$pkInput" -v newValue="$line" '{ 
		if(NR >2){			
			if ($1 == uID){ 
				$0=newValue
			}					
		}
		print $0
	}' ${Tables[$Table_Name_Index]} > temp && mv temp ${Tables[$Table_Name_Index]}
	 
	clear
	echo "++=============================================++"
	echo -e "\e[32m||         Updated Data Successfully           ||\e[0m"
	echo "++=============================================++"
	../../Connect_DB.sh
	exit

}

####################################################################################################
# Update Rowdata By id  => Used in Main
UpdateByID(){

	fieldsName=();
	fieldsType=();

	# get All name of columns			
	index=0;
	for item in `sed -n '1P' ${Tables[$Table_Name_Index]} | tr ':' ' '`
	do
		fieldsName[index]=$item;
		index=$((index+1));
	done

	# get All datatype of columns		
	index=0;
	for item in `sed -n '2P' ${Tables[$Table_Name_Index]} | tr ':' ' '`
	do
		fieldsType[index]=$item;
		index=$((index+1));
	done

	while true;
	do	
		echo "=================================================="
		echo -e "\e[36mThis Filed Is PK must be unique\e[0m"	
		read -p "Enter ${fieldsName[0]} (PK) field DataType(${fieldsType[0]}) : " pkInput
		
		# if datatype of field is int 
		if [[ ${fieldsType[0]} =~ ^int$ ]];then
			if [[ $pkInput =~ ^[0-9]+$ ]];then
				#check id is found
				idIsFound ${Tables[$Table_Name_Index]} $pkInput
				if [ $? -eq 1 ];then
					updateRowByID $pkInput
				else
					echo -e "\e[31mError : This ${fieldsName[0]} is not found\e[0m"	
					echo "=================================================="
					break
				fi
				
			else
				echo -e "\e[31mError : DataType Must be Integer\e[0m"			
			fi
			
		elif [[ ${fieldsType[0]} =~ ^str$ ]];then
			if [[ $pkInput =~ ^[a-zA-Z][a-zA-Z0-9_]+$ ]];then 
				#check id is found
				idIsFound ${Tables[$Table_Name_Index]} $pkInput
				if [ $? -eq 1 ];then
					updateRowByID $pkInput
				else
					echo -e "\e[31mError : This ${fieldsName[0]} is not found\e[0m"	
					echo "=================================================="
					break
				fi
			else
				echo -e "\e[31mError : DataType Must be start String\e[0m"			
			fi		
		fi
	done	

}


#######################################################################################################################################
#Update Functions By Column
#######################################################################################################################################
#check if column found 1 or not 0
columnIsFound(){
	table=$1
	column=$2
	result=$(sed -n '1p' $table | grep -w "$column" | wc -l)
	return $result
}
##############################
#check column index is found
getColumnIndex(){
	table=$1
	columnName=$2
	index=1;
	for item in `sed -n '1P' $table | tr ':' ' '`
	do
		if [ $columnName = $item ];then
			return $index
		else
			index=$((index+1));
		fi
	done
}
##############################
# write newData in Tabel
writeDataIntoTabel(){
	table=$1
	pkValue=$2
	colIndexValue=$3
	newValue=$4
	awk -v pk="$pkValue" -v colIndex="$colIndexValue" -v val="$newValue" '
	BEGIN{FS=OFS=":"}
		{ 
			if(NR>2){
				if($1==pk)	{
					$colIndex=val
				}
			}
			print $0	
		} ' $table>temp && mv temp $table 
}
#########################################################
entryNewValue(){
	read -p "Enter Entry Value : " entryValue
	if [[ $getColumnDataType =~ ^int$ ]];then
		if [[ $entryValue =~ ^[0-9]+$ ]];then
			
			#Update Data in Table
			writeDataIntoTabel ${Tables[$Table_Name_Index]} $pkInput $colIndex $entryValue
				
			clear
			echo "++=============================================++"
			echo -e "\e[32m||         Updated Data Successfully           ||\e[0m"
			echo "++=============================================++"
			../../Connect_DB.sh
			exit
			
		else
			echo -e "\e[31mError : DataType Must be Integer\e[0m"	
			getNewValue		
		fi
	elif [[ $getColumnDataType =~ ^str$ ]];then
		if [[ $entryValue =~ ^[a-zA-Z][a-zA-Z0-9_]+$ ]];then
		
			#Update Data in Table
			writeDataIntoTabel ${Tables[$Table_Name_Index]} $pkInput $colIndex $entryValue
				
			clear
			echo "++=============================================++"
			echo -e "\e[32m||         Updated Data Successfully           ||\e[0m"
			echo "++=============================================++"
			../../Connect_DB.sh
			exit
		else
			echo -e "\e[31mError : DataType Must be start String\e[0m"
			entryNewValue	
		fi
	fi
}
#########################################################
entryColumnName(){
	read -p "Enter Column Name : " columnName
	if [ $getPKName != $columnName ];then
		#check if column found 1 or not 0
		columnIsFound ${Tables[$Table_Name_Index]} $columnName
		if [ $? -eq 1 ];then
			getColumnIndex ${Tables[$Table_Name_Index]} $columnName
			colIndex=$?
			getColumnDataType=$(cut -f$colIndex -d: ${Tables[$Table_Name_Index]} | head -2 | tail -1)
				#while true;
				#do
					entryNewValue
				#done

		else
			echo -e "\e[31mError : This $columnName is not found\e[0m"	
			echo "=================================================="
			entryColumnName
		fi
	else
		echo -e "\e[31mError : This $columnName is PK Can't Update PK \e[0m"	
		echo "=================================================="
		entryColumnName
	fi
}
#########################################################
checkIDisFound(){
	#check id is found
	idIsFound ${Tables[$Table_Name_Index]} $pkInput
	if [ $? -eq 1 ];then
		# Entry Column Name Want Update
		entryColumnName
	else
		echo -e "\e[31mError : This $getPKName is not found\e[0m"	
		echo "=================================================="
	fi
}
#########################################################
#Update By Column Function => Used in Main
UpdateByColumn(){
	getPKName=$(cut -f1 -d: ${Tables[$Table_Name_Index]} | head -1)
	getPKDataType=$(cut -f1 -d: ${Tables[$Table_Name_Index]} | head -2 | tail -1)

	echo "=================================================="
	echo -e "\e[36mThis Filed Is PK must be unique\e[0m"	
	read -p "Enter $getPKName (PK) field DataType($getPKDataType) : " pkInput
	
	# if datatype of field is int 
	if [[ $getPKDataType =~ ^int$ ]];then
		if [[ $pkInput =~ ^[0-9]+$ ]];then
			
			#check id is found
			checkIDisFound
			
		else
			echo -e "\e[31mError : DataType Must be Integer\e[0m"	
			UpdateByColumn		
		fi
	elif [[ $getPKDataType =~ ^str$ ]];then
		if [[ $pkInput =~ ^[a-zA-Z][a-zA-Z0-9_]+$ ]];then
			
			#check id is found
			checkIDisFound
			
		else
			echo -e "\e[31mError : DataType Must be start String\e[0m"	
			UpdateByColumn	
		fi
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
		
			#Print Tables Name You Want Update into
			echo "++=============================================++"
			echo "You Select Table Name : " ${Tables[$Table_Name_Index]}
			
			# if table not Empty
			if [ `cat ${Tables[$Table_Name_Index]} | wc -l` -gt 2 ];then 
			
				select choice in "Update By ID" "Update By Column" "Exit"
					do     
						case $choice in 
							"Update By ID" )
						    		#Update By ID Function
						    		UpdateByID
							;;
							"Update By Column" )
								#Update By Column Function
						    		UpdateByColumn
							;;					
							"Exit" )
						    		echo -e "\e[31mExit Update From Table \e[0m"
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
