#!/bin/bash


while true; do
if [[ ! "$(ls -A)" ]]; then
    dialog --msgbox "There are no tables to select from." 10 50
else
    # Prompt the user to enter the table name
    TBname=$(dialog --inputbox "Please enter the table name to select from:" 10 50 3>&1 1>&2 2>&3)
	exit_status=$?
    if [[ $exit_status -eq 1 ]]; then
        # User selected "Cancel," exit the loop
        break
    fi


    if [[ -z $TBname ]]; then
        dialog --msgbox "Invalid Table name." 10 50
    else
        if [[ -e "$TBname" ]]; then
            if [[ -s "$TBname" ]]; then
                # Main loop for table operations
                while true; do
                    option=$(dialog --menu "Select operation on table $TBname:" 15 60 5 \
                        1 "Display all columns" \
                        2 "Display specific columns" \
                        3 "Filter rows based on conditions" \
                        4 "Cancel" 3>&1 1>&2 2>&3)
					if [[ $exit_status -eq 1 ]]; then
    				# User selected "Cancel," exit the loop
   					 break
					fi

                    case $option in
                    1)
                        # Display all rows in the table
                        dialog --msgbox "Displaying all rows from $TBname:\n$(cat "$TBname")" 20 70
                        ;;
                    2)
                        # Display specific columns
					columnSize=$(wc -l < .$TBname-metadata)
					colMenu=""
					for ((i = 1; i <= columnSize; i++)); do
						colName=$(sed -n "$((i))p" .$TBname-metadata | cut -d: -f1)
						colMenu+="$i $colName "
					done

					while true; do
						cols=$(dialog --inputbox "Available columns:\n$colMenu\nEnter the column numbers to display (comma-separated):" 15 50 3>&1 1>&2 2>&3)
						if [[ -z $cols ]]; then
							dialog --msgbox "No input provided. Please enter column numbers." 10 50
						elif [[ ! $cols =~ ^[0-9]+(,[0-9]+)*$ ]]; then
							dialog --msgbox "Invalid input. Please enter column numbers separated by commas." 10 50
						else
							output=$(cut -d: -f$cols "$TBname" 2>/dev/null)
							if [[ -z $output ]]; then
								dialog --msgbox "Invalid column numbers. Please enter numbers between 1 and $columnSize." 10 50
							else
								dialog --msgbox "Selected Columns:\n$output" 20 70
								break
							fi
						fi
					done
					;;
                    3)
                        # Filter rows based on conditions
                        columnSize=$(wc -l < .$TBname-metadata)
                        colMenu=""
                        for ((i = 1; i <= columnSize; i++)); do
                            colName=$(sed -n "$((i))p" .$TBname-metadata | cut -d: -f1)
                            colMenu+="$i $colName "
                        done

                        filterCol=$(dialog --menu "Select a column to filter:" 15 50 $columnSize $colMenu 3>&1 1>&2 2>&3)
                        if [[ -n $filterCol ]]; then
                            filterVal=$(dialog --inputbox "Enter the value to filter by:" 10 50 3>&1 1>&2 2>&3)
                            if [[ -n $filterVal ]]; then
                                filteredRows=$(awk -F: -v col="$filterCol" -v value="$filterVal" '$col == value' "$TBname")
                                if [[ -n $filteredRows ]]; then
                                    dialog --msgbox "Rows matching the condition:\n$filteredRows" 20 70
                                else
                                    dialog --msgbox "No rows found with the specified value." 10 50
                                fi
                            else
                                dialog --msgbox "Invalid filter value." 10 50
                            fi
                        else
                            dialog --msgbox "No column selected." 10 50
                        fi
                        ;;
                    4)
                        # Exit the menu
                        break
                        ;;
                    *)
                        dialog --msgbox "Invalid option selected." 10 50
                        ;;
                    esac
                done
            else
                dialog --msgbox "The table is empty." 10 50
            fi
        else
            dialog --msgbox "Table $TBname doesn't exist." 10 50
        fi
    fi
fi
done