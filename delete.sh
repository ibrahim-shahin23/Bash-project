read -p "Please enter Table name to delete from: " TBname
if [[ -z $TBname ]]; then
	echo "Invalid Table name"
else
	if [ -e "$TBname" ]; then
	    echo "Delete operation on table $TBname:"
	    echo "1. Delete rows based on condition"
	    read -p "Choose an option (1): " option
	    columnSize=$(wc -l < .$TBname-metadata)
	    case $option in
		1)
		    read -p "Enter the column number to filter for deletion: " filterCol
		    if [[ -z $filterCol || $filterCol -lt 1 || $filterCol -gt $columnSize ]]; then
				echo "Invalid column number. Please enter a valid number between 1 and $columnSize."
			else 
		    	read -p "Enter the value to delete: " filterVal
		    	awk -F: -v col="$filterCol" -v value="$filterVal" '$col != value' "$TBname" > tempFile && mv tempFile "$TBname"
		    	echo "Rows deleted successfully."
		    fi
            ;;
		*)
			echo "Invalid option"
			;;
		esac
		else
		    echo "$TBname Table doesn't exist"
	fi
fi
