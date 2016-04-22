source ../awsvars-ec2.sh

#export AWS_VPC_ID=vpc-055fe160
#export AWS_SECURITY_GROUP=sg-d6e278b3
#export AWS_SUBNET_ID=subnet-b2f0afd7

export AWS_SECURITY_GROUP=docker-machine-INF
export AWS_VPC_ID=vpc-f1cc0f94
export AWS_DEFAULT_REGION=us-west-2
export AWS_ZONE=a

docker-machine -D create --driver amazonec2 --amazonec2-root-size "200" --amazonec2-iam-instance-profile "aws-cloudwatch-logs-variables" $1
