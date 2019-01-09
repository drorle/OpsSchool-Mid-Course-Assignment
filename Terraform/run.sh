#!/bin/bash
#terraform $1 -var-file="~/.terraform/terraform.tfvars" -auto-approve

if [ "$1" == "plan" ]; then
  terraform $1 -var-file="~/.terraform/terraform.tfvars"
else
  terraform $1 -var-file="~/.terraform/terraform.tfvars" -auto-approve
fi
