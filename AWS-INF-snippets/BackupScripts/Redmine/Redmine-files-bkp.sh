#!/bin/bash

## Fuentes del sync
redmine_source="/opt/redmine-2.5.2/files/"
design_source="/var/www/design.lms.mx/public/"


## Destinos del sync en AWS-S3 bucket
redmine_day_folder="Redmine-Backup-"$(date +%A)
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
echo " === $start1 - Comienza la copia de seguridad de archivos de Redmine de $redmine_source a $redmine_day_folder ."

/usr/bin/s3cmd sync --delete-removed $redmine_source s3://s3bucket001-redmine/$redmine_day_folder/


## Linea para log
start2=$(date)
echo " === $start2 - Comienza la copia de seguridad de archivos de design.lsm.com de $design_source a $design_day_folder ."

/usr/bin/s3cmd sync --delete-removed $design_source s3://s3bucket001-redmine/$design_day_folder/

