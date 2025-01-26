while true
do
read -p "Enter new table name: " TB_name
if [[ -z $TB_name || ! $TB_name =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
	echo "Invalid table name. Please use alphanumeric characters only."
else
	if [[ -e $TB_name ]]; then 
		echo table is already exist
	else
		while true 
		do
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
             				read -p "make $colName the primary key for the table? (yes/y): " pkCheck
             				if [[ $pkCheck =~ ^([yY][eE][sS]|[yY])$ ]]; then
                 				line+=pk
                 				flag=1
             				fi
         				fi
         				echo $line >> .$TB_name-metadata
     		done
			if [[ $? -eq 0 ]]; then
						touch $TB_name
         				echo "Table $TB_name created successfully!"
						break
     				else
         				echo "Failed to create table file."
     				fi
		fi
		done
		break
	fi
fi
done
