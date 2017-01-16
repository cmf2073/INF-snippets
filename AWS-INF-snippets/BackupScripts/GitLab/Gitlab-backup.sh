#!/bin/bash

## Setting up variables
NOW=$(date )
NOW_Year=$(date +"%Y")

LogFile=/opt/scripts/gitlab_bkup.log
gitlab_s3bucket="s3://s3bucket002-gitlab/"
gitlab_source="/var/opt/gitlab/backups/"
#gitlab_source="/home/ubuntu/test_folder/"
### gitlab_dest_folder="gitlab-2014"
#gitlab_dest_folder="gitlab-2016"
gitlab_dest_folder="gitlab-$NOW_Year"
gitlab_uploaded="/var/opt/gitlab/backups-ok/"

# Print some lines to define LOG starting area.
echo "............................................................................................" >> $LogFile
echo "-.-.-...-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-." >> $LogFile
echo "START --------------------------------------------------------------------------------------" >> $LogFile
echo "////////////////////////////////////////////////////////////////////////////////////////////"  >> $LogFile
echo "$NOW - Starting Job - Sending gitlab content to S3-bucket." >> $LogFile

### Clean temp retention folder if NOT empty
if [ "$(ls -A "$gitlab_uploaded")" ]; then
        echo "$gitlab_uploaded is not Empty. Deleting files from retention folder." >> $LogFile
        sudo /bin/rm $gitlab_uploaded*
else
        echo "$gitlab_uploaded is Empty. Nothing to do." >> $LogFile
fi


### Move backup files to S3 if the repo is NOT empty
if [ "$(ls -A "$gitlab_source")" ]; then
        echo "----------------------------------------------------------------------------------------"  >> $LogFile
        echo "- -Good News!! $gitlab_source is not Empty. Moving NEW backup files to S3bucket." >> $LogFile
        for i in $gitlab_source*; do
        echo "Moving $i to $gitlab_s3bucket$gitlab_dest_folder" >> $LogFile
        /usr/bin/s3cmd put $i $gitlab_s3bucket$gitlab_dest_folder/
        sudo /bin/mv $i $gitlab_uploaded
        done
else
        echo "- -WARNING!! $gitlab_source is empty. Nothing to do. Bye." >> $LogFile
fi



                #for i in $gitlab_source*; do
                #/usr/bin/s3cmd put $i s3://s3bucket002-gitlab/$gitlab_dest_folder/
                #sudo /bin/mv $i $gitlab_uploaded
                #done

# Print some lines to the end of the LOG process.
echo "$(date) - Ended backup Job - Desination AWS-bucket is $gitlab_s3bucket$gitlab_dest_folder." >> $LogFile
echo "======================================================================================== END" >> $LogFile
