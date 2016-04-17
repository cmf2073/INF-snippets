#!/bin/bash

AWSAK=`grep awsak certs/ci.file | cut -c7-26`
AWSSAK=`grep awssak certs/ci.file | cut -c8-48`

## Print values just to see what you get
#echo $AWSAK
#echo $AWSSAK

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export AWS_REGION=us-west-1
export AWS_ACCESS_KEY_ID=$AWSAK
export AWS_SECRET_ACCESS_KEY=$AWSSAK
