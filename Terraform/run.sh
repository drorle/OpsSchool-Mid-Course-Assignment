#!/bin/bash
#terraform $1 -var-file="~/.terraform/terraform.tfvars" -auto-approve

if [ "$1" == "plan" ]; then
#  terraform $1 -var-file="~/.terraform/terraform.tfvars"
  terraform $1
else
#  terraform $1 -var-file="~/.terraform/terraform.tfvars" -auto-approve
  terraform $1 -auto-approve
fi
