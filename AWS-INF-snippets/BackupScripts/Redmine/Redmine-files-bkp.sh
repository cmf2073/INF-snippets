#!/bin/bash

## Fuentes del sync
redmine_source="/var/apps2/redmine_vol/root/files/"
design_source="/var/www/design.lms.mx/public/"


## Destinos del sync en AWS-S3 bucket
S3redmine_bucket="s3://s3sysadmin2/lsm-INF-001/redmine-bkups"
S3redmine_day_folder="Redmine-filerepo-bkup-"$(date +%A)
design_day_folder="Design-Backup-"$(date +%A)

## Test destinos sync
#echo $redmine_day_folder
#echo $design_day_folder

## Linea para log
start1=$(date)
echo " . "
echo " .. "
echo " ... "
echo " ========== ========== ========== ========== ========= "
echo " ========== ========== ========== ========== ========= "
echo " === $start1 - Starting backup of Redmine files Repo from $redmine_source to $S3redmine_bucket/$S3redmine_day_folder/."

/usr/bin/s3cmd sync --delete-removed $redmine_source $S3redmine_bucket/$S3redmine_day_folder/


## Linea para log
#start2=$(date)
#echo " === $start2 - Comienza la copia de seguridad de archivos de design.lsm.com de $design_source a $design_day_folder ."

#/usr/bin/s3cmd sync --delete-removed $design_source s3://s3bucket001-redmine/$design_day_folder/

