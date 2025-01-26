#!/bin/bash

while true; do
    # Input for table name
    TB_name=$(dialog --inputbox "Enter new table name:" 10 50 3>&1 1>&2 2>&3)
    
    # Check if user pressed "Cancel"
    exit_status=$?
    if [[ $exit_status -eq 1 ]]; then
        # User selected "Cancel," exit the loop
        break
    fi

    if [[ -z $TB_name || ! $TB_name =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
        dialog --msgbox "Invalid table name. Please use alphanumeric characters only." 10 50
    else
        if [[ -e $TB_name ]]; then
            dialog --msgbox "Table $TB_name already exists." 10 50
        else
            # Input for the number of columns
            while true; do
                colNum=$(dialog --inputbox "Enter number of columns:" 10 50 3>&1 1>&2 2>&3)
                exit_status=$?
                if [[ $exit_status -eq 1 ]]; then
                    # User selected "Cancel," return to the table name prompt
                    break 2
                fi
                
                if [[ ! $colNum =~ ^[0-9]+$ || $colNum -le 0 ]]; then
                    dialog --msgbox "Invalid number of columns. Please enter a positive integer." 10 50
                else

                    flag=0

                    touch .$TB_name-metadata
                    for ((i=0; i<$colNum; i++)); do
                        # Input for column name
                        while true; do
                            colName=$(dialog --inputbox "Enter name of column $((i+1)):" 10 50 3>&1 1>&2 2>&3)
                            exit_status=$?
                            if [[ $exit_status -eq 1 ]]; then
                                # User selected "Cancel," exit column loop
                                break 4
                            fi

                            if [[ -z $colName || ! $colName =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
                                dialog --msgbox "Invalid column name. Please use alphanumeric characters only." 10 50
                            else
                                break 
                            fi
                        done
                        
                        # Input for data type
                        while true; do
                            datatype=$(dialog --inputbox "Enter data type for column $colName (e.g., int, string):" 10 50 3>&1 1>&2 2>&3)
                            exit_status=$?
                            if [[ $exit_status -eq 1 ]]; then
                                # User selected "Cancel," exit column loop
                                break 4
                            fi

                            if [[ -z $datatype || ! $datatype =~ ^(int|string)$ ]]; then
                                dialog --msgbox "Invalid data type. Use 'int' or 'string'." 10 50
                            else
                                break 
                            fi
                        done
                        
                        line="$colName:$datatype"
                        
                        # Ask if the column should be the primary key
                        if [[ $flag -eq 0 ]]; then
                            dialog --yesno "Make $colName the primary key for the table?" 10 50
                            if [ $? -eq 0 ]; then
                                line+=$(echo ":pk")
                                flag=1
                            fi
                        fi
                        # Write column metadata to the file
                        echo $line >> .$TB_name-metadata
                    done
                    
                    # Create the table file if everything is correct
                    if [[ $? -eq 0 ]]; then
                        touch $TB_name
                        dialog --msgbox "Table $TB_name created successfully!" 10 50
                        break
                    else
                        dialog --msgbox "Failed to create table file." 10 50
                    fi
                fi
            done
        fi
    fi
done
