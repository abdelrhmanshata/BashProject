#!/bin/bash


clear
# List All Tables 
printAllTables(){
	Tables=()
	echo "++=============================================++"
	echo -e "\e[36m||           Select From Table                 ||\e[0m"	
	echo "++=============================================++"
	echo "++=============================================++"
	echo -e "\e[32m||   Press( 0 ) Exit From Select From Table    ||\e[0m"
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





#Select All Data from table Function

SelectAllData(){

if [ `cat ${Tables[$Table_Name_Index]} | wc -l` -gt 2 ];then 

	echo $(sed -n '1p' ${Tables[$Table_Name_Index]})
	echo $(sed -n '3,$p' ${Tables[$Table_Name_Index]}) | tr ' ' '\n'

	echo "++=============================================++"
	echo -e "\e[32m||       All Data Showed Successfully         ||\e[0m"
	echo "++=============================================++"
	../../Connect_DB.sh
	exit
else
	clear
	echo "++=============================================++"
	echo -e "\e[31m||              This Table Is Empty            ||\e[0m"
	echo "++=============================================++"
	../../Connect_DB.sh
	exit
fi	

}



#SelectbycolumnName  Function

columnIsFound(){
	table=$1
	column=$2
	result=$(sed -n '1p' $table | grep -w "$column" | wc -l)
	return $result
}





SelectbycolumnName(){

while true;
do
	read -p "Enter Column Name : " columnName
	columnIsFound ${Tables[$Table_Name_Index]} $columnName
	if [ $? -eq 1 ];then

		awk -F: -v col="$columnName" '
			BEGIN{ col_Num=0 }
			{ 
				if(NR==1)
				{
					for(i=1;i<=NF;i++)
					{
						if($i==col){
							col_Num=i
							print "---------------------"
							print $col_Num
							print "---------------------"
						}
					}
				}
				else if (NR>2)
				{
					print $col_Num
				}		
			}' ${Tables[$Table_Name_Index]} 
		echo "++=============================================++"
		echo -e "\e[32m||    Selected Data Showed Successfully       ||\e[0m"
		echo "++=============================================++"
		../../Connect_DB.sh
		exit
	else
		echo -e "\e[31mError : This Column Name is not found\e[0m"
		echo "=================================================="	
	fi
done




}

#SelectbyRowID Function
idIsFound(){
	table=$1
	id=$2
	result=$(cut -f1 -d: $table | grep -w $id | wc -l)
	return $result
}


SelectbyRowID(){

pkName=`cut -f1 -d: ${Tables[$Table_Name_Index]} | head -1`
pkType=`cut -f1 -d: ${Tables[$Table_Name_Index]} | head -2 | tail -1 `

while true;
do	
	echo "=================================================="
	echo -e "\e[36mThis Filed Is PK must be unique\e[0m"	
	read -p "Enter ${pkName} (PK) field DataType(${pkType}) : " userinput
	
	# if datatype of field is int 
	if [[ ${pkType} =~ ^int$ ]];then
		if [[ $userinput =~ ^[0-9]+$ ]];then	
			idIsFound ${Tables[$Table_Name_Index]} $userinput
			if [ $? -eq 1 ];then
				# show data by id
				awk -v uID="$userinput" -F: '{ 
					if(NR==1)
					{
						print $0;
					}
					if ($1 == uID){ 
						print $0;
					}
				}' ${Tables[$Table_Name_Index]} 
				

				echo "++=============================================++"
				echo -e "\e[32m||    Selected Data Showed Successfully        ||\e[0m"
				echo "++=============================================++"
				../../Connect_DB.sh
				exit
			else
				echo -e "\e[31mError : This ${pkName} is not found\e[0m"	
				echo "=================================================="
				break
			fi
				
		else
			echo -e "\e[31mError : DataType Must be Integer\e[0m"			
		fi
		
	elif [[ ${pkType} =~ ^str$ ]];then
		if [[ $userinput =~ ^[a-zA-Z0-9_]+$ ]];then 
			idIsFound ${Tables[$Table_Name_Index]} $userinput
			if [ $? -eq 1 ];then
				# show data by id
				awk -v uID="$userinput" -F: '{ 
					if(NR==1)
					{
						print $0;
					}
					if ($1 == uID){ 
						print $0;
					}
				}' ${Tables[$Table_Name_Index]} 
				

				echo "++=============================================++"
				echo -e "\e[32m||    Selected Data Showed Successfully        ||\e[0m"
				echo "++=============================================++"
				../../Connect_DB.sh
				exit
				
			else
				echo -e "\e[31mError : This ${pkName} is not found\e[0m"
				echo "=================================================="	
				break
			fi
		else
			echo -e "\e[31mError : DataType Must be String\e[0m"			
		fi		
	fi
done	
	
}




#Selectbyconditiong
columnIsFound(){
	table=$1
	column=$2
	result=$(sed -n '1p' $table | grep -w "$column" | wc -l)
	return $result
}




