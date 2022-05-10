
variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "aws region"
}

variable "cidr_pubsubnets" {
  type = list
  default = ["10.0.0.0/24", "10.0.2.0/24"]
  description = " list of public subnet cidrs"
}

variable "cidr_prisubnets" {
  type = list
  default = ["10.0.1.0/24","10.0.3.0/24" ]
  description = "list of private subnet cidrs"
}

variable "cidr_dbsubnets" {
  type = list
  default = ["10.0.5.0/24", "10.0.7.0/24"]
  description = "public subnet1 cidr"
}

variable "pub_az" {
  type = list
  default = ["us-east-1a", "us-east-1b"]
  description = "az for pubsubnets"
}

variable "pri_az" {
  type = list
  default = ["us-east-1c", "us-east-1d"]
  description = "az for prisubnets"
}

variable "db_az" {
  type = list
  default = ["us-east-1a", "us-east-1b"]
  description = "az for pubsubnets"
}