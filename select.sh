# echo "alias tables='~/Downloads/bash/Bash-project/tables.sh'" >> ~/.zshrc

read -p "Please enter table name to select from: " TBname
if [[ -z $TBname ]]
then
	echo "Invalid Table name"
else
	if [ -e "$TBname" ]
	then
    	# Read metadata to get column names and data types
    	echo "Select operation on table $TBname:"
    	echo "1. Display all columns"
    	echo "2. Display specific columns"
    	echo "3. Filter rows based on conditions"
        echo "4. Back to main menu"
    	read -p "Choose an option (1-3): " option
    
    	case $option in
		1)
	    	# Display all data in the table
	    	echo "Displaying all rows from $TBname:"
	    	cat "$TBname"
            ~/Downloads/bash/Bash-project/tables.sh
	    	;;
		2)
	    	# Display specific columns
	    	echo "Available columns:"
	    	columnSize=$(wc -l < .$TBname-metadata)
	    	for ((i=1; i<=columnSize; i++))
	    		do
					colName=$(sed -n "$((i))p" .$TBname-metadata | cut -d: -f1)
					echo "$i) $colName"
	    		done
	    	read -p "Enter the column numbers to display (comma separated): " cols
			if [[ ! $cols =~ ^[0-9]+(,[0-9]+)*$ ]]; then
				echo "Invalid input. Please enter column numbers separated by commas."
			else
	    		cat "$TBname" | cut -d: -f$cols $TBname	
			fi
            ~/Downloads/bash/Bash-project/tables.sh							   
	    	;;
		3)
	    	# Filter rows based on a condition
			echo "Available columns:"
	    	columnSize=$(wc -l < .$TBname-metadata)
	    	for ((i=1; i<=columnSize; i++))
	    		do
					colName=$(sed -n "$((i))p" .$TBname-metadata | cut -d: -f1)
					echo "$i) $colName"
	    		done							   
			# Filter rows based on a condition
			read -p "Enter the column number to filter: " filterCol
			if [[ ! $filterCol =~ ^[0-9]+$ || $filterCol -le 0 || $filterCol -gt $columnSize ]]; then
				echo "Invalid column number. Please enter a valid column number."
			else
				read -p "Enter the value to filter by: " filterVal
				if [[ -z $filterVal ]]; then
					echo "Invalid value. Please enter a value to filter by."
				else
					echo "Rows where column $filterCol has value $filterVal:"
					# Using awk for filtering
					awk -F: -v col="$filterCol" -v value="$filterVal" '$col == value' "$TBname"
				fi
			fi
            ~/Downloads/bash/Bash-project/tables.sh
			;;
        4)
        	# Go back to main menu
        	tables
        	;;
		*)
	    	echo "Invalid option"
            ~/Downloads/bash/Bash-project/tables.sh
	    	;;
    	esac
		else
    		echo "Table $TBname doesn't exist"
            ~/Downloads/bash/Bash-project/tables.sh
	fi
fi  
