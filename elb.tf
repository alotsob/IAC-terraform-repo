
resource "aws_lb" "kojitechs-lb" {
  name                       = format("%s-%s", var.component_name, "kojitechs-lb")
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.web.id]
  subnets                    = aws_subnet.public_subnet.*.id
  enable_deletion_protection = false

  tags = {
    Name = format("%s-%s", var.component_name, "kojitechs-lb")
  }
}


resource "aws_lb_target_group" "kojitechs-targetgroup" {
  name        = format("%s-%s", var.component_name, "kojitechs-tg")
  target_type = "alb"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = local.vpc_id

  health_check {
    path                = "/login"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    protocol            = "HTTP"
    matcher             = "200" # has to be HTTP 200 or fails
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.kojitechs-lb.arn
  port              = var.https_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = module.acm.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kojitechs-targetgroup.arn
  }
}


