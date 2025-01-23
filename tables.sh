select var in CreateTable DropTable ListTables InsertIntoTable SelectFromTable goBack DeleteFromTable UpdateTable
do
	case $var in
	"CreateTable")
		~/Downloads/bash/Bash-project/createTable.sh
	;;
	"DropTable")
		~/Downloads/bash/Bash-project/dropTable.sh
	;;
	"goBack")
		~/Downloads/bash/Bash-project/database.sh
		exit
	;;
	"ListTables")
        ls 
    ;;
	"InsertIntoTable")
		~/Downloads/bash/Bash-project/insert.sh
	;;
	"SelectFromTable")
		~/Downloads/bash/Bash-project/select.sh
	;;
	"DeleteFromTable")
	    ~/Downloads/bash/Bash-project/delete.sh			    
	;;
	"UpdateTable")
		~/Downloads/bash/Bash-project/update.sh
	;;
	*)
	echo invalid input
	esac
done