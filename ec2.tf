
locals {
  subnet_id = [aws_subnet.public_subnet[0].id, aws_subnet.private_subnet[0].id]
  Name      = ["web_instance", "app_instance"]
  vpc_security_group_ids = [aws_security_group.web.id, aws_security_group.app.id]
}

/*
resource "aws_security_group" "web" {
  name        = "${var.component_name}_web_sg" #format("%s-%s",var.component_name)
  description = "Allow ssh inbound traffic"
  vpc_id      = local.vpc_id

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
  tags = {
    "key" = "${var.component_name}_web_sg"
  }
  lifecycle {
    create_before_destroy = true 
  }
}

resource "aws_security_group" "app" {
  name        = "${var.component_name}_app_sg"
  description = "Allow ssh inbound traffic from ${aws_security_group.web.id}"
  vpc_id      = local.vpc_id

  ingress {
    description          = "http from VPC"
    from_port            = 22
    to_port              = 22
    protocol             = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "key" = "${var.component_name}_app_sg"
  }
  lifecycle {
    create_before_destroy = true 
  }
}

*/

output "public_ip" {
  value = format("http://%s", aws_instance.web[0].public_ip)
}

# count mostly used for conditions

resource "aws_instance" "web" {
  count                  = 2
  ami                    = "ami-0022f774911c1d690" # use datasource to fetch the ami
  instance_type          = "t2.micro"
  subnet_id              = local.subnet_id[count.index]
  user_data              = file("${path.module}/template/app1-http.sh")
  vpc_security_group_ids = [local.vpc_security_group_ids[count.index]]
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  key_name               = aws_key_pair.bastion_instance.id

  tags = {
    Name = local.Name[count.index]
  }
}

resource "aws_key_pair" "bastion_instance" {
  key_name   = "bastion_instance"
  public_key = file("/Users/robertsob/.ssh/bastion_instance.pub")
}

resource "aws_ssm_parameter" "ssm_kp" {
  name  = format("%s-%s", var.component_name, "ssm_kp")
  type  = "SecureString"
  value = " "
  lifecycle {
    ignore_changes = [
      value,
    ]
  }
}

