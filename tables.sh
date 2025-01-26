#!/bin/bash

cd "$DB_name"
dialog --msgbox "Connected to database: $DB_name" 10 50

while true; do
    var=$(dialog --title "Table Operations" --menu "Choose an operation:" 15 50 8 \
        1 "Create Table" \
        2 "Drop Table" \
        3 "List Tables" \
        4 "Insert Into Table" \
        5 "Select From Table" \
        6 "Delete From Table" \
        7 "Update Table" \
        8 "Go Back" \
        9 "Exit" 3>&1 1>&2 2>&3)

		if [ $? -eq 1 ]; then
        var=8  # Treat Cancel as "Exit"
    	fi

	clear
    case $var in
        1)
            source ~/Downloads/bash/Bash-project/createTable.sh
            ;;
        2)
            source ~/Downloads/bash/Bash-project/dropTable.sh
            ;;
        3)
            if [[ ! "$(ls -A)" ]]; then
                dialog --msgbox "There's no tables to display." 10 40
            else
                tables=$(ls)
                dialog --title "Tables" --msgbox "Available tables:\n\n$tables" 15 40
            fi
            ;;
        4)
            source ~/Downloads/bash/Bash-project/insert.sh
            ;;
        5)
            source ~/Downloads/bash/Bash-project/select.sh
            ;;
        6)
            source ~/Downloads/bash/Bash-project/delete.sh
            ;;
        7)
            source ~/Downloads/bash/Bash-project/update.sh
            ;;
        8)
            cd ..
            return
            ;;
        9)
            dialog --title "Exit" --yesno "Are you sure you want to exit?" 10 40
            if [ $? -eq 0 ]; then
                clear
                exit
            fi
            ;;
        *)
            dialog --msgbox "Invalid option!" 10 40
            ;;
    esac
done
