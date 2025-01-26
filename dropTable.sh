if [[ ! "$(ls -A )" ]]; then
	echo "There's no tables to drop"
else
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
fi