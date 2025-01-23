read -p "Please enter Table name to update: " TBname
if [[ -z $TBname ]]; then
    echo "Invalid Table name"
else
	if [ -e "$TBname" ]; then
	    echo "Update operation on table $TBname:"
	    echo "1. Update a specific column based on condition"
	    read -p "Choose an option (1): " option
        columnSize=$(wc -l < .$TBname-metadata)
		case $option in
		1)
	    read -p "Enter the column number to update: " updateCol
	    if [[ -z $updateCol || $updateCol -lt 1 || $updateCol -gt $columnSize ]]; then
       		echo "Invalid column number. Please enter a valid number between 1 and $columnSize."
       	else
	    	read -p "Enter the new value to update: " newValue						
	    	read -p "Enter the column number to filter for update: " filterCol
	    	if [[ -z $filterCol || $filterCol -lt 1 || $filterCol -gt $columnSize ]]; then
       			echo "Invalid column number. Please enter a valid number between 1 and $columnSize."
       		else
	    		read -p "Enter the value to filter by: " filterVal
				awk -F: -v filterCol="$filterCol" -v filterVal="$filterVal" -v updateCol="$updateCol" -v newValue="$newValue" \
				'BEGIN {OFS=":"} $filterCol == filterVal {$updateCol = newValue} {print $0}' "$TBname" > tempFile && mv tempFile "$TBname"
				echo "Table updated successfully."
			fi
		fi
	    ;;
	    *)
    	    echo "Invalid option"
    	;;
	    esac
	else
		echo "Table $TBname doesn't exist"
    fi
fi  