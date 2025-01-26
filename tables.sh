select var in CreateTable DropTable ListTables InsertIntoTable SelectFromTable goBack DeleteFromTable UpdateTable
do
	case $var in
	"CreateTable")
		source ~/Downloads/bash/Bash-project/createTable.sh
	;;
	"DropTable")
		source ~/Downloads/bash/Bash-project/dropTable.sh
	;;
	"goBack")
		source ~/Downloads/bash/Bash-project/database.sh
	;;
	"ListTables")
        ls ~/Downloads/bash/Bash-project/DBMS/$DB_name
		source ~/Downloads/bash/Bash-project/tables.sh 
    ;;
	"InsertIntoTable")
		source ~/Downloads/bash/Bash-project/insert.sh
	;;
	"SelectFromTable")
		source ~/Downloads/bash/Bash-project/select.sh
	;;
	"DeleteFromTable")
	    source ~/Downloads/bash/Bash-project/delete.sh			    
	;;
	"UpdateTable")
		source ~/Downloads/bash/Bash-project/update.sh
	;;
	*)
	echo invalid input
	esac
done