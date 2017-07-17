#!/bin/bash
################################################################################
#
#
# enable
set -e

# enable debug
set -x

################################################################################
# Parameters
CF_TEMPLATE_FILE="./deployment/cf-beanstalk.json"
CF_CONFIG_FILE="./deployment/helloworld-conf.json"
REPO_NAME=`basename $(git remote show -n origin | grep Push | cut -d: -f2- | cut -d\. -f2)`

################################################################################
# Functions
file_exist() {
  local name="$1"
  if [ -f $CF_TEMPLATE ] ; then
    echo true
  else
    echo false
  fi
}

get_param() {
  local name="$1"
  cat $CF_CONFIG_FILE | jq -r --arg name $name '.[] | select(.ParameterKey == $name) | .ParameterValue'
}

bucket_exist() {
    local bucket="$1"
    local region="$2"
    if aws s3 ls s3://$bucket --region $region 2>&1 | grep -q "NoSuchBucket"; then
      echo false
    else
      echo true
    fi
}

cf_stack_exist() {
    local name="$1"
    local region="$2"
    if aws cloudformation describe-stacks \
      --stack-name ${name} \
      --region ${region} 2>&1 | grep -q "ValidationError"; then
      echo false
    else
      echo true
    fi
}

cf_create_stack() {
  local name="$1"
  local template="$2"
  local config_file="$3"
  local region="$4"
  aws cloudformation create-stack \
    --stack-name $name \
    --template-body file://$template \
    --parameters file://$config_file \
    --capabilities CAPABILITY_IAM \
    --on-failure DELETE \
    --region $region
}

cf_delete_stack() {
  local name="$1"
  local region="$2"
  aws cloudformation delete-stack \
    --stack-name $name \
    --region $region
}

create_bucket() {
  local name="$1"
  local region="$2"
  aws s3api create-bucket \
    --bucket $name \
    --region $region \
    --create-bucket-configuration LocationConstraint=$region
}

wait_until_cf_stack_creation() {
  local name="$1"
  local region="$2"
  echo "Waiting until Cloudformation stack \"${name}\" is created, takes a long time!"
  aws cloudformation wait stack-create-complete \
    --stack-name $name \
    --region $region
  echo "Cloudformation stack \"${name}\" was created"
}

upload_artifact() {
  local bucket="$1"
  local key="$2"
  local region="$3"
  git archive --format zip HEAD | aws s3 cp - s3://$bucket/$key --region $region
}

eb_init() {
  local region="$1"
  eb init --platform node.js --region $region
}

eb_use() {
  local env="$1"
  eb use $env
}

################################################################################

CF_STACK_NAME=$(get_param ApplicationName)
BUCKET=$(get_param ApplicationS3Bucket)
KEY=$(get_param ApplicationS3Artifact)
REGION=$(get_param AWSRegion)
BUCKET_EXIST=$(bucket_exist ${BUCKET} ${REGION})
CF_STACK_EXIST=$(cf_stack_exist ${CF_STACK_NAME} ${REGION})
CF_TEMPLATE_FILE_EXIST=$(file_exist $CF_TEMPLATE_FILE)
CF_CONFIG_FILE_EXIST=$(file_exist $CF_CONFIG_FILE)
STACK_ENVIRONMENT=$(get_param EnvironmentName)

if [[ "${CF_TEMPLATE_FILE_EXIST}" == false ]]; then
  echo "${CF_TEMPLATE_FILE} is necessary"
fi

if [[ "${CF_CONFIG_FILE_EXIST}" == false ]]; then
  echo "${CF_CONFIG_FILE} is necessary"
fi

# Create a BUCKET if not exist
if [[ "${BUCKET_EXIST}" == false ]]; then
  create_bucket $BUCKET $REGION
fi

# upload our artifact to S3
upload_artifact $BUCKET $KEY $REGION

if [[ "${CF_STACK_EXIST}" == false ]]; then
  cf_create_stack $CF_STACK_NAME $CF_TEMPLATE_FILE $CF_CONFIG_FILE $REGION
  wait_until_cf_stack_creation $CF_STACK_NAME $REGION
  eb_init $REGION
  eb_use $STACK_ENVIRONMENT
  cp deployment/cloudwatch.config .ebextensions/
  eb deploy
fi
