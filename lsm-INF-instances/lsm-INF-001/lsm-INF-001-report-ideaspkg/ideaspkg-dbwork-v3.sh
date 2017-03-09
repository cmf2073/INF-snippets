#!/usr/bin/env bash

#/Users/pulman/Documents/pablo.ulman/Documentos/Paquete-Ideas/proceso/amdocs/$CARPETAINPUT

#Added by CmF - VARS
MySQL_host=warehouse.curltregdpc1.sa-east-1.rds.amazonaws.com
MySQL_port=3806
MySQL_USR=dbclaro_usr
MySQL_ID=u7QbSmPXz

ideaspkg_path="/usr/local/ideaspkg_root/"
JobLogFile="$ideaspkg_path/ideaspkg_dbwork.log"
StartTime=$(date '+%Y-%m-%d:%H:%M:%S')

output_Total=0
output_Fltr=0
output_TotalFinal=0

mail_from="Ideas-Package-BOT"
mail_to="carlos.farina@claroviajes.com,manuk@cmfonline.com.ar"
mail_subj="Push Travel-MX | Ideas-Package@$ANO_YYY-$MES-$DIA"
mail_attach="$ideaspkg_path$CARPETAINPUT$ARCHIVO1 $ideaspkg_path$CARPETAINPUT$ARCHIVO2"
mail_body_text=" Estimados,\n\
les comparto la informacion referente al flujo Ideas-Package@$ANO_YYY-$MES-$DIA.\n\
\n\
- Fecha: $ANO_YYY-$MES-$DIA. \n\
- Total recibidos: $output_Total. \n\
- Filtrados: $output_Fltr. (exceptuados por blacklist).\n\
- Total final: $output_TotalFinal.\n\
\n\
Se adjuntan:\n\
- $ARCHIVO1.csv\n\
- $ARCHIVO2.csv\n\
\n\
Se entienfe por SVA, Servicio Valor Agregado. El archivo que contenga dicha sigla sera el que contiene los números adicionales encargados del control del servicio\n\
El archivo sin estas siglas será el que NO contenga estos números, lo cual corresponde a la cantidad de líneas descriptas másiba.\n\
\n\
Saludos cordiales.\n\
CmF"



# Legacy VARS - customized
clear
DIA=$(date +"%d")
MES=$(date +"%m")
ANO_YY=$(date +"%y")
ANO_YYYY="20"$ANO_YY

# Test VARs
echo "Default values are:"
echo "DIA=$DIA"
echo "MES=$MES"
echo "ANO_YY=$ANO_YY"
echo "ANO_YYYY=$ANO_YYYY"

#VARs testing
echo "=====================================================================" >> $JobLogFile
echo "Starting ftp get job for Ideas-Package at $StartTime (GMT)." >> $JobLogFile

