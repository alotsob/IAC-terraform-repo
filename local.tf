

# locals {
#   name = "value"
# }

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
    component_name          = "IAC-TERRAFORM_REPO"
  }
  vpc_id = aws_vpc.kojitechs.id
}
 