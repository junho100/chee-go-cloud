module "cloudfront" {
  source = "terraform-aws-modules/cloudfront/aws"

  origin = {
    cheego_web = {
      domain_name           = module.s3_bucket.s3_bucket_bucket_regional_domain_name
      origin_access_control = "cheego_web"
    }
  }

  create_origin_access_control = true
  origin_access_control = {
    cheego_web = {
      description      = "CloudFront access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  custom_error_response = [{
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
    }, {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }]

  default_cache_behavior = {
    target_origin_id       = "cheego_web"
    viewer_protocol_policy = "allow-all"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
  }

  default_root_object = "index.html"
}
