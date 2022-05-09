



variable "instance_type" {
  type        = list
  default     = ["t2.micro", "t2.nano" ] 
  description = "ec2 instance type"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "aws region"
}

variable "ip_address" {
  type        = list(any)
  default     = ["76.21.150.248/32"]
  description = " ip address for SG"
}

variable "assign_public_ip" {
  type        = bool
  default     = true
  description = "associate public ip"
}

variable "create_instance" {
  type        = bool
  default     = true
  description = "create instance"

}