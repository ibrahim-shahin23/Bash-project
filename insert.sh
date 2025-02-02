#!/bin/bash
while true; do
if [[ ! "$(ls -A)" ]]; then
    dialog --msgbox "There are no tables to insert into." 10 50
    break
else
    # Ask user to enter table name using dialog
    TBname=$(dialog --inputbox "Please Enter Table Name:" 10 50 3>&1 1>&2 2>&3)
	exit_status=$?
    if [[ $exit_status -eq 1 ]]; then
        # User selected "Cancel," exit the loop
        break
    fi
    if [[ -z $TBname ]]; then
        dialog --msgbox "Invalid Table name." 10 50
    else
        if [[ -e $TBname ]]; then
            while true; do
                columnSize=$(wc -l .$TBname-metadata | cut -d" " -f1)
                data=""
                for ((i=0; i<columnSize; i++)); do
                    line=$(sed -n "$(echo $((i+1)))p" .$TBname-metadata)
                    colName=$(echo $line | cut -d: -f1)
                    colType=$(echo $line | cut -d: -f2)
                    colPkCheck=$(echo $line | cut -d: -f3)
                    
                    # Prompt user for a value for the column using dialog
                    val=$(dialog --inputbox "Please enter a value for $colName:" 10 50 3>&1 1>&2 2>&3)
					    exit_status=$?
    					if [[ $exit_status -eq 1 ]]; then
    					    # User selected "Cancel," exit the loop
    					    break 2
    					fi
                    
                    if [[ -z $val ]]; then
                        dialog --msgbox "Please enter a valid value." 10 50
                        i=$((i-1))
                        continue
                    fi
                    
                    # Check if primary key value already exists
                    if [[ $colPkCheck == "pk" ]]; then
                        if [[ $(grep -c "$val:" $TBname) -ne 0 ]]; then
                            dialog --msgbox "Primary key value already exists. Please enter a unique value." 10 50
                            i=$((i-1))
                            continue
                        fi
                    fi
                    
                    # Validate the value based on the column type
                    if [[ $colType == "int" && ! $val =~ ^[0-9]+$ ]]; then
                        dialog --msgbox "Invalid value. Please enter an integer." 10 50
                        i=$((i-1))
                        continue
                    elif [[ $colType == "string" && ! $val =~ ^[a-zA-Z0-9_]+$ ]]; then
                        dialog --msgbox "Invalid value. Please enter a string." 10 50
                        i=$((i-1))
                        continue
                    else
                        data+=$val:
                    fi
                done
                
                # Insert the data into the table
                echo $data >> $TBname
                dialog --msgbox "Data is inserted successfully!" 10 50
                
                # Ask user if they want to insert again
                dialog --yesno "Do you want to insert again in $TBname table? (yes/y):" 10 50 
                if [[ $? -eq 0 ]]; then
                    continue
                else
                    break
                fi
            done
        else
            dialog --msgbox "$TBname table doesn't exist." 10 50
        fi
    fi
fi
done
