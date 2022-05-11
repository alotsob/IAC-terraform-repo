
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
 
resource "aws_vpc" "kojitechs" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = false
  enable_dns_hostnames = false

  tags = {
    Name = "kojitechs"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = local.vpc_id

  tags = {
    Name = "kojitechs_igw"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id     = local.vpc_id
  cidr_block = var.cidr_pubsubnets[0]
  availability_zone = var.pub_az[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "pub_subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id     = local.vpc_id
  cidr_block = var.cidr_pubsubnets[1]
  availability_zone = var.pub_az[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "pub_subnet2"
  }
}

resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.kojitechs.id
  cidr_block = var.cidr_prisubnets[0]
  availability_zone = var.pri_az[0]

  tags = {
    Name = "pri-subnet1${var.pri_az[0]}"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id     = local.vpc_id
  cidr_block = var.cidr_prisubnets[1]
  availability_zone = var.pri_az[1]

  tags = {
    Name = "pri-subnet2${var.pri_az[1]}"
  }
}

resource "aws_subnet" "database_subnet1" {
  vpc_id     = local.vpc_id
  cidr_block = var.cidr_dbsubnets[0]
  availability_zone = var.db_az[0]

  tags = {
    Name = "db-subnet1${var.db_az[0]}"
  }
}

resource "aws_subnet" "database_subnet2" {
  vpc_id     = local.vpc_id
  cidr_block = var.cidr_dbsubnets[1]
  availability_zone = var.db_az[1]

   tags = {
    Name = "db-subnet2${var.db_az[1]}"
  }
}
# creating route tables

resource "aws_route_table" "pub_rt1" {
  vpc_id = local.vpc_id
  route {
    cidr_block    = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "pub_rt2" {
  vpc_id = local.vpc_id
   route  {
    cidr_block    = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
# creating route table association

resource "aws_route_table_association" "pub_rt_assoc1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.pub_rt2.id
}

resource "aws_route_table_association" "pub_rt_assoc2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.pub_rt2.id
}

# creating a default route for private and db sunbets.

resource "aws_default_route_table" "kojitechs" {
  default_route_table_id = aws_vpc.kojitechs.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw_1.id
  }
}
# creating nat gateway
resource "aws_nat_gateway" "ngw_1" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet1.id
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "gw NAT"
  }
}
# creating elastic ip
resource "aws_eip" "eip" {
  vpc      = true
  depends_on = [aws_internet_gateway.igw]
}