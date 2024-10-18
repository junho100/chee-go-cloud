resource "aws_iam_user" "web_cicd_iam_user" {
  name          = format(module.naming.result, "web-cicd-iam-user")
  force_destroy = false
}

resource "aws_iam_access_key" "web_cicd_access_key" {
  user = aws_iam_user.web_cicd_iam_user.name
}

resource "aws_iam_user_policy" "web_cicd_iam_policy" {
  name   = format(module.naming.result, "web-cicd-iam-user-policy")
  user   = aws_iam_user.web_cicd_iam_user.name
  policy = file("./files/web-cicd-policy.json")
}

module "backend_instance_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  role_name               = format(module.naming.result, "backend-role")
  role_requires_mfa       = false
  create_role             = true
  create_instance_profile = true

  trusted_role_services = [
    "ec2.amazonaws.com",
    "codedeploy.amazonaws.com"
  ]

  custom_role_policy_arns = [
    module.backend_instance_policy.arn
  ]
}

module "backend_instance_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = format(module.naming.result, "backend-policy")
  path        = "/"
  description = "backend-policy"

  policy = templatefile("./files/backend-policy.tftpl", {
    s3_bucket_arn = "arn:aws:s3:::${format(module.naming.result, "backend-bucket")}",
    ecr_repo_arn  = aws_ecr_repository.backend_ecr_repository.arn
  })


}

module "codedeploy_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  role_name               = format(module.naming.result, "cd-role")
  role_requires_mfa       = false
  create_role             = true
  create_instance_profile = false

  trusted_role_services = [
    "codedeploy.amazonaws.com",
    "ec2.amazonaws.com"
  ]

  custom_role_policy_arns = [
    module.codedeploy_policy.arn
  ]
}

module "codedeploy_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = format(module.naming.result, "cd-policy")
  path        = "/"
  description = "codedeploy-policy"

  policy = templatefile("./files/codedeploy-policy.tftpl", {
    s3_bucket_arn = "arn:aws:s3:::${format(module.naming.result, "backend-bucket")}"
  })
}
