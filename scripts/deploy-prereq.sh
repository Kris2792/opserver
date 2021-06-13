#!/bin/bash

required_env_vars=(
    APPLICATION
    ENVIRONMENT
)

# loop through and check if any required vars are empty
for i in ${required_env_vars[@]}; do
    if [ -z ${!i} ]; then
        echo "Environment variable missing: $i"
        exit 1
    fi
done

aws cloudformation deploy \
    --stack-name ${APPLICATION}-prereq-${ENVIRONMENT} \
    --template-file cloudformation/prereq.yaml \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides \
        Application=${APPLICATION} \
        Environment=${ENVIRONMENT}
