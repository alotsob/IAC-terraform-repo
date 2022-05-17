

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
   vpc_id      = local.vpc_id

  ingress {
    description = "http from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}


# count mostly used for conditions

resource "aws_instance" "web" {
  #count = var.create_instance    ?  1 : 0
  ami                         = "ami-0022f774911c1d690"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet[0].id
  user_data                   = file("${path.module}/template/app1-http.sh")
  vpc_security_group_ids      = [aws_security_group.allow_http.id]
  key_name                    = "NovaMac.KP"
  tags_all = {
    Name = "web"
  }
}



