#!/bin/bash
##
##  #### SAS FLOW ACTIVATOR V0.1 - 2018 - Buenos Aires, Argentina ####
##  THIS SCRIPT IS INTENDED TO IMPORT AND EXPORT METADATA PACKAGES
##  ALTHOUGH CAN ACTIVATE, DESACTIVATE OR LIST METADATA ACTIVE DECISION FLOWS
##
## 
##    
##
##  Script made by Gonzalo A. Navarro: gonzaloanavarro@gmail.com
##  

# Definitions
# Connection Profile invoke
. /home/sas/SASFlow/connection.profile
# Changelog invoke
. /home/sas/SASFlow/logs/changelog.txt
SO="$(uname -a)"
DIALOG="/home/sas/SASFlow/dependencies/dialog/usr/bin/dialog"
PROGRAM_VERSION="##### SAS Flow Activator v$VERSION - Movistar Argentina #####"
LOGS_DIR="/home/sas/SASFlow/logs"
# Pause Function

function pause(){
   read -p "$*"
}
 
# Loop Script  

while true :
do

# End
#
# Config Start screen

funcheck=($DIALOG --colors --title " Select the LOG File to Check! " --backtitle "$PROGRAM_VERSION" \

--separate-output --colors --checklist "   								           	
# It's possible to choose more than one.

                       * Press Spacebar to Select *
"  16 80 20 )
 
# Define screen functions, ON or OFF


opciones=(Activated "Check Activation Log's" off
 Deactivated "Check Deactivation Log's" off
 Flows "Check Listed Active Flows Log's" off
 Import "Check Package Import Log's" off
 Changelog "Take a look at Changelog" off
 BACK "-> GO Back to main menu" off)
 
# Create selection fuction 
# and resend options with for to termial to execute


selecciones=$("${funcheck[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

# Clean Display

clear

# Add a for to execute command in function of 
# the choosed options can change echo and  execute
# every command or secuence

for seleccion in $selecciones
do
 case $seleccion in 
 
 Activated) 
 echo "##### Checking Activation Logs #####" && mcedit $LOGS_DIR/activate.log
 ;; 
 Deactivated)
 echo "##### Checking Deactivation Logs #####" && mcedit $LOGS_DIR/deactivate.log 
 ;;
 Flows)
 echo "##### Checking Active Flows Logs #####" && mcedit $LOGS_DIR/flowlist.log  
 ;;
 Import)
 echo "##### Checking Package Import Logs #####" && mcedit $LOGS_DIR/import.log
 ;;
 Changelog)
 echo "##### Let's take a look at Changelog #####" && mcedit $LOGS_DIR/changelog.txt
 ;;
 BACK)
 echo "##### Going Back to Main Menu #####" && exit 0
 ;;
 esac
 
done 
done

 exit 
