#!/bin/bash

cd ~/Downloads/bash/Bash-project/DBMS

while true; do
    # Main Menu without Cancel option
    choice=$(dialog --title "Bash DBMS" --menu "Select an option:" 15 50 5 \
        1 "Create Database" \
        2 "Select Database" \
        3 "List Databases" \
        4 "Drop Database" \
        5 "Exit" 3>&1 1>&2 2>&3)

		if [ $? -eq 1 ]; then
        choice=5  # Treat Cancel as "Exit"
    	fi

    clear
    case $choice in
        1) 
            # Create Database
			while true; do
			db_name=$(dialog --inputbox "Enter a new Database name:" 10 50 3>&1 1>&2 2>&3)
			exit_status=$?
			if [[ $exit_status -eq 1 ]]; then
				# User selected "Cancel," return to the main menu
				break
			elif [[ -z $db_name || ! $db_name =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
				dialog --msgbox "Invalid database name. Please use alphanumeric characters only." 10 50
				continue
			elif [ -e "$db_name" ]; then
				dialog --msgbox "Database $db_name already exists!" 10 50
				continue
			else
				mkdir "$db_name"
				dialog --msgbox "Database $db_name created successfully!" 10 50
				break
			fi
			done
			;;

        2) 
            if [[ ! $(ls -A) ]]; then
                dialog --msgbox "There are no databases to select." 10 50
            else
                while true; do
                db_name=$(dialog --inputbox "Enter the name of the database to select:" 10 50 3>&1 1>&2 2>&3)
                exit_status=$?
    			if [[ $exit_status -eq 1 ]]; then
				# User selected "Cancel," return to the main menu
				break

                elif [[ -z $db_name ]]; then
                    dialog --msgbox "Invalid database name!" 10 50
                elif [ -e "$db_name" ]; then
                    export DB_name="$db_name"
                    source ~/Downloads/bash/Bash-project/tables.sh
                    break
                else
                    dialog --msgbox "Database $db_name does not exist!" 10 50
                fi
                done
            fi
            ;;
        3) 
            if [[ ! $(ls -A) ]]; then
                dialog --msgbox "There are no databases to display." 10 50
            else
                db_list=$(ls)
                dialog --msgbox "Databases:\n$db_list" 15 50
            fi
            ;;
        4) 
            if [[ ! $(ls -A) ]]; then
                dialog --msgbox "There are no databases to drop." 10 50
            else
                while true; do
                db_name=$(dialog --inputbox "Enter the name of the database to drop:" 10 50 3>&1 1>&2 2>&3)
                exit_status=$?
                if [[ $exit_status -eq 1 ]]; then
				# User selected "Cancel," return to the main menu
				break
                elif [[ -z $db_name ]]; then
                    dialog --msgbox "Invalid database name!" 10 50
                elif [ -e "$db_name" ]; then
                    rm -r "$db_name"
                    dialog --msgbox "Database $db_name removed successfully!" 10 50
                else
                    dialog --msgbox "Database $db_name does not exist!" 10 50
                fi
                done
            fi
            ;;
        5) 
            dialog --title "Exit" --yesno "Are you sure you want to exit?" 10 50
            if [ $? -eq 0 ]; then
                clear
                exit 0
            fi
			;;
		*)
            dialog --msgbox "Invalid option selected! Please choose a valid option." 10 50
            ;;
		esac
	done