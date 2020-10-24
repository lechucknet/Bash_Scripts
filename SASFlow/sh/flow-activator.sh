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
BATCH_ACTIVATOR="/sas/SASHome/SASDecisionServicesServerConfiguration/6.3/BatchActivator"
LIST_FLOWS="/sas/SASHome/SASDecisionServicesServerConfiguration/6.3/BatchActivator  -profile $PROFILE -l"
ACTIVATE_FLOWS="/sas/SASHome/SASDecisionServicesServerConfiguration/6.3/BatchActivator -a -o -profile $PROFILE -f /home/sas/SASFlow/flows -log /home/sas/SASFlow/logs/activate.log"
DEACTIVATE_FLOWS="/sas/SASHome/SASDecisionServicesServerConfiguration/6.3/BatchActivator -d -profile $PROFILE -f /home/sas/SASFlow/flows -o -log /home/sas/SASFlow/logs/deactivate.log"
IMPORT_PKG="/home/sas/SASFlow/importflow >> /home/sas/SASFlow/logs/import.log"
EXPORT_PKG=""
PROGRAM_VERSION="##### SAS Flow Activator v$VERSION - Movistar Argentina #####"
LOGS_DIR="/home/sas/SASFlow/logs/"
LOG_BEGIN="echo #################### THIS LOG WAS CREATED $(date) ####################"
LOG_END="echo #################### END of LOG $(date) ####################"
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

funcheck=($DIALOG --colors --title " SAS Flow Activator " --backtitle "$PROGRAM_VERSION" \

--separate-output --colors --checklist "   								           	
# SERVER: $HOSTNAME 

* Decision Flows: Activate / Deactivate / List Active
* Metadata: Import *.spk Packages								    

                       * Press Spacebar to Select *
"  22 80 20 )
 
# Define screen functions, ON or OFF


opciones=(CONNECTION-PROFILE "Edit default Connection Profile" off
SET-FLOWS "Set flows want to activate (text-file)" off
 LIST-FLOWS "List all active Decision Flows" off
 IMPORT "Import Package to Metadata" off
 #EXPORT "Export Package from Metadata" off
 DEACTIVATE "Deactivate flows choosen on SET-FLOWS" off
 ACTIVATE "Activate flows choosen on SET-FLOWS" off
 LOGS "Check SASFlow Logs" off
 HELP "Help, how-to and Changelog" off
 EXIT "-> Quit SASFlow" off)
 
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
 
 CONNECTION-PROFILE)
 echo "##### Editing Metadata Connection Profile #####" && mcedit /home/sas/SASFlow/connection.profile
 ;; 
 SET-FLOWS)
 echo "##### Setting SAS Flows to activate #####" && mcedit /home/sas/SASFlow/flows 
 ;;
 LIST-FLOWS)
 echo "##### Listing Active Flows... #####" && $LOG_BEGIN >> $LOGS_DIR/flowlist.log &&$LIST_FLOWS | tee -a /home/sas/SASFlow/logs/flowlist.log | $DIALOG --title " Active Decision Flows LIST " --backtitle "$PROGRAM_VERSION" --programbox 45 110 && $LOG_END >> $LOGS_DIR/flowlist.log
 ;;
 IMPORT)
 echo "##### Select *.spk Package to import on Metadata #####" && $IMPORT_PKG 
 ;;
 DEACTIVATE)
 echo "##### Deactivating Selected Flows... #####" && $LOG_BEGIN >> $LOGS_DIR/deactivate.log && $DEACTIVATE_FLOWS | $DIALOG --title " Deactivating Selected Decision Flows... " --backtitle "$PROGRAM_VERSION" --programbox 40 110 && $LOG_END >> $LOGS_DIR/deactivate.log
 ;;
 ACTIVATE)
 echo "##### Activating Selected Flows... #####" && $LOG_BEGIN >> $LOGS_DIR/activate.log && $ACTIVATE_FLOWS | $DIALOG --title " Activating Selected Decision Flows... " --backtitle "$PROGRAM_VERSION" --programbox 40 110 && $LOG_END >> $LOGS_DIR/activate.log
 ;;
 LOGS)
 echo "##### Checking SASFlow Log Files #####" && /home/sas/SASFlow/selectlog
;;
 HELP)
 echo "##### Ayuda y comandos del script #####" && dialog --title " Help & Howto Use SAS Flow-Activator  " --colors \
--backtitle "##### SAS Flow Activator V0.1 - Movistar Argentina #####" --msgbox " 
    HELP 
" 40 80
 ;; 
 EXIT)
 echo "##### Going out of SAS Flow Activator...#####" && exit 0
 ;;
 esac
 
done 
done

 exit 
