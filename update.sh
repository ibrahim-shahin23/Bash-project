#!/bin/bash

while true; do
    read -p "Please enter Table name to update: " TBname

    if [[ -z $TBname ]]; then
        echo "Invalid Table name. Please try again."
    elif [ -e "$TBname" ]; then
        break
    else
        echo "Table '$TBname' doesn't exist. Please try again."
    fi
done

echo "Update operation on table $TBname:"

columnSize=$(wc -l < .$TBname-metadata)

while true; do
    read -p "Enter the column number to update: " updateCol

    if [[ -z $updateCol || $updateCol -lt 1 || $updateCol -gt $columnSize ]]; then
        echo "Invalid column number. Please enter a valid number between 1 and $columnSize."
    else
        break
    fi
done

columnMetadata=$(sed -n "${updateCol}p" .$TBname-metadata)
colName=$(echo $columnMetadata | cut -d: -f1)
colType=$(echo $columnMetadata | cut -d: -f2)
colPkCheck=$(echo $columnMetadata | cut -d: -f3)

while true; do
    read -p "Enter the new value to update: " val
    if [[ $colPkCheck == "pk" ]]; then

        if [[ $(grep -c "$val:" "$TBname") -ne 0 ]]; then
            echo "Primary key value '$val' already exists. Please enter a unique value."
            continue
        fi
    fi
    if [[ $colType == "int" && ! $val =~ ^[0-9]+$ ]]; then
        echo "Invalid value. Please enter a valid integer."
        continue
    elif [[ $colType == "string" && ! $val =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "Invalid value. Please enter a valid string (alphanumeric and underscores only)."
        continue
    else
        break
    fi
done

while true; do
    read -p "Enter the column number to filter for update: " filterCol

    if [[ -z $filterCol || $filterCol -lt 1 || $filterCol -gt $columnSize ]]; then
        echo "Invalid column number for filtering. Please enter a valid number between 1 and $columnSize."
    else
        break
    fi
done

while true; do
    read -p "Enter the value to filter by: " filterVal

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

awk -F: -v filterCol="$filterCol" -v filterVal="$filterVal" -v updateCol="$updateCol" -v newValue="$val" \
    'BEGIN {OFS=":"} $filterCol == filterVal { $updateCol = newValue } { print $0 }' "$TBname" > tempFile && mv tempFile "$TBname"

echo "Table updated successfully."
 ~/Downloads/bash/Bash-project/tables.sh