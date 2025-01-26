# DBMS initialization

if [  ! -d "~/Downloads/bash/Bash-project/DBMS" ]
then 
	mkdir -p ~/Downloads/bash/Bash-project/DBMS 
fi

dialog --title "Welcome" --msgbox "Welcome to the Bash DBMS App!" 10 40
source ~/Downloads/bash/Bash-project/database.sh