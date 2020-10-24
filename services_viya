#!/bin/bash
# Detencion / Inicio / Status Servicios - Control de Procesos
# SAS Viya 3.5
# gonzalo.navarro@sas.com
# V.02

#### Variables Configurables Entorno ####
SERVER="10.1.1.98"
ANSIBLE="/usr/local/bin/ansible-playbook"
PLAYBOOK="/opt/sas/install/sas_viya_playbook"
MAIL_SENDER="10.1.1.98"
MAIL_RECV="mail@domain.com"
SMTP="10.1.33.64:25"
#########################################

LOG="$PLAYBOOK/services.log"
INVENTORY="$PLAYBOOK/inventory.ini"
STOP_PLAYBOOK="$PLAYBOOK/viya-ark/playbooks/viya-mmsu/viya-services-stop.yml -e enable_stray_cleanup=true"
START_PLAYBOOK="$PLAYBOOK/viya-ark/playbooks/viya-mmsu/viya-services-start.yml"
STATUS_PLAYBOOK="$PLAYBOOK/viya-ark/playbooks/viya-mmsu/viya-services-status.yml"
NOW=$(date)

# Case
case "$1" in

stop) echo "Stopping SAS Viya 3.5!... 10 Minutes aprox, to check status do: tail -f $LOG"
    $ANSIBLE $STOP_PLAYBOOK -i $INVENTORY >> $LOG
    STATUS_STOP=$(tail -5 $LOG | grep "failed=0" | wc -l)
    if [ $STATUS_STOP == 4 ]; then
        echo $NOW >> $LOG
        echo "Stop process: OK 0"
        echo "Stop process: OK 0" >> $LOG
        exit 0
    else
        echo $NOW >> $LOG
        echo "Stop Process: ERROR 1"
        echo "Stop Process: ERROR 1" >> $LOG
        echo "La plataforma SAS Viya $SERVER, NO se detuvo. ERROR $NOW" | mailx -v -r $MAIL_SENDER \
        -s "SAS Fraude | Stop Process SAS Viya: ERROR 1" \
        -S smtp="$SMTP" \
        $MAIL_RECV
        exit 1
    fi
    ;;

start) echo "Starting SAS Viya 3.5... 1 hour aprox, to check status do: tail -f $LOG"
    $ANSIBLE $START_PLAYBOOK -i $INVENTORY >> $LOG
    STATUS_START=$(tail -5 $LOG | grep "failed=0" | wc -l)
    if [ $STATUS_START == 4 ]; then
        echo $NOW >> $LOGNO Inicio correctamente
        echo "Start process: OK 0"
        echo "Start process: OK 0" >> $LOG
        exit 0
    else
        echo $NOW >> $LOG
        echo "Start Process: ERROR 1"
        echo "Start Process: ERROR 1" >> $LOG
        echo "La plataforma SAS Viya $SERVER, Inicio de modo Incorrecto. ERROR $NOW" | mailx -v -r $MAIL_SENDER \
        -s "SAS Fraude | Start Process SAS Viya: ERROR 1" \
        -S smtp="$SMTP" \
        $MAIL_RECV
        exit 1
    fi
    ;;

status) echo " Status SAS Viya 3.5"
        $ANSIBLE $STATUS_PLAYBOOK -i $INVENTORY
        ;;

*) echo "SAS Viya 3.5 | Server Manager "
echo "Usage: ./services { start - stop - status }"
;;

esac
