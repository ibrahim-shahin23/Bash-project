read -p "Please enter Table name to update: " TBname
if [[ -z $TBname ]]; then
    echo "Invalid Table name"
else
    if [ -e "$TBname" ]; then
        echo "Update operation on table $TBname:"
        echo "1. Update a specific column based on condition"
        read -p "Choose an option (1): " option
        
        # determine the primary key column
        metadataFile=".$TBname-metadata"
        
        if [ ! -e "$metadataFile" ]; then
            echo "Error: Metadata file for table $TBname does not exist."
            exit 1
        fi
        
        # get the primary key column and column details
        columnSize=$(wc -l < "$metadataFile")
        pkCol=0 
        
        for ((i=0;i<columnSize;i++))
        do
            line=$(sed -n "$(echo $((i+1)))p" "$metadataFile")  
            colName=$(echo $line | cut -d: -f1)
            colType=$(echo $line | cut -d: -f2)
            colPkCheck=$(echo $line | cut -d: -f3)
            
            if [[ $colPkCheck == "pk" ]]; then
                pkCol=$((i+1))
            fi
        done

        if [[ $pkCol -eq 0 ]]; then
            echo "Error: Could not determine a unique primary key column."
            exit 1
        fi

        echo "Primary key column determined: $pkCol"

        case $option in
        1)
            read -p "Enter the column number to update: " updateCol
            if [[ -z $updateCol || $updateCol -lt 1 || $updateCol -gt $columnSize ]]; then
                echo "Invalid column number. Please enter a valid number between 1 and $columnSize."
            else
               
                if [[ $updateCol -eq $pkCol ]]; then
                    echo "Error: You cannot update the primary key column ($updateCol)."
                    exit 1
                fi

                
                read -p "Enter the new value to update: " newValue

                
                read -p "Enter the column number to filter for update: " filterCol
                if [[ -z $filterCol || $filterCol -lt 1 || $filterCol -gt $columnSize ]]; then
                    echo "Invalid column number. Please enter a valid number between 1 and $columnSize."
                else
                    read -p "Enter the value to filter by: " filterVal

                    duplicateCheck=$(awk -F: -v pkCol="$pkCol" -v newValue="$newValue" \
                        '$pkCol == newValue' "$TBname")
                    if [[ -n $duplicateCheck ]]; then
                        echo "Error: The new primary key value '$newValue' already exists in another row."
                    else
                        
                        awk -F: -v filterCol="$filterCol" -v filterVal="$filterVal" -v updateCol="$updateCol" \
                            -v newValue="$newValue" 'BEGIN {OFS=":"} $filterCol == filterVal {$updateCol = newValue} {print $0}' \
                            "$TBname" > tempFile && mv tempFile "$TBname"
                        echo "Table updated successfully."
                    fi
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
