#!/bin/bash

if [[ ! "$(ls -A)" ]]; then
    dialog --msgbox "There's no tables to update." 10 50
else
    while true; do
        TBname=$(dialog --inputbox "Please enter the table name to update:" 10 50 3>&1 1>&2 2>&3)
        if [[ $? -ne 0 ]]; then
            dialog --msgbox "Operation canceled." 10 50
            break
        elif [[ -z $TBname ]]; then
            dialog --msgbox "Invalid table name. Please try again." 10 50
        else
                if [[ -e "$TBname" ]]; then
        if [[ -s "$TBname" ]]; then
            while true; do
                option=$(dialog --menu "Update operation on table $TBname:" 15 50 2 \
                    1 "Update rows based on condition" \
                    2 "Cancel" \
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

                    updateCol=$(dialog --menu "Select the column to update:" 15 50 $columnSize $colMenu 3>&1 1>&2 2>&3)
                    if [[ $? -ne 0 ]]; then
                        continue
                    fi

                    columnMetadata=$(sed -n "${updateCol}p" ".$TBname-metadata")
                    colName=$(echo $columnMetadata | cut -d: -f1)
                    colType=$(echo $columnMetadata | cut -d: -f2)
                    colPkCheck=$(echo $columnMetadata | cut -d: -f3)

                    while true; do
                        val=$(dialog --inputbox "Enter the new value for $colName:" 10 50 3>&1 1>&2 2>&3)
                        if [[ $? -ne 0 ]]; then
                            break
                        elif [[ $colPkCheck == "pk" && $(grep -c "^$val:" "$TBname") -ne 0 ]]; then
                            dialog --msgbox "Primary key value '$val' already exists. Please enter a unique value." 10 50
                            continue
                        elif [[ $colType == "int" && ! $val =~ ^[0-9]+$ ]]; then
                            dialog --msgbox "Invalid value. Please enter a valid integer." 10 50
                            continue
                        elif [[ $colType == "string" && ! $val =~ ^[a-zA-Z0-9_]+$ ]]; then
                            dialog --msgbox "Invalid value. Please enter a valid string (alphanumeric and underscores only)." 10 50
                            continue
                        else
                            break
                        fi
                    done

                    filterCol=$(dialog --menu "Select the column to filter by:" 15 50 $columnSize $colMenu 3>&1 1>&2 2>&3)
                    if [[ $? -ne 0 ]]; then
                        continue
                    fi

                    filterVal=$(dialog --inputbox "Enter the value to filter by:" 10 50 3>&1 1>&2 2>&3)
                    if [[ $? -ne 0 ]]; then
                        continue
                    elif [[ $(cut -d: -f"$filterCol" "$TBname" | grep -c "^$filterVal$") -eq 0 ]]; then
                        dialog --msgbox "No rows found with the specified filter value." 10 50
                        continue
                    fi

                    awk -F: -v filterCol="$filterCol" -v filterVal="$filterVal" -v updateCol="$updateCol" -v newValue="$val" \
                        'BEGIN {OFS=":"} $filterCol == filterVal { $updateCol = newValue } { print $0 }' "$TBname" > tempFile && mv tempFile "$TBname"

                    dialog --msgbox "Table updated successfully." 10 50
                    ;;
                2)
                    break
                    ;;
                *)
                    dialog --msgbox "Invalid option." 10 50
                    ;;
                esac
            done
        else
            dialog --msgbox "The table $TBname is empty." 10 50
        fi
    else
        dialog --msgbox "Table $TBname does not exist." 10 50
    fi

        fi
    done

fi
