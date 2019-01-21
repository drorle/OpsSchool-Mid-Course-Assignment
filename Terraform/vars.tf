##################################################################################
# VARIABLES
##################################################################################

variable "aws_region" {
  description = "Default aws region where all resources will get created"
  default = "us-east-2"
}

variable "environment_tag" {
  description = "Tag to be added to all resources created using Terraform"
  default = "tf-opsschool-midterm"
}

variable "key_name" {
  description = "The name of the key pair to be created"
  default = "dror-key-pair"
}

variable "private_key_path" {
  description = "Path to the private key that is part of the AWS key pair, to be used by Ansible"
  default = "~/.ssh/id_rsa"
}

variable "docker_instance_count" {
  description = "Number of instances to be used as docker machines"
  default = 1
}

variable "consul_server_count" {
  description = "Number of Consul servers"
  default = 1
}

variable "subnet_count" {
  description = "Number of subnets to be created"
  default = 1
}

variable "network_address_space" {
  description = "Network address space"
  default = "10.1.0.0/16"
}

variable "ami" {
  description = "Ubuntu 16.02 ami"
  default = "ami-0653e888ec96eab9b" # Ubuntu 16.04 in us-east-2
  # default = "ami-076e276d85f524150" # Ubuntu 16.04 in us-west-2
}

variable "instance_type" {
  description = "Instance type for all small machines, part of the AWS free tier"
  default = "t2.micro"
}

# ELK Instance
variable "elk_instance_type" {
  description = "Instance type for the elk machine, which needs to be larger than t2.micro"
  default = "t3.medium"
}

variable "elk_instance_count" {
  description = "Number of instances to be used for elk"
  default = 1
}

variable "consul_version" {
  description = "The version of Consul to install (server and client)."
  default     = "1.4.0"
}
