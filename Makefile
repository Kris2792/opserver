APPLICATION ?= opserver
ENVIRONMENT ?= dev
INSTANCE_TYPE ?= t3.medium
VERSION := $(shell date '+%Y%m%d%H%M%S')

# Create a pre-requite CloudFormation stack
prereq:
	APPLICATION=${APPLICATION} \
	ENVIRONMENT=${ENVIRONMENT} \
	scripts/deploy-prereq.sh

# Validate the Packer configuration
validate-image:
	OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES \
	ACTION=validate \
	APPLICATION=${APPLICATION} \
	ENVIRONMENT=${ENVIRONMENT} \
	INSTANCE_TYPE=${INSTANCE_TYPE} \
	VERSION=${VERSION} \
	scripts/image.sh

# Generate an EC2 AMI containing all the relevant dependencies
bake-image:
	OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES \
	ACTION=build \
	APPLICATION=${APPLICATION} \
	ENVIRONMENT=${ENVIRONMENT} \
	INSTANCE_TYPE=${INSTANCE_TYPE} \
	VERSION=${VERSION} \
	scripts/image.sh