Selectbyconditiong()
{
while true;
do
	read -p "Enter Column Name : " columnName
	

	columnIsFound ${Tables[$Table_Name_Index]} $columnName
	if [ $? -eq 1 ];then
		
		index=1;
		colNumber=0;
		for item in `sed -n '1P' ${Tables[$Table_Name_Index]} | tr ':' ' '`
		do
			if [ $item = $columnName ]; then
				colNumber=$index;
			fi
			index=$((index+1));
		done
		col_Datatype=`sed -n '2P' ${Tables[$Table_Name_Index]} | cut -f$colNumber -d ":"`;
		if [ $col_Datatype == "int" ];then
			read -p "Enter Column Name value: " columnNamevalue
			if [[ $columnNamevalue =~ ^[0-9]+$ ]];then
				awk -F: -v col="$columnName" -v val="$columnNamevalue" '
					BEGIN{ col_Num=0; }
					{ 
						if(NR==1)
						{
							for(i=1;i<=NF;i++)
							{
								if($i==col){
									col_Num=i

								}
							}
						}
						else if (NR>2)
						{
							if($col_Num>val)
								print $0
						}
								
					}' ${Tables[$Table_Name_Index]}
			
				echo "++=============================================++"
				echo -e "\e[32m||    Selected Data Showed Successfully       ||\e[0m"
				echo "++=============================================++"
				../../Connect_DB.sh
				exit
			else 
				echo -e "\e[31mError : This Column value is not int Datatype\e[0m"
				echo "=================================================="	
			fi
		else 
			echo -e "\e[31mError : This Column Name is not int Datatype\e[0m"
			echo "=================================================="	
		fi
			
	else
		echo -e "\e[31mError : This Column Name is not found\e[0m"
		echo "=================================================="	

	
	fi
	
done
}

#Selectbyconditionl
columnIsFound(){
	table=$1
	column=$2
	result=$(sed -n '1p' $table | grep -w "$column" | wc -l)
	return $result
}

Selectbyconditionl()
{
while true;
do
	read -p "Enter Column Name : " columnName
	

	columnIsFound ${Tables[$Table_Name_Index]} $columnName
	if [ $? -eq 1 ];then
		
		index=1;
		colNumber=0;
		for item in `sed -n '1P' ${Tables[$Table_Name_Index]} | tr ':' ' '`
		do
			if [ $item = $columnName ]; then
				colNumber=$index;
			fi
			index=$((index+1));
		done
		col_Datatype=`sed -n '2P' ${Tables[$Table_Name_Index]} | cut -f$colNumber -d ":"`;
		if [ $col_Datatype == "int" ];then
			read -p "Enter Column Name value: " columnNamevalue
			if [[ $columnNamevalue =~ ^[0-9]+$ ]];then
				awk -F: -v col="$columnName" -v val="$columnNamevalue" '
					BEGIN{ col_Num=0; }
					{ 
						if(NR==1)
						{
							for(i=1;i<=NF;i++)
							{
								if($i==col){
									col_Num=i

								}
							}
						}
						else if (NR>2)
						{
							if($col_Num<val)
								print $0
						}
								
					}' ${Tables[$Table_Name_Index]}
			
				echo "++=============================================++"
				echo -e "\e[32m||    Selected Data Showed Successfully       ||\e[0m"
				echo "++=============================================++"
				../../Connect_DB.sh
				exit
			else 
				echo -e "\e[31mError : This Column value is not int Datatype\e[0m"
				echo "=================================================="	
			fi
		else 
			echo -e "\e[31mError : This Column Name is not int Datatype\e[0m"
			echo "=================================================="	
		fi
			
	else
		echo -e "\e[31mError : This Column Name is not found\e[0m"
		echo "=================================================="	

	
	fi
	
done
}











while true; 
do
	#Function To Display All Tables
	printAllTables
	
	read -p "Please Enter Table_Index)>> "  Table_Name_Index
	
	if [[ $Table_Name_Index =~ ^[0-9]+$ ]];then
		
		if [ $Table_Name_Index -eq 0 ];then
			clear
			../../Connect_DB.sh
			exit
		fi
		
		if [ $Table_Name_Index -le ${#Tables[@]} ];then 
		
			#Print tables to select from it
			echo "++=============================================++"
			echo "You Select Table Name : " ${Tables[$Table_Name_Index]}
			
			
			select choice in "Select all from table" "Select by column name" "Select Row by ID" "Select by > condition" "Select by < condition"
				do     
					case $choice in 
						"Select all from table" )
					    		#SelectAllData Function
							SelectAllData
						;;
						"Select by column name" )
					    		#SelectbycolumnName  Function
							SelectbycolumnName
						;;
						"Select Row by ID" )
							#SelectbyRowID Function
							SelectbyRowID
						;;
						"Select by > condition" )
							#Selectbyconditiong Function
							Selectbyconditiong
						;;
						"Select by < condition" )
							#Selectbyconditionl Function
							Selectbyconditionl
						;;					
						"Exit" )
					    		echo -e "\e[31mExit Select  From Table \e[0m"
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
