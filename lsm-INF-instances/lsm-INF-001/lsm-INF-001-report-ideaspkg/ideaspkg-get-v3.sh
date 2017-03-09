#!/bin/bash
# define some VARS"
day=$(date +"%d")
month=$(date +"%m")
year=$(date +"%Y")
download_folder=$year$month$day
download_path="/usr/local/ideaspkg_root/"
excl_file_suffix="_09.csv.FIN"
JobLogFile="$download_path/ftp_get.log"
StartTime=$(date '+%Y-%m-%d:%H:%M:%S')


#VARs testing
echo "=====================================================================" >> $JobLogFile
echo "Starting ftp get job for Ideas-Package at $StartTime (GMT)." >> $JobLogFile
echo "The download folder is $download_folder." >> $JobLogFile
echo "The complete download path is $download_path$download_folder." >> $JobLogFile

# model
#ideas/amdocs/20170302/*o3 --password='=M>1j:#oQG' ftp://189.254.103.152/paquetes--More--(28%)

if [ $# -eq 0 ]
        then
                echo "No arguments supplied, download_path VAR remains without any changes." >> $JobLogFile
        else
                download_folder=$1;
                echo "Argument supplied is $1, saved in download_folder VAR." >> $JobLogFile
                echo "Complete download_path is $download_path$download_folder" >> $JobLogFile
fi

#echo "The complete download path is NOW $download_path$download_folder"

if [ ! -d "$download_path$download_folder" ]; then
                # For test purpouses
                echo "Folder $download_path$download_folder does not exists. Creating it ..."; >> $JobLogFile
                /bin/mkdir $download_path$download_folder;
                /bin/mkdir $download_path$download_folder/Excluded;
     		wget --user=PIservicio3 --password='=M>1j:#oQG' -P $download_path$download_folder ftp://189.254.103.152/paquetesideas/amdocs/$download_folder/*

                # test test test
                echo $download_path$download_folder/$download_folder$excl_file_suffix >> $JobLogFile
                        if [ -f "$download_path$download_folder/$download_folder$excl_file_suffix" ]; then
                                echo "Region 09 file found, moving it to Exclude folder." >> $JobLogFile
                                /bin/mv "$download_path$download_folder/$download_folder$excl_file_suffix" "$download_path$download_folder/Excluded/"
                        fi
        else
                echo "Folder elready exists, it is assumed that the job has been executed in the past. Bye bye folks!!" >> $JobLogFile
        fi
echo "Ending job Ideas-Package at $(date '+%Y-%m-%d:%H:%M:%S') (GMT)." >> $JobLogFile

