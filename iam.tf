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
    "ec2.amazonaws.com"
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

  policy = file("./files/backend-policy.json")
}