module "acm" {
  source = "terraform-aws-modules/acm/aws"

  providers = {
    aws = aws.us_east_1
  }

  domain_name = var.domain_name
  zone_id     = data.aws_route53_zone.target_host_zone.zone_id

  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain_name}",
    "${var.domain_name}",
  ]

  wait_for_validation = true
}

module "acm_ap_northeast_2" {
  source = "terraform-aws-modules/acm/aws"

  domain_name = var.domain_name
  zone_id     = data.aws_route53_zone.target_host_zone.zone_id

  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain_name}",
    "${var.domain_name}",
  ]

  wait_for_validation = true
}
