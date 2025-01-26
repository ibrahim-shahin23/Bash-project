cd ~/Downloads/bash/Bash-project/DBMS
while true
do
	select var in CreateDatabase SelectDatabase ListDatabases DropDatabase exit
	do
		case $var in
		"CreateDatabase")
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
			break
		;;
		"SelectDatabase")
			if [[ ! $(ls -A)  ]] ; then
				echo "There's no databases to select"
			else
				read -p "Please Enter your Database name: " DB_name
				if [[ -z $DB_name ]]
				then
					echo invalid DBname
				else
					if [ -e "$DB_name" ]
					then
						export DB_name 
						source ~/Downloads/bash/Bash-project/tables.sh
					else
						echo $DB_name Database doesn\'t exist
					fi
				fi

			fi

		break
		;;
		"ListDatabases")
			if [[ ! $(ls -A)  ]] ; then
				echo "There's no databases to display"
			else
				ls #~/Downloads/bash/Bash-project/DBMS
			fi
			break
		;;
		"DropDatabase")
			if [[ ! $(ls -A)  ]] ; then
				echo "There's no databases to Drop"
			else
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
			fi

			break
		;;
		"exit")
			echo "Goodbye!"
			exit
			;;
		*)
			echo invalid input
			break
	esac
	done
done
