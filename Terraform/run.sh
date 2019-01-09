#!/bin/bash
terraform $1 -var-file="/Users/c5271711/.terraform/terraform.tfvars" -auto-approve
