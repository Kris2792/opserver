#!/bin/bash

required_env_vars=(
    ACTION
    APPLICATION
    ENVIRONMENT
    INSTANCE_TYPE
    VERSION
)

# loop through and check if any required vars are empty
for i in ${required_env_vars[@]}; do
    if [ -z ${!i} ]; then
        echo "Environment variable missing: $i"
        exit 1
    fi
done

# Get details of prereq stack
outputs=$(aws cloudformation describe-stacks \
    --stack-name ${APPLICATION}-prereq-${ENVIRONMENT} \
    --no-cli-pager \
    | jq -r '.Stacks[0].Outputs[]' \
)

iam_instance_profile=$(echo ${outputs} | jq -r 'select(.OutputKey == "InstanceProfile") | .OutputValue')
kms_key_alias=$(echo ${outputs} | jq -r 'select(.OutputKey == "KeyAlias") | .OutputValue')
kms_key_id=$(echo ${outputs} | jq -r 'select(.OutputKey == "Key") | .OutputValue')
subnet_id=$(echo ${outputs} | jq -r 'select(.OutputKey == "PublicSubnet1") | .OutputValue')
vpc_id=$(echo ${outputs} | jq -r 'select(.OutputKey == "VPC") | .OutputValue')

# Validate Packer config
PACKER_LOG=1 \
packer ${ACTION} \
    -var "application=${APPLICATION}" \
    -var "environment=${ENVIRONMENT}" \
    -var "iam_instance_profile=${iam_instance_profile}" \
    -var "instance_type=${INSTANCE_TYPE}" \
    -var "kms_key_id=${kms_key_id}" \
    -var "password=${password}" \
    -var "subnet_id=${subnet_id}" \
    -var "version=${VERSION}" \
    -var "vpc_id=${vpc_id}" \
    packer/image.json
