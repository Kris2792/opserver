# Opserver build
Contains code to automatically build a pre-requisite stack and VM image

---
### Development environment setup
The following software is required to be installed:
- **Make** - https://www.gnu.org/software/make/
- **AWS CLI** - https://aws.amazon.com/cli/
- **jq** - https://stedolan.github.io/jq/
- **Ansible** - https://www.ansible.com/
- **Packer** - https://www.packer.io/

#### Commands
1. Run `make prereq` to create a pre-requite CloudFormation stack. This stack contains the requirements for building the Packer image and hosting the application
2. Run `make validate-image` to validate the Packer configuration
3. Run `make bake-image` to generate an EC2 AMI containing all the relevant dependencies

There are a few Make variables that can be set:
- **APPLICATION** - Specifies a unique name to add to resources such as the Packer image
- **ENVIRONMENT** - Specifies a an environment. Valid values are `dev`, `qat`, `uat` and `prod`. Is used to segregate environments in CloudFormation.
- **INSTANCE_TYPE** - Currently specifies the instance type that Packer uses to build an AMI. Can also be used in the future to specify the VM size of the EC2 App servers.
- **VERSION** - Adds a unique prefix/suffix for resources such as the Packer image. Also helps with easier sorting.

Each Make variable has a default (as specifed in the Makefile). To change the default, specify it after the relevant Make command `make prereq ENVIRONMENT=prod `. Can also be specified by setting it as an environment variable.
