##################################################################################
# VARIABLES
##################################################################################

#variable "aws_access_key" {}
#variable "aws_secret_key" {}
variable "private_key_path" {}
variable "public_key" {}

variable "environment_tag" {
  default = "tf"
}

variable "key_name" {
  default = "terraform-key-pair"
}

variable "instance_count" {
  default = 1
}

variable "subnet_count" {
  default = 1
}

variable "network_address_space" {
  default = "10.1.0.0/16"
}

variable "ami" {
  default = "ami-076e276d85f524150" # Ubuntu 16.04 in us-west-2
}

variable "instance_type" {
  default = "t2.micro"
}

