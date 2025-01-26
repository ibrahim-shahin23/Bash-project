if [[ ! "$(ls -A )" ]]; then
	echo "There's no tables to select from"
else
	read -p "Please enter table name to select from: " TBname
	if [[ -z $TBname ]]
	then
		echo "Invalid Table name"
	else
		if [ -e "$TBname" ]
		then
			if [[ -s "$TBname" ]]; then
				    	# Read metadata to get column names and data types

			while true; do
	    	echo "Select operation on table $TBname:"
	    	echo "1. Display all columns"
	    	echo "2. Display specific columns"
	    	echo "3. Filter rows based on conditions"
	        echo "4. cancel"
	    	read -p "Choose an option (1-4): " option
	
	    	case $option in
			1)
		    	# Display all data in the table
		    	echo "Displaying all rows from $TBname:"
		    	cat "$TBname"
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
				while true ; do
		    	read -p "Enter the column numbers to display (comma separated): " cols
				if [[ ! $cols =~ ^[0-9]+(,[0-9]+)*$ ]]; then
					echo "Invalid input. Please enter column numbers separated by commas."
				else
		    		output=`cut -d: -f$cols $TBname`
					if [[ -z $output ]]; then
						echo "Invalid column numbers. Please enter numbers between 1 and $columnSize."
					else
						echo "$output"
						break
					fi	
				fi
				done
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
				while true; do
					read -p "Enter the value to filter by: " filterVal
					if [[ -z $filterVal ]]; then
						echo "Invalid value. Please enter a value to filter by."
					elif [[ `cut -d: -f$filterCol $TBname | grep -c ^$filterVal$` -eq 0 ]]; then
						echo "No rows found where column $filterCol has value $filterVal."
						break
					else
						echo "Rows where column $filterCol has value $filterVal:"
						# Using awk for filtering
						awk -F: -v col="$filterCol" -v value="$filterVal" '$col == value' "$TBname"
						break
					fi
				done
				fi
				;;
	        4)	
				break
	        	;;
			*)
		    	echo "Invalid option"
		    	;;
	    	esac
			done
				else
					echo "Table is empty."
			fi
		else
	    	echo "Table $TBname doesn't exist"
		fi
	fi  
fi