# Sense if the job has been lauched with date/time modifier VAR
if [ $# -eq 0 ]
        then
                echo "No arguments supplied, Day-Month-Year VARs remain without any changes." >> $JobLogFile
		echo "Current Day/Time VARs are Y2=$ANO_YY Y4=$ANO_YYYY M=$MES D=$DIA" >> $JobLogFile
        else
                echo "Day/Time argument supplied is $1, saved in date/time VARs." >> $JobLogFile
                DIA=${1:6:2}
                MES=${1:4:2}
                ANO_YY=${1:2:2}
                ANO_YYYY=${1:0:4}
                echo "Current Day/Time VARs are Y2=$ANO_YY Y4=$ANO_YYYY M=$MES D=$DIA" >> $JobLogFile
fi

#Stopper 1
#exit 1

#
# Variables utilizadas en el Script 
# (Ejemplo)
#
#CARPETAINPUT=20160915
#TABLA=ideas_20160915
#ARCHIVO1=Lista_150916
#ARCHIVO2=Lista_150916_SVA
#BLACK=blacklist_20160204

CARPETAINPUT=$ANO_YYYY$MES$DIA
TABLA="ideas_"$CARPETAINPUT
ARCHIVO1="Lista_"$DIA$MES$ANO_YY
ARCHIVO2=$ARCHIVO1"_SVA"
BLACK=blacklist_20161019
#
#BLACKOLD=blacklist_20160930
#BLACKOLD1=blacklist_20160204
#

echo '---------------------------------------------------------------------'
echo '---  Importacion de Archivos PAQUETE IDEAS ('$CARPETAINPUT'_XX.csv.FIN)  ---'
echo '---                                                               ---'
echo '---                                                               ---'
echo '--- Carpeta INPUT       : '$CARPETAINPUT'                                ---'
echo '--- Tabla a Crear       : '$TABLA'                          ---'
echo '--- Archivo Output      : '$ARCHIVO1'                            ---'
echo '--- Archivo Output (SVA): '$ARCHIVO2'                        ---'
echo '--- BackList Utilizada  : '$BLACK'                      ---'
echo '---                                                               ---'
echo '---                                                               ---'
echo '---------------------------------------------------------------------'

echo
read -n 1 -s -p "Press any key to continue"
echo

#Stopper 2
#exit 1

#
#	Elimino la Tabla
#
echo '-------------------------------'
echo '--- Begin: Elimino la Tabla ---'
echo '-------------------------------'
echo 
#mysql -u root -pMercurio2016 -e "use DBclaro;DROP TABLE IF EXISTS $TABLA;"
mysql -h$MySQL_host -u$MySQL_USR -p$MySQL_ID -P$MySQL_port -e "use DBclaro;DROP TABLE IF EXISTS $TABLA;"
echo '-------------------------------'
echo '--- End: Elimino la Tabla   ---'
echo '-------------------------------'
#echo
read -n 1 -s -p "Press any key to continue"
#echo
mysql -h$MySQL_host -u$MySQL_USR -p$MySQL_ID -P$MySQL_port -e "SET GLOBAL TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;"

#Stopper 3
#exit 1

#
#	Creacion de la tabla; TENER EN CUENTA LA TABLA A CREAR.
#
echo '-------------------------------'
echo '--- Begin: Creo la Tabla    ---'
echo '-------------------------------'
mysql -h$MySQL_host -u$MySQL_USR -p$MySQL_ID -P$MySQL_port -e "use DBclaro;CREATE TABLE $TABLA (addd VARCHAR(250) NOT NULL,texto VARCHAR(250) NOT NULL,phoneNumber VARCHAR(12) NOT NULL,phoneNumber52 VARCHAR(12) NOT NULL,sms VARCHAR(250) NOT NULL,status VARCHAR(10) NOT NULL, PRIMARY KEY (phoneNumber), KEY (phoneNumber52)) ENGINE=InnoDB DEFAULT CHARSET=utf8;"
echo '-------------------------------'
echo '--- End: Creo la Tabla      ---'
echo '-------------------------------'
#echo
read -n 1 -s -p "Press any key to continue"
#echo

#Stopper 4
#exit 1

#
# Ruta donde se encuentra el conteo de archivos dentro de DB Claro
#
echo '--------------------------------------'
echo '--- Begin: Importacion de Archivos ---'
echo '--------------------------------------'

# Modified by CmF
##cd /Users/pulman/Documents/pablo.ulman/Documentos/Paquete-Ideas/proceso/amdocs/$CARPETAINPUT   
cd $ideaspkg_path$CARPETAINPUT
echo $ideaspkg_path$CARPETAINPUT
#Stopper 5
#exit 1


#for f in */*.csv.FIN
for f in *.csv.FIN
	do
		echo 'Importando: ['"$f"']'
		mysql -h$MySQL_host -u$MySQL_USR -p$MySQL_ID -P$MySQL_port -e "use DBclaro;LOAD DATA LOCAL INFILE '"$ideaspkg_path$CARPETAINPUT"/"$f"' IGNORE INTO TABLE DBclaro.$TABLA FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n' (addd, texto, phoneNumber, status,sms);"
		echo 
	done
echo '--------------------------------------'
echo '--- End: Importacion de Archivos   ---'
echo '--------------------------------------'
#echo
read -n 1 -s -p "Press any key to continue"
#echo

#
# Actualizacion del campo phoneNumber52
#
echo '--------------------------------------'
echo '--- Begin: Update phoneNumber52    ---'
echo '--------------------------------------'
mysql -h$MySQL_host -u$MySQL_USR -p$MySQL_ID -P$MySQL_port -e "use DBclaro;UPDATE $TABLA SET phoneNumber52 = CONCAT('52', phoneNumber) ;"

echo '--------------------------------------'
echo '--- End: Update phoneNumber52      ---'
echo '--------------------------------------'
echo
read -n 1 -s -p "Press any key to continue"
echo

clear
echo '------------------------------------------------------------'
echo '--- RESULTADO ----------------------------------------------'
echo '------------------------------------------------------------'

sleep 1
#
# registros recibidos.
#
echo 'Se recibieron (X) numeros de telefonos excluyendo Region 9:'
mysql -h$MySQL_host -u$MySQL_USR -p$MySQL_ID -P$MySQL_port -e  "use DBclaro;SELECT count(phoneNumber) FROM $TABLA;"

#		
#Filtrado de registros; TENER EN CUENTA LA TABLA A FILTRAR
#
#exit 0
echo 'Se filtaron:'
#mysql -u root -pMercurio2016 -e  "use DBclaro;DELETE FROM DBclaro.$TABLA where CONCAT('52', phoneNumber) IN (SELECT phoneNumber FROM DBclaro.$BLACK) OR phoneNumber like '55%' OR phoneNumber IN (SELECT phoneNumber FROM DBclaro.blackmanual);SELECT row_count();"
echo
echo "DELETE FROM $TABLA where phoneNumber like '55%' and length(phoneNumber)>=10;"
mysql -h$MySQL_host -u$MySQL_USR -p$MySQL_ID -P$MySQL_port -e  "use DBclaro;DELETE FROM $TABLA where phoneNumber like '55%' and length(phoneNumber)>=10;SELECT row_count();"

echo
echo "DELETE FROM $TABLA where phoneNumber IN (SELECT phoneNumber FROM DBclaro.blackmanual);"
mysql -h$MySQL_host -u$MySQL_USR -p$MySQL_ID -P$MySQL_port -e  "use DBclaro;DELETE FROM $TABLA where phoneNumber IN (SELECT phoneNumber FROM DBclaro.blackmanual);SELECT row_count();"

echo
#echo "DELETE FROM $TABLA where phoneNumber52 IN (SELECT phoneNumber FROM $BLACK) LIMIT 100;"
#mysql -u root -pMercurio2016 -e  "use DBclaro;DELETE FROM $TABLA where phoneNumber52 IN (SELECT phoneNumber FROM $BLACK);SELECT row_count();"
echo "use DBclaro;DROP TEMPORARY TABLE IF EXISTS ideas_delete;CREATE TEMPORARY TABLE ideas_delete LIKE $TABLA;INSERT INTO ideas_delete SELECT * FROM $TABLA WHERE phoneNumber52 IN (SELECT phoneNumber FROM $BLACK);DELETE FROM $TABLA WHERE phoneNumber IN (SELECT phoneNumber FROM ideas_delete);SELECT row_count();"
mysql -h$MySQL_host -u$MySQL_USR -p$MySQL_ID -P$MySQL_port -e  "use DBclaro;DROP TEMPORARY TABLE IF EXISTS ideas_delete;CREATE TEMPORARY TABLE ideas_delete LIKE $TABLA;INSERT INTO ideas_delete SELECT * FROM $TABLA WHERE phoneNumber52 IN (SELECT phoneNumber FROM $BLACK);DELETE FROM $TABLA WHERE phoneNumber IN (SELECT phoneNumber FROM ideas_delete);SELECT row_count();"

#delete from $TABLA where phoneNumber IN (select phoneNumber from blackmanual);select row_count();"
	
echo 'Quedaron:'
mysql -h$MySQL_host -u$MySQL_USR -p$MySQL_ID -P$MySQL_port -e  "use DBclaro;SELECT count(phoneNumber) FROM $TABLA;"
echo 

#
#	echo 'Los reportes se exportaran en: /var/lib/mysql/DBclaro/Reportes/ \n '
#
echo '------------------------------------------------------------'
echo '--- EXPORTANDO INFORMACION ---------------------------------'
echo '------------------------------------------------------------'
TIMENOW=$(date +"%H.%M.%S")
#mysql -u root -pMercurio2016 -e  "use DBclaro;SELECT (phonenumber) FROM $TABLA INTO outfile '/tmp/$ARCHIVO1-$TIMENOW.csv' LINES TERMINATED BY '\n';"	
#mysql -u root -pMercurio2016 -e  "use DBclaro;SELECT a.phoneNumber FROM $TABLA a UNION SELECT phoneNumber FROM numeros b INTO outfile '/tmp/$ARCHIVO2-$TIMENOW.csv' LINES TERMINATED BY '\n';"	
#
#echo 'Se generarion los Archivos:'
#echo "/tmp/$ARCHIVO1-$TIMENOW.csv"
#echo "/tmp/$ARCHIVO2-$TIMENOW.csv"
## By Cmf -- old lines
##echo "use DBclaro;SELECT (phonenumber) FROM $TABLA INTO outfile '/tmp/$ARCHIVO1.csv' LINES TERMINATED BY '\n';"	
##mysql -h$MySQL_host -u$MySQL_USR -p$MySQL_ID -P$MySQL_port -e  "use DBclaro;SELECT (phonenumber) FROM $TABLA INTO outfile '/tmp/$ARCHIVO1.csv' LINES TERMINATED BY '\n';"
##echo "use DBclaro;SELECT a.phoneNumber FROM $TABLA a UNION SELECT phoneNumber FROM numeros b INTO outfile '/tmp/$ARCHIVO2.csv' LINES TERMINATED BY '\n';"
##mysql -h$MySQL_host -u$MySQL_USR -p$MySQL_ID -P$MySQL_port -e  "use DBclaro;SELECT a.phoneNumber FROM $TABLA a UNION SELECT phoneNumber FROM numeros b INTO outfile '/tmp/$ARCHIVO2.csv' LINES TERMINATED BY '\n';"	

## New lines by CmF
##echo "use DBclaro;SELECT (phonenumber) FROM $TABLA INTO outfile '/tmp/$ARCHIVO1.csv' LINES TERMINATED BY '\n';"
mysql -N -h$MySQL_host -u$MySQL_USR -p$MySQL_ID -P$MySQL_port -e "use DBclaro;SELECT (phonenumber) FROM $TABLA;" > $ideaspkg_path$CARPETAINPUT/$ARCHIVO1.csv
##echo "use DBclaro;SELECT a.phoneNumber FROM $TABLA a UNION SELECT phoneNumber FROM numeros b INTO outfile '/tmp/$ARCHIVO2.csv' LINES TERMINATED BY '\n';"
mysql -N -h$MySQL_host -u$MySQL_USR -p$MySQL_ID -P$MySQL_port -e "use DBclaro;SELECT a.phoneNumber FROM $TABLA a UNION SELECT phoneNumber FROM numeros b;" > $ideaspkg_path$CARPETAINPUT/$ARCHIVO2.csv


echo 'Se generarion los Archivos:'
echo "$ideaspkg_path$CARPETAINPUT/$ARCHIVO1.csv"
echo "$ideaspkg_path$CARPETAINPUT/$ARCHIVO2.csv"
#echo "/tmp/$ARCHIVO1-$TIMENOW.csv"
#echo "/tmp/$ARCHIVO2-$TIMENOW.csv"

mysql -h$MySQL_host -u$MySQL_USR -p$MySQL_ID -P$MySQL_port -e "SET GLOBAL TRANSACTION ISOLATION LEVEL REPEATABLE READ;"

#
#	echo 'Archivos exportados \n'
#
#echo 'Proceso Finalizado.\n'


# =====================================================
# =====================================================

# If files exists both files !!! then



echo $mail_body_text | mutt -s $mail_subj -a$mail_attach --$mail_to












echo '------------------------------------------------------------'
echo '--- FIN ----------------------------------------------------'
echo '------------------------------------------------------------'
