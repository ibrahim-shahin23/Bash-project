#!/bin/bash

if [[ ! "$(ls -A)" ]]; then
    dialog --msgbox "There's no tables to drop." 10 50
else
    # Create a menu of available tables
    tableList=$(ls | grep -v '^\.') # Exclude hidden files (metadata files)
    if [[ -z $tableList ]]; then
        dialog --msgbox "There's no tables to drop." 10 50
    else
        # Build menu options dynamically
        menuOptions=()
        for table in $tableList; do
            menuOptions+=("$table" "" off)
        done

        # Let the user select a table to drop
        selectedTable=$(dialog --radiolist "Select a table to remove:" 15 50 10 "${menuOptions[@]}" 3>&1 1>&2 2>&3)
        
        if [[ $? -ne 0 ]]; then
            dialog --msgbox "Operation canceled." 10 50
        elif [[ -z $selectedTable ]]; then
            dialog --msgbox "No table selected." 10 50
        else
            # Confirm deletion
            dialog --yesno "Are you sure you want to delete the table $selectedTable?" 10 50
            if [[ $? -eq 0 ]]; then
                # Remove the table and its metadata
                rm "$selectedTable" ".$selectedTable-metadata" 2>/dev/null
                if [[ $? -eq 0 ]]; then
                    dialog --msgbox "Table $selectedTable has been removed successfully." 10 50
                else
                    dialog --msgbox "Failed to remove the table $selectedTable." 10 50
                fi
            else
                dialog --msgbox "Deletion canceled." 10 50
            fi
        fi
    fi
fi
