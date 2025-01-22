select var in CreateTable DropTable ListTables goBack
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
           				read -p "Enter name of column $((i+1)): " colName
           				if [[ -z $colName || ! $colName =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
               				echo "Invalid column name. Skipping..."
               				continue
           				fi
           				line+=$colName:
           				read -p "Enter data type for column $colName (e.g., int, string): " datatype
           				if [[ -z $datatype || ! $datatype =~ ^(int|string)$ ]]; then
               				echo "Invalid data type. Use 'int' or 'string'."
               				continue
          					fi
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
        cd ~/Downloads/bash/Bash-project/DBMS
		~/Downloads/bash/Bash-project/database.sh
	;;
    	
	"ListTables")
        ls 
    ;;
	*)
	echo invalid input
	esac
done