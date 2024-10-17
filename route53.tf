data "aws_route53_zone" "target_host_zone" {
  name = "${var.domain_name}."
}

module "route53_records" {
  source = "terraform-aws-modules/route53/aws//modules/records"

  zone_id = data.aws_route53_zone.target_host_zone.zone_id

  records = [
    {
      name = ""
      type = "A"
      alias = {
        name    = module.cloudfront.cloudfront_distribution_domain_name
        zone_id = module.cloudfront.cloudfront_distribution_hosted_zone_id
      }
    },
    {
      name = "www"
      type = "A"
      alias = {
        name    = module.cloudfront.cloudfront_distribution_domain_name
        zone_id = module.cloudfront.cloudfront_distribution_hosted_zone_id
      }
    },
  ]
}
