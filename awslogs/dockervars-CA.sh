#!/bin/bash

## Old code
#AWSAK=`grep awsak trec-sid.me | cut -c7-26`
#AWSSAK=`grep awssak trec-sid.me | cut -c8-48`
#echo $AWSAK
#echo $AWSSAK

### New code

#AK=$(grep VAR_ak certs/awslogs-ci.file | cut -f2 | rev | openssl enc -d -a -A -aes-256-cbc)
#SAK=$(grep VAR_sak certs/awslogs-ci.file | cut -f2 | rev | openssl enc -d -a -A -aes-256-cbc)



source ../awsvars-awslogs.sh

# Print VARs values usto for test purpouses
#echo $AWSAK
#echo $AWSSAK

# Export VARs for use
export AWS_ACCESS_KEY_ID=$AK
export AWS_SECRET_ACCESS_KEY=$SAK
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export AWS_REGION=us-west-1
