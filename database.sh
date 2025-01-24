cd ~/Downloads/bash/Bash-project/DBMS

select var in CreateDatabase SelectDatabase ListDatabases DropDatabase exit
do
	case $var in
	"CreateDatabase")
	cd ~/Downloads/bash/Bash-project/DBMS
		read -p "Enter a new Database name: " DB_name
		if [[ -z $DB_name || ! $DB_name =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
			echo "Invalid database name. Please use alphanumeric characters only."
		else
			if [ -e "$DB_name" ]
			then 
				echo $DB_name Database is already exist
			else

				mkdir "$DB_name"
				echo $DB_name Database is created successfully
			fi
		fi
		~/Downloads/bash/Bash-project/database.sh
	;;
	"SelectDatabase")
	cd ~/Downloads/bash/Bash-project/DBMS
		read -p "Please Enter your Database name: " DB_name
		if [[ -z $DB_name ]]
		then
			echo invalid DBname
		else
			if [ -e "$DB_name" ]
			then 
				cd "$DB_name"
				echo Connected to database $DB_name
				source ~/Downloads/bash/Bash-project/tables.sh
			else
				echo $DB_name Database doesn\'t exist
			fi
		fi
	~/Downloads/bash/Bash-project/database.sh
	;;
	"ListDatabases")
	cd ~/Downloads/bash/Bash-project/DBMS
		ls
		~/Downloads/bash/Bash-project/database.sh 
	;;
	"DropDatabase")
	cd ~/Downloads/bash/Bash-project/DBMS
		read -p "Please Enter a Database to remove: " DB_name
		if [[ -z $DB_name ]]
		then
			echo invalid DBname
		else
			if [ -e "$DB_name" ]
			then 
				rm -r "$DB_name"
				echo database $DB_name is removed
			else
				echo $DB_name Database doesn\'t exist
			fi
		fi
		~/Downloads/bash/Bash-project/database.sh
	;;
	"exit")
		echo "Goodbye!"
		exit
		;;
	*)
		echo invalid input
esac
done
