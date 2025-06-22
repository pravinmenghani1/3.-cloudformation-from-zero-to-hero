#!/bin/bash

# Deploy nested stacks for VPC and EC2

STACK_NAME_PREFIX="nested-demo"
REGION="us-east-1"
KEY_PAIR="ekskp1"

echo "Deploying VPC Stack..."
aws cloudformation deploy \
  --template-file vpc-stack.yaml \
  --stack-name ${STACK_NAME_PREFIX}-vpc \
  --region ${REGION} \
  --capabilities CAPABILITY_IAM

echo "Waiting for VPC stack to complete..."
aws cloudformation wait stack-create-complete \
  --stack-name ${STACK_NAME_PREFIX}-vpc \
  --region ${REGION}

echo "Deploying EC2 Stack..."
aws cloudformation deploy \
  --template-file ec2-stack.yaml \
  --stack-name ${STACK_NAME_PREFIX}-ec2 \
  --region ${REGION} \
  --parameter-overrides VpcStackName=${STACK_NAME_PREFIX}-vpc KeyPairName=${KEY_PAIR} \
  --capabilities CAPABILITY_IAM

echo "Deployment complete!"
echo "Getting outputs..."
aws cloudformation describe-stacks \
  --stack-name ${STACK_NAME_PREFIX}-ec2 \
  --region ${REGION} \
  --query 'Stacks[0].Outputs'