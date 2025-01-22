#! /usr/bin/bash 

# CreateDatabase SelectDatabase CreateTable InsertTable 

select var in CreateDatabase SelectDatabase ListDatabases DropDatabase
do
	case $var in
	"CreateDatabase")
		read -p "Enter a new Database name: " DB_name
		if [[ -z $DB_name ]]
		then
			echo invalid DBname
		else
			if [ -e "$DB_name" ]
			then 
				echo $DB_name Database is already exist
			else
				mkdir "$DB_name"
				echo $DB_name Database is created successfully
			fi
		fi
		
	;;
	"SelectDatabase")
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
		
	;;
	"ListDatabases")
		ls 
	;;
	"DropDatabase")
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
	;;
	*)
		echo invalid input
esac
done
