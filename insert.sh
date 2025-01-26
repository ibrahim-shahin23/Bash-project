if [[ ! "$(ls -A )" ]]; then
	echo "There's no tables to insert into"
else
	read -p "please Enter Table Name: " TBname
	if [[ -z $TBname ]]
	then
		echo invalid Table name
	else
		if [[ -e $TBname ]]
		then 
			while true; do
			columnSize=`wc -l .$TBname-metadata | cut -d" " -f1`
			data=""
			for ((i=0;i<columnSize;i++))
			do
				line=`sed -n "$(echo $((i+1)))p" .$TBname-metadata`
				colName=`echo $line | cut -d: -f1`
				colType=`echo $line | cut -d: -f2`
				colPkCheck=`echo $line | cut -d: -f3`
				read -p "please enter a value for $colName: " val
				if [[ -z $val ]]; then
					echo "enter a valid value."
					i=$((i-1))
					continue
				fi
				if [[ $colPkCheck == "pk" ]]
				then
					if [[ `grep -c "$val:" $TBname` -ne 0 ]]
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
			echo $data >> $TBname
			echo "Data is inserted successfully"
			read -p "do you want to insert again? (yes/y): " response
            if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
				continue
			else
				break
			fi
			done
		else
			echo "$TBname table is doesn\'t exist"
		fi
	fi
fi