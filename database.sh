#! /usr/bin/bash 

# CreateDatabase SelectDatabase CreateTable InsertTable 

cd ~/Downloads/bash/Bash-project/DBMS
echo "Welcome to the Bash DBMS App!"

select var in CreateDatabase SelectDatabase ListDatabases DropDatabase exit
do
	case $var in
	"CreateDatabase")
	cd ~/Downloads/bash/Bash-project/DBMS
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
		
	;;
	"ListDatabases")
	cd ~/Downloads/bash/Bash-project/DBMS
		ls 
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
	;;
	"exit")
		echo "Goodbye!"
		exit
		;;
	*)
		echo invalid input
esac
done
