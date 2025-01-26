cd "$DB_name"
echo Connected to database $DB_name
while true
do
	select var in CreateTable DropTable ListTables InsertIntoTable SelectFromTable DeleteFromTable UpdateTable goBack exit
	do
		case $var in
		"CreateTable")
			source ~/Downloads/bash/Bash-project/createTable.sh
			break
		;;
		"DropTable")
			source ~/Downloads/bash/Bash-project/dropTable.sh
			break
		;;
		"goBack")
			cd ..
			return # source ~/Downloads/bash/Bash-project/database.sh
		;;
		"exit")
			echo "Goodbye!"
			exit
		;;
		"ListTables")
		if [[ ! "$(ls -A )" ]]; then
    		echo "There's no tables to display"
			else
	        ls # ~/Downloads/bash/Bash-project/DBMS/$DB_name
		fi
			break
	    ;;
		"InsertIntoTable")
			source ~/Downloads/bash/Bash-project/insert.sh
			break
		;;
		"SelectFromTable")
			source ~/Downloads/bash/Bash-project/select.sh
			break
		;;
		"DeleteFromTable")
		    source ~/Downloads/bash/Bash-project/delete.sh	
			break		    
		;;
		"UpdateTable")
			source ~/Downloads/bash/Bash-project/update.sh
			break
		;;
		*)
		echo invalid input
		break
		;;
		esac
	done
done