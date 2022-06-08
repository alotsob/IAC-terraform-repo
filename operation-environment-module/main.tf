
locals {
  mandatory_tag = {
    line_of_bussiness       = "business"
    ado                     = "max"
    operational_environment = upper(terraform.workspace)
    tier                    = "WEB"
    tech_poc_primary        = "bobaalot@gamil.com"
    tech_poc_secondary      = "bobaalot@gamil.com"
    application             = "WEB"
    builder                 = "bobaalot@gamil.com"
    application_owner       = "kojitechs.com"
    vpc                     = "WEB"
    cell_name               = "WEB"
    component_name          = var.component-name
  }
}

resource "aws_s3_bucket" "iac_s3_bucket" {
    count = length(var.s3_name)
  bucket = var.s3_name[count.index]

  versioning {
    enabled = true
  }

  tags = {
    Name        = var.s3_name[count.index]
  }
}

resource "aws_dynamodb_table" "dynamodb-terraform-lock" {
  name           = "terraform-lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}