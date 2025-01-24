#!/bin/bash

while true; do
    read -p "Please enter Table name to delete from: " TBname
    if [[ -z $TBname ]]; then
        echo "Invalid Table name. Please try again."
    elif [ -e "$TBname" ]; then
        break
    else
        echo "$TBname Table doesn't exist. Please try again."
    fi
done

while true; do
    echo "Delete operation on table $TBname:"
    echo "1. Delete rows based on condition"
    echo "2. Delete all rows"
    read -p "Choose an option (1 or 2): " option

    if [[ $option -eq 1 || $option -eq 2 ]]; then
        break
    else
        echo "Invalid option. Please enter 1 or 2."
    fi
done

columnSize=$(wc -l < .$TBname-metadata)

case $option in
1)
    while true; do
        read -p "Enter the column number to filter for deletion: " filterCol
        if [[ -z $filterCol || $filterCol -lt 1 || $filterCol -gt $columnSize ]]; then
            echo "Invalid column number. Please enter a valid number between 1 and $columnSize."
        else
            break
        fi
    done

    while true; do
        read -p "Enter the value to filter for deletion: " filterVal
        if [[ -z $filterVal ]]; then
            echo "Invalid value. Please enter a valid value to filter by."
	    else
			if [[ `grep -c "$filterVal:" $TBname` -eq 0 ]]
			then
				echo "value doesn't exist"
			else
        	    break
			fi
        fi
    done

    awk -F: -v col="$filterCol" -v value="$filterVal" '$col != value' "$TBname" > tempFile && mv tempFile "$TBname"
    echo "Rows deleted successfully based on the condition."
    ;;
2)
    if [[ -s "$TBname" ]]; then
        > "$TBname" 
        echo "All rows deleted successfully."
    else
        echo "Table is already empty."
    fi
    ;;
*)
    echo "Invalid option"
    ;;
esac
 ~/Downloads/bash/Bash-project/tables.sh