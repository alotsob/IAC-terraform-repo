
data "aws_route53_zone" "bobtech" {
  name = "bobtech.org"
}


resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.bobtech.zone_id
  name    = "bobtech.org"
  type    = "A"

  alias {
    name                   = aws_lb.kojitechs-lb.dns_name
    zone_id                = aws_lb.kojitechs-lb.zone_id
    evaluate_target_health = true
  }
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "3.0.0"

  domain_name               = trimsuffix(data.aws_route53_zone.bobtech.name, ".")
  zone_id                   = data.aws_route53_zone.bobtech.zone_id
  subject_alternative_names = ["*.bobtech.org"]
}



