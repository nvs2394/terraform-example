# variables.tf | Auth and Application variables
variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "app_environment" {
  type    = string
  default = "Application Environment"
}

variable "aws_key_pair_name" {
  type    = string
  default = "AWS Key Pair Name"
}

variable "app_name" {
  type    = string
  default = "Application Name"
}

variable "private_subnets" {
  description = "List of private subnets"
}

variable "availability_zones" {
  description = "List of availability zones"
}

variable "public_subnets" {
  description = "List of public subnets"
}