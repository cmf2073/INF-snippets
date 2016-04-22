#!/bin/bash

### New code

AK=$(grep VAR_ak ../certs/ec2-ci.file | cut -f2 | rev | openssl enc -d -a -A -aes-256-cbc)
SAK=$(grep VAR_sak ../certs/ec2-ci.file | cut -f2 | rev | openssl enc -d -a -A -aes-256-cbc)

# Print VARs values usto for test purpouses
#echo $AWSAK
#echo $AWSSAK


# Export VARs for use

#export DOCKER_API_VERSION=1.22
export AWS_ACCESS_KEY_ID=$AK
export AWS_SECRET_ACCESS_KEY=$SAK
#export LC_ALL=en_US.UTF-8
#export LANG=en_US.UTF-8
#export AWS_REGION=us-west-1
#export AWS_ROOT_SIZE=200
export AWS_INSTANCE_TYPE=t2.micro
