#ALB variables

variable "region" {
  default     = "ap-southeast-1"
}

variable "name" {
  description = "The name to use for the ELB and all other resources in this module."
  default     = "Vault-alb"
}

variable "sg" {
  type    = "list"
  default = ["sg-055105b4f60ca0a9f"]
}


variable "subnets" {
  type   = "list"
  default = ["subnet-07078232e07eb69f5","subnet-1392e665","subnet-db0545bf"]
}

variable "environment" {
  default = "Preprod"
}

variable "tg-name" {
  default = "vault-prod-TG1"
}

variable "vpc_id" {
  default = "vpc-542cab30"	
}

variable "ssl-cert" {
  default = "arn:aws:acm:ap-southeast-1:035385703479:certificate/3ea97c26-1c82-4298-b5d8-d1c1006f17e6"
}

variable "ssl_policy" {
  default = "ELBSecurityPolicy-2016-08"
}

#LC variables
variable "instance-type" {
  default = "t3.medium"
}

variable "lc-name" {
  default = "vault-prod-LC2"
}

variable "image-id" {
  default = "ami-06fb5332e8e3e577a"
}

variable "key-name" {
  default = "prod-key"
}

variable "security-groups" {
  type = "list"  
  default = ["sg-019917fe28a5c14a4"]
}

variable "iam-instance-profile" {
  default = "ec2-vault-kms"
}

#ASG variables
variable "asg-name" {
  default = "prod-vault-ASG1"
}


variable "asg-subnets1" {
  type = "list"  
  default = ["subnet-1392e665"]
}

variable "asg-subnets2" {
  type = "list"
  default = ["subnet-db0545bf"]
}

variable "asg-subnets3" {
  type = "list"
  default = ["subnet-07078232e07eb69f5"]
}

