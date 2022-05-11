
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
   vpc_id      = local.vpc_id

  ingress {
    description = "http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["76.21.150.248/32"]
  }

ingress {
    description = "http from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["76.21.150.248/32"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

/*
data "aws_ami" "golden_ami" {
  
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
*/

resource "random_integer" "random" {
  min = 1
  max = 100
}

data "aws_ssm_parameter" "ami" {
  name = "latest_golden_ami"
}

# count mostly used for conditions

resource "aws_instance" "web" {
  #count = var.create_instance    ?  1 : 0
  ami                         = "ami-0022f774911c1d690"
  instance_type               = "t2.micro"
  subnet_id = aws_subnet.public_subnet1.id
  user_data                   = file("${path.module}/template/app1-http.sh")
  vpc_security_group_ids      = [aws_security_group.allow_http.id]

  tags_all = {
    Name = "web"
  }
}



