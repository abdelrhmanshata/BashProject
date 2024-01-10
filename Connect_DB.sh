#! /usr/bin/bash


echo "++=============================================++"
echo -e "\e[36mSuccessfully Connect DataBase $database_Name\e[0m"	
echo "++=============================================++"
echo "++=============================================++"

# Change Propmet Terminal & Color
export PS3=$'\e[33mChoose what you want to do? >>\e[0m '

select choice in "Create_Table" "List_Tables" "Drop_Table" "Insert Into Table" "Select From Table" "Update From Table" "Delete From Table"  "Exit"
do     
	case $choice in 
		"Create_Table" )
            		../../Create_Table.sh
        		exit
        	;;
        	"List_Tables" )
            		../../List_Tables.sh
            		exit
        	;;
        	"Drop_Table" )
        		../../Drop_Table.sh
        		exit
        	;;
        	"Insert Into Table" )
        		../../Insert_Into_Table.sh
        		exit
        	;;
        	"Select From Table" )
        		../../Select_From_Table.sh
        		exit
        	;;
        	"Update From Table" )
        		../../Update_From_Table.sh
        		exit
        	;;
        	"Delete From Table" )
        		../../Delete_From_Table.sh
        		exit
        	;;
        	
        	"Exit" )
            		echo -e "\e[31mDisConnect DataBase \e[0m"
            		cd ../../
            		./DB_Engine.sh
            		exit
        	;;
        	* )
            		echo -e "\e[31mError..Input (Please Select Right Input)\e[0m"
        	;;
    	esac
done 


