#! /usr/bin/bash

echo "++=============================================++"
echo -e "\e[36m||          Welcome In DataBase Engine         ||\e[0m"	
echo "++=============================================++"
echo "++=============================================++"

# Change Propmet Terminal & Color
export PS3=$'\e[33mChoose what you want to do? >>\e[0m '
#List What DBEngine Do
select choice in "Create_DB" "List_DB" "Drop_DB" "Connect_DB" "Exit"
do     
	case $choice in 
		"Create_DB" )
            		./Create_DB.sh
        		exit
        	;;
        	"List_DB" )
            		./List_DB.sh
            		exit
        	;;
        	"Drop_DB" )
        		./Drop_DB.sh
        		exit
        	;;
        	"Connect_DB" )
        		./DB_List_Connection.sh
        		exit
        	;;
        	"Exit" )
            		echo -e "\e[31mExit From DataBase Engine\e[0m"
            		exit
        	;;
        	* )
            		echo -e "\e[31mError..Input (Please Select Right Input)\e[0m"
        	;;
    	esac
done 
