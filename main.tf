
resource "aws_vpc" "kojitechs" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = false
  enable_dns_hostnames = false
}

resource "aws_subnet" "public_subnet1" {
  vpc_id     = local.vpc_id
  cidr_block = var.cidr_pubsubnets[0]
  availability_zone = var.pub_az[0]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet2" {
  vpc_id     = local.vpc_id
  cidr_block = var.cidr_pubsubnets[1]
  availability_zone = var.pub_az[1]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.kojitechs.id
  cidr_block = var.cidr_prisubnets[0]
  availability_zone = var.pri_az[0]
}

resource "aws_subnet" "private_subnet2" {
  vpc_id     = local.vpc_id
  cidr_block = var.cidr_prisubnets[1]
  availability_zone = var.pri_az[1]
}

resource "aws_subnet" "database_subnet1" {
  vpc_id     = local.vpc_id
  cidr_block = var.cidr_dbsubnets[0]
  availability_zone = var.db_az[0]
}

resource "aws_subnet" "database_subnet2" {
  vpc_id     = local.vpc_id
  cidr_block = var.cidr_dbsubnets[1]
  availability_zone = var.db_az[1]
}
