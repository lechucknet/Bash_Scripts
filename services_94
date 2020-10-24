#!/bin/bash
# Detencion / Inicio / Status Servicios - Control de Procesos
# SAS 9.4 Data Integration
# gonzalo.navarro@sas.com
# Los equipos Metadata, Compute y MidTier, deben tener llaves ssh passwordless.
# V.02

#### Variables Configurables Entorno ####
METADATA="metadata server hostname"
MIDTIER="mitied server hostname"
COMPUTE="compute server hostname"
ENVIRONMENT="/sas/config/Lev1"
MAIL_SENDER="mail sender"
MAIL_RECV="mail to receive"
SMTP="10.1.33.64:25"
#########################################

SERVER="$ENVIRONMENT/sas.servers"
LOG_METADATA="$ENVIRONMENT/Logs/sas_metadata.log"
LOG_COMPUTE="$ENVIRONMENT/Logs/sas_compute.log"
LOG_MIDTIER="$ENVIRONMENT/Logs/sas_midtier.log"
LOG_SERVICES="$ENVIRONMENT/Logs/sas_services.log"
NOW=$(date)

# Case
case "$1" in

stop)   echo "Stopping SAS 9.4 - Metadata - Compute - Midtier Servers"
        # Connect, stop and bring me logs - LEV1 Desarrollo
        ssh $METADATA $SERVER stop
        ssh $MIDTIER $SERVER stop
        ssh $COMPUTE $SERVER stop
        sleep 15
        ssh $METADATA $SERVER status >> $LOG_METADATA && echo $NOW >> $LOG_METADATA
        ssh $MIDTIER $SERVER status >> $LOG_MIDTIER && echo $NOW >> $LOG_MIDTIER
        ssh $COMPUTE $SERVER status >> $LOG_COMPUTE && echo $NOW >> $LOG_COMPUTE

        # Check Logs, and give me status
        CHECK_METASTOP=$(tail -5 $LOG_METADATA | grep "NOT up" | wc -l) # must be 3
        CHECK_COMPSTOP=$(tail -10 $LOG_COMPUTE | grep "NOT up" | wc -l) # must be 8
        CHECK_MIDTSTOP=$(tail -15 $LOG_MIDTIER | grep "NOT up" | wc -l) # must be 14
        
        if [ $CHECK_METASTOP == 3 ] && [ $CHECK_COMPSTOP == 8 ] && [ $CHECK_MIDTSTOP == 14 ]; then
            echo "Servers Metadata, Midtier & Compute, stop: OK 0"
            echo "Servers Metadata, Midtier & Compute, stop: OK 0" >> $LOG_SERVICES
            exit 0
        else
            echo "Servers Metadata, Midtier & Compute, stop: ERROR 1"
            echo "$NOW Servers Metadata, Midtier & Compute, stop: ERROR 1" >> $LOG_SERVICES
            echo "Plataforma SAS 9.4 # Metadata:$COMPUTE #Computo: $COMPUTE, #Mid-Tier: $MIDTIER , Stop Incorrecto. ERROR $NOW" | mailx -v -r $MAIL_SENDER \
            -s "SAS Fraude | Stop Process SAS 9.4: ERROR 1" \
            -S smtp="$SMTP" \
            $MAIL_RECV
            exit 1
        fi
        ;;
        
start)  echo "Starting SAS 9.4 - Metadata - Compute - Midtier Servers"
        # Connect, start and bring me logs
        ssh $METADATA $SERVER start
        ssh $COMPUTE $SERVER start
        ssh $MIDTIER $SERVER start
        ssh $METADATA $SERVER status >> $LOG_METADATA && echo $NOW >> $LOG_METADATA
        ssh $COMPUTE $SERVER status >> $LOG_COMPUTE && echo $NOW >> $LOG_COMPUTE
        ssh $MIDTIER $SERVER status >> $LOG_MIDTIER && echo $NOW >> $LOG_MIDTIER

        # Check Logs, and give me status
        CHECK_METASTART=$(tail -5 $LOG_METADATA | grep "UP" | wc -l) # must be 3
        CHECK_COMPSTART=$(tail -10 $LOG_COMPUTE | grep "UP" | wc -l) # must be 8
        CHECK_MIDTSTART=$(tail -16 $LOG_MIDTIER | grep "UP" | wc -l) # must be 14

        if [ $CHECK_METASTART == 3 ] && [ $CHECK_COMPSTART == 8 ] && [ $CHECK_MIDTSTART == 14 ]; then
            echo "Servers Metadata, Midtier & Compute, start: OK 0"
            echo "$NOW Servers Metadata, Midtier & Compute, start: OK 0" >> $LOG_SERVICES
            exit 0
        else
            echo "Servers Metadata, Midtier & Compute, start: ERROR 1"
            echo "$NOW Servers Metadata, Midtier & Compute, start: ERROR 1" >> $LOG_SERVICES
            echo "Plataforma SAS 9.4 | Metadata:$METADATA - Computo: $COMPUTE - Mid-Tier: $MIDTIER , Inicio Incorrecto. ERROR $NOW" | mailx -v -r $MAIL_SENDER \
            -s "SAS Fraude | Start Process SAS 9.4: ERROR 1" \
            -S smtp="$SMTP" \
            $MAIL_RECV
            exit 1
        fi
        ;;

status) echo "Checking Status SAS 9.4 - Metadata - Compute - Midtier Servers"
        # Check status and print
        echo "Metadata: $METADATA"
        echo "Compute: $COMPUTE"
        echo "MidTier: $MIDTIER"
        echo "Environment: $ENVIRONMENT"
        ssh $METADATA $SERVER status
        ssh $COMPUTE $SERVER status
        ssh $MIDTIER $SERVER status
        ;;
        
*) echo "SAS 9.4 - Metadata - Compute - Midtier | Server Manager "
echo "Usage: ./services { start - stop - status }"
;;

esac
 
