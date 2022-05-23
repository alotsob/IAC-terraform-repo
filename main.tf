
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
    component_name          = var.component_name
  }
  vpc_id     = try(aws_vpc.kojitechs[0].id, "")
  create_vpc = var.create_vpc
  azs        = data.aws_availability_zones.available.names
}

data "aws_availability_zones" "available" {
  state = "available"
}

# creating vpc

resource "aws_vpc" "kojitechs" {
  count = local.create_vpc ? 1 : 0

  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = false
  enable_dns_hostnames = false

  tags = {
    Name = "kojitechs"
  }
}

# creating internet gateway

resource "aws_internet_gateway" "igw" {
  count = local.create_vpc ? 1 : 0

  vpc_id = local.vpc_id

  tags = {
    Name = "kojitechs_igw"
  }
}

# creating  public subnet

resource "aws_subnet" "public_subnet" {
  count = local.create_vpc ? length(var.cidr_pubsubnets) : 0

  vpc_id                  = local.vpc_id
  cidr_block              = var.cidr_pubsubnets[count.index]
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "pub_subnet${count.index + 1}"
  }
}

# creating  private subnet

resource "aws_subnet" "private_subnet" {
  count = local.create_vpc ? length(var.cidr_prisubnets) : 0

  vpc_id            = local.vpc_id
  cidr_block        = var.cidr_prisubnets[count.index]
  availability_zone = local.azs[count.index]

  tags = {
    Name = "pri-subnet${local.azs[count.index]}"
  }
}

#creating dbsubnets

resource "aws_subnet" "database_subnet" {
  count = local.create_vpc ? length(var.cidr_dbsubnets) : 0

  vpc_id            = local.vpc_id
  cidr_block        = var.cidr_dbsubnets[count.index]
  availability_zone = local.azs[count.index]

  tags = {
    Name = "db-subnet1${local.azs[count.index]}"
  }
}

# creating route tables

resource "aws_route_table" "route_table" {
  count  = local.create_vpc ? length(var.cidr_pubsubnets) : 0
  vpc_id = local.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }
}

# creating route table association

resource "aws_route_table_association" "route_tables_ass" {
  count = local.create_vpc ? length(var.cidr_pubsubnets) : 0

  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.route_table[count.index].id
}

# creating a default route for private and db sunbets.

resource "aws_default_route_table" "kojitechs" {
  default_route_table_id = aws_vpc.kojitechs[0].default_route_table_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw_1.id
  }
}
# creating nat gateway
resource "aws_nat_gateway" "ngw_1" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "gw NAT"
  }
}
# creating elastic ip
resource "aws_eip" "eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}
