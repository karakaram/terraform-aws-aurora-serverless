.PHONY: help init plan apply destroy get encrypt decrypt
.DEFAULT_GOAL := help

env = production
option := -var-file=$(env).tfvars -var-file=secret.tfvars

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

init: ## Initialize a Terraform configuration
	rm -f .terraform/terraform.tfstate
	terraform init \
		-backend-config='backend.tfvars'
	-terraform workspace new production
	-terraform workspace new development

plan: get decrypt ## Generate and show an execution plan
	terraform workspace select $(env)
	terraform plan $(option)

apply: get decrypt ## Builds or changes infrastructure
	terraform workspace select $(env)
	terraform apply $(option) -auto-approve

destroy: get decrypt ## Destroy Terraform-managed infrastructure
	terraform workspace select $(env)
	terraform destroy $(option)

get: ## Download and install modules for the configuration
	terraform get

encrypt: ## Encrypt a secret vars file
	aws kms encrypt --key-id alias/my-key --plaintext fileb://secret.tfvars --query CiphertextBlob --output text | base64 --decode > secret.tfvars.enc

decrypt: ## Decrypt a secret vars file
	aws kms decrypt --ciphertext-blob fileb://secret.tfvars.enc --output text --query Plaintext | base64 --decode > secret.tfvars
