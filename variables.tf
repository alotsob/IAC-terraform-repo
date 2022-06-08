
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
  default = "iac-terraform-repo"

}

variable "app_port" {
  default     = 8080
  description = "https  application traffic  "
  type        = number
}


variable "http_port" {
  default     = 80
  description = "https traffic from everywhere"
  type        = number
}
variable "https_port" {
  default     = 443
  description = "https traffic from everywhere"
  type        = number
}

variable "database_name" {
  default     = "webappdb"
  type        = string
  description = "db name "
}

variable "master_username" {
  default     = "dbadmin"
  description = "db user name "
}

variable "create_instance" {
  type        = bool
  default     = "true"
  description = "create instance"
}