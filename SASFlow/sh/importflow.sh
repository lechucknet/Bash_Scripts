#!/bin/sh
DIALOG="/home/sas/SASFlow/dependencies/dialog/usr/bin/dialog"


#
. /home/sas/SASFlow/connection.profile
. /home/sas/SASFlow/logs/changelog.txt
# Connection profile selection
# Pause Function

function pause(){
   read -p "$*"
}

FILE=`$DIALOG --backtitle "##### SAS Flow Activator V$VERSION - Movistar Argentina #####" --stdout --title "Choose a Package to Import - Select with SPACEBAR" --fselect /home/sas/ 25 80`

case $? in
    0)
	echo "\"$FILE\" chosen";;
    1)
	echo "Cancel pressed.";;
    255)
	echo "Box closed.";;
esac

/sas/SASHome/SASPlatformObjectFramework/9.4/ImportPackage -profile $PROFILE -package $FILE -target / -noexecute -preservePaths | tee -a /home/sas/SASFlow/logs/import.log | $DIALOG --colors --title "Importing $FILE Package to Metadata" --backtitle "##### SAS Flow Activator V0.22 - Movistar Argentina ##### " --programbox 45 110

