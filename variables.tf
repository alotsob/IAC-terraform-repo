
variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "aws region"
}

variable "cidr_pubsubnets" {
  type        = list(any)
  default     = ["10.0.14.0/24", "10.0.16.0/24"]
  description = " list of public subnet cidrs"
}

variable "cidr_prisubnets" {
  type        = list(any)
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
  description = "list of private subnet cidrs"
}

variable "cidr_dbsubnets" {
  type        = list(any)
  default     = ["10.0.5.0/24", "10.0.7.0/24"]
  description = "public subnet1 cidr"
}

variable "create_vpc" {
  type        = bool
  default     = true
  description = "creating a vpc"
}

variable "component_name" {
  default = "IAC-TERRAFORM_REPO"

}