

# Configure the AWS Provider
provider "aws" {
  region  = var.aws_region
  #profile = "default"
  
  default_tags {
    tags = local.mandatory_tag
  }
}

terraform {

  backend "s3" {
    profile = "default"
bucket = "iacs3bucket"
key = "terraform.tfstate"
region = "us-east-1"
encrypt = true
dynamodb_table = "terraform-lock"
  }
}