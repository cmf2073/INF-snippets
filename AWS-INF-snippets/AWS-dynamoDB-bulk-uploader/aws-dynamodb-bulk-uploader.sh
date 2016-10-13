#!/bin/bash

#source ../../awsvars-ec2.sh

AK=$(grep VAR_ak ../../certs/ec2-ci.file | cut -f2 | rev | openssl enc -d -a -A -aes-256-cbc)
SAK=$(grep VAR_sak ../../certs/ec2-ci.file | cut -f2 | rev | openssl enc -d -a -A -aes-256-cbc)

export AWS_ACCESS_KEY_ID=$AK
export AWS_SECRET_ACCESS_KEY=$SAK
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
#export AWS_REGION=us-west-1
export AWS_DEFAULT_REGION=us-west-1

#dynamodb test access line
#aws dynamodb scan --table-name IdUrlMapping


# Uploader line
aws dynamodb batch-write-item --request-items file://$1
