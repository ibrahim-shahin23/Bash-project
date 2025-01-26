#!/bin/bash

if [[ ! "$(ls -A)" ]]; then
    dialog --msgbox "There's no tables to delete from." 10 50
else
    while true; do
        TBname=$(dialog --inputbox "Please enter table name to delete from:" 10 50 3>&1 1>&2 2>&3)
        if [[ $? -ne 0 ]]; then
            dialog --msgbox "Operation canceled." 10 50
            break
        elif [[ -z $TBname ]]; then
            dialog --msgbox "Invalid Table name. Please try again." 10 50
        else
    if [[ -e "$TBname" ]]; then
        if [[ -s "$TBname" ]]; then
            while true; do
                option=$(dialog --menu "Delete operation on table $TBname:" 15 50 3 \
                    1 "Delete rows based on condition" \
                    2 "Delete all rows" \
                    3 "Cancel" \
                    3>&1 1>&2 2>&3)

                if [[ $? -ne 0 ]]; then
                    dialog --msgbox "Operation canceled." 10 50
                    exit
                fi

                case $option in
                1)
                    columnSize=$(wc -l < ".$TBname-metadata")
                    colMenu=""
                    for ((i = 1; i <= columnSize; i++)); do
                        colName=$(sed -n "$i p" ".$TBname-metadata" | cut -d: -f1)
                        colMenu+="$i $colName "
                    done

                    filterCol=$(dialog --menu "Select column to filter for deletion:" 15 50 $columnSize $colMenu 3>&1 1>&2 2>&3)
                    if [[ $? -ne 0 ]]; then
                        dialog --msgbox "Operation canceled." 10 50
                        continue
                    fi

                    filterVal=$(dialog --inputbox "Enter value to filter for deletion:" 10 50 3>&1 1>&2 2>&3)
                    if [[ $? -ne 0 ]]; then
                        dialog --msgbox "Operation canceled." 10 50
                        continue
                    elif [[ -z $filterVal ]]; then
                        dialog --msgbox "Invalid value. Please enter a valid value to filter by." 10 50
                        continue
                    fi

                    if [[ $(cut -d: -f"$filterCol" "$TBname" | grep -c ^"$filterVal"$) -eq 0 ]]; then
                        dialog --msgbox "No rows found with the specified value." 10 50
                        continue
                    fi

                    awk -F: -v col="$filterCol" -v value="$filterVal" '$col != value' "$TBname" > tempFile && mv tempFile "$TBname"
                    dialog --msgbox "Rows deleted successfully based on the condition." 10 50
                    ;;
                2)
                    >"$TBname"
                    dialog --msgbox "All rows deleted successfully." 10 50
                    ;;
                3)
                    break
                    ;;
                *)
                    dialog --msgbox "Invalid option. Please try again." 10 50
                    ;;
                esac
            done
        else
            dialog --msgbox "The table $TBname is empty." 10 50
        fi
    else
        dialog --msgbox "Table $TBname does not exist. Please try again." 10 50
    fi
            
        fi
    done

fi
