select var in CreateTable DropTable ListTables InsertIntoTable SelectFromTable goBack
do
	case $var in
	"CreateTable")
		read -p "Enter new table name: " TB_name
		if [[ -z $TB_name || ! $TB_name =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
			echo "Invalid table name. Please use alphanumeric characters only."
		else
			if [[ -e $TB_name ]]; then 
				echo table is already exist
			else
				read -p "Enter number of columns: " colNum
				if [[ ! $colNum =~ ^[0-9]+$ || $colNum -le 0 ]]; then
       				echo "Invalid number of columns. Please enter a positive integer."
   				else								
					flag=0
					touch .$TB_name-metadata
					for ((i=0; i<$colNum; i++))
					do
           				line=""
						while true
							do
           						read -p "Enter name of column $((i+1)): " colName
           						if [[ -z $colName || ! $colName =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
               						echo "Invalid column name. Please use alphanumeric characters only."
               					else
			   						break
			   					fi
		   					done

           				line+=$colName:
						while true
						do
           					read -p "Enter data type for column $colName (e.g., int, string): " datatype
           					if [[ -z $datatype || ! $datatype =~ ^(int|string)$ ]]; then
               					echo "Invalid data type. Use 'int' or 'string'."
							else
								break
          					fi
						done
           				line+=$datatype:
           				if [[ $flag -eq 0 ]]; then
               				read -p "Do you want to make $colName the primary key? (yes/no): " pkCheck
               				if [[ $pkCheck =~ ^([yY][eE][sS]|[yY])$ ]]; then
                   				line+=pk
                   				flag=1
               				fi
           				fi
           				echo $line >> .$TB_name-metadata
       				done
					touch $TB_name
					if [[ $? -eq 0 ]]; then
           				echo "Table $TB_name created successfully!"
       				else
           				echo "Failed to create table file."
       				fi
				fi
			fi
		fi
	;;
	"DropTable")
		read -p "Please Enter a Table to remove: " TB_name
		if [[ -z $TB_name ]]
		then
			echo invalid TBname
		else
			if [ -e "$TB_name" ]
			then 
				rm "$TB_name" ".$TB_name-metadata"
				echo table $TB_name is removed
			else
				echo $TB_name Table doesn\'t exist
			fi
		fi
	;;
	"goBack")
		~/Downloads/bash/Bash-project/database.sh
	;;
	"ListTables")
        ls 
    ;;
	"InsertIntoTable")
	read -p "please Enter Table Name: " TBName
		if [[ -z $TBName ]]
	then
		echo invalid Table name
	else
		if [[ -e $TBName ]]
		then 
			columnSize=`wc -l .$TBName-metadata | cut -d" " -f1`
			data=""
			for ((i=0;i<columnSize;i++))
			do
				line=`sed -n "$(echo $((i+1)))p" .$TBName-metadata`
				colName=`echo $line | cut -d: -f1`
				colType=`echo $line | cut -d: -f2`
				colPkCheck=`echo $line | cut -d: -f3`
				read -p "please enter a value for $colName: " val
				if [[ $colPkCheck == "pk" ]]
				then
					if [[ `grep -c "$val:" $TBName` -ne 0 ]]
					then
						echo "Primary key value already exists. Please enter a unique value."
						i=$((i-1))
						continue
					fi
				fi
				if [[ $colType == "int" && ! $val =~ ^[0-9]+$ ]]
				then
					echo "Invalid value. Please enter an integer."
					i=$((i-1))
					continue
				elif [[ $colType == "string" && ! $val =~ ^[a-zA-Z0-9_]+$ ]]
				then
					echo "Invalid value. Please enter a string."
					i=$((i-1))
					continue
				else data+=$val:
				fi
				#echo $colName $colType $colPkCheck
			done
			echo $data >> $TBName
			echo "Data is inserted"
		else
			echo table is doesn\'t exist
		fi
	fi
	;;
	"SelectFromTable")
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
	    	read -p "Choose an option (1-3): " option
	    
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
		    	read -p "Enter the column numbers to display (comma separated): " cols

		    	cat | cut -d: -f$cols $TBname								   
		    	;;
			3)
		    	# Filter rows based on a condition
		    	read -p "Enter the column number to filter: " filterCol
		    	read -p "Enter the value to filter by: " filterVal

		    	echo "Rows where column $filterCol has value $filterVal:"
		    	colIndex=$((filterCol-1))
		    	for row in $(cat "$TBname")
		    	do
				rowValues=($row)
				if [[ "${rowValues[$colIndex]}" == "$filterVal" ]]
				then
				    echo "$row"
				fi
		    	done
		    	;;
			*)
		    	echo "Invalid option"
		    	;;
	    	esac
			else
	    		echo "Table $TBname doesn't exist"
		fi
    fi  
	;;
	*)
	echo invalid input
	esac
done