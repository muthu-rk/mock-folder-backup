#!/bin/bash

STATUS_FILE_NAME="bkp_status.txt"
SOURCE_PATH="./logpath"
TARGET_PATH="./bkppath"

START_TIME=""
END_TIME=""
LAST_RUN_STATUS=""

while :
do
    if [ -e $STATUS_FILE_NAME ]
    then
        START_TIME=$(sed -n '1p' < $STATUS_FILE_NAME)
        END_TIME=$(sed -n '2p' < $STATUS_FILE_NAME)
        LAST_RUN_STATUS=$(sed -n '3p' < $STATUS_FILE_NAME)

        echo $START_TIME
        echo $END_TIME
        echo $LAST_RUN_STATUS

        if [[ "$LAST_RUN_STATUS" == "SUCCESS" ]]; then
            echo "LAST_RUN_STATUS is SUCCESS"
            START_TIME=$END_TIME

        elif [[ "$LAST_RUN_STATUS" == "IN_PROGRESS" ]]; then
            echo "LAST_RUN_STATUS is IN_PROGRESS"
            # This means, last copy failed. So, start the copy from previous START_TIME to current time.
        
        else
            echo "Invalid status: $LAST_RUN_STATUS. Exiting.."
            exit 1
        fi

        END_TIME=$(date +"%Y-%m-%d %T") # current time
        LAST_RUN_STATUS="IN_PROGRESS"

        cat /dev/null > $STATUS_FILE_NAME

        echo -e "$START_TIME" >> $STATUS_FILE_NAME
        echo -e "$END_TIME" >> $STATUS_FILE_NAME
        echo -e "$LAST_RUN_STATUS" >> $STATUS_FILE_NAME
        
        echo "ok"
    else
        # First time. Initialize.
        START_TIME=$(date --date="1 min ago" +"%Y-%m-%d %T") # 1 min ago
        echo -e "$START_TIME" >> $STATUS_FILE_NAME
        
        END_TIME=$(date +"%Y-%m-%d %T") # current time
        echo -e "$END_TIME" >> $STATUS_FILE_NAME

        LAST_RUN_STATUS="IN_PROGRESS"
        echo -e "$LAST_RUN_STATUS" >> $STATUS_FILE_NAME

        echo "nok"
    fi

    filesToCopy=$(find $SOURCE_PATH -type f -newermt "$START_TIME" ! -newermt "$END_TIME")
    echo "Start copying .."

    fileCount=$(echo $filesToCopy|wc -w)
    echo "No. of files to copy: $fileCount"

    for singleFile in $filesToCopy
    do
        #fileName=$(basename $singleFile)

        # Use rsync instead of cp.
        cp $singleFile $TARGET_PATH
    done

    sed -i '$ d' $STATUS_FILE_NAME 
    LAST_RUN_STATUS="SUCCESS"
    echo -e "$LAST_RUN_STATUS" >> $STATUS_FILE_NAME
    
    echo "Copy complete.."
    echo "Sleeping for 30s.."
    sleep 30
done