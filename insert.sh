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
