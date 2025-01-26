#!/bin/bash
if [[ ! "$(ls -A )" ]]; then
	echo "There's no tables to select from"
else
	while true; do
	    read -p "Please enter Table name to delete from: " TBname
	    if [[ -z $TBname ]]; then
		echo "Invalid Table name. Please try again."
		else
			break
		fi	
	done
	    if [ -e "$TBname" ]; then
	    		
		while true; do
		    echo "Delete operation on table $TBname:"
		    echo "1. Delete rows based on condition"
		    echo "2. Delete all rows"
		    echo "3. cancel"
		    read -p "Choose an option (1 or 2 or 3): " option

		    if [[ $option -eq 1 || $option -eq 2 || $option -eq 3 ]]; then
			break
		    else
			echo "Invalid option. Please enter 1 or 2 or 3."
		    fi
		done

		case $option in
		1)
			echo "Update operation on table $TBname:"
			echo "Available columns:"
			columnSize=$(wc -l < .$TBname-metadata)
			for ((i=1; i<=columnSize; i++))
				do
					colName=$(sed -n "$((i))p" .$TBname-metadata | cut -d: -f1)
					echo "$i) $colName"
				done
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
					if [[ `cut -d: -f$filterCol $TBname | grep -c ^$filterVal$` -eq 0 ]]
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
		3)
			cd ~/Downloads/bash/Bash-project/tables.sh
		;;	
		*)
		    echo "Invalid option"
		    ;;
		esac
			
		    else
			echo "$TBname Table doesn't exist. Please try again."
		    fi
fi	
