resource "aws_codedeploy_app" "backend_codedeploy_app" {
  name = format(module.naming.result, "backend-cd-app")
}

resource "aws_codedeploy_deployment_group" "backend_codedeploy_deployment_group" {
  app_name               = aws_codedeploy_app.backend_codedeploy_app.name
  deployment_group_name  = format(module.naming.result, "backend-cd-deployment-group")
  service_role_arn       = module.codedeploy_role.iam_role_arn
  deployment_config_name = "CodeDeployDefault.OneAtATime"
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = module.backend.tags_all.Name
    }
  }
}

resource "aws_codedeploy_app" "noti_codedeploy_app" {
  name = format(module.naming.result, "noti-cd-app")
}

resource "aws_codedeploy_deployment_group" "noti_codedeploy_deployment_group" {
  app_name               = aws_codedeploy_app.noti_codedeploy_app.name
  deployment_group_name  = format(module.naming.result, "noti-cd-deployment-group")
  service_role_arn       = module.codedeploy_role.iam_role_arn
  deployment_config_name = "CodeDeployDefault.OneAtATime"
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = module.backend.tags_all.Name
    }
  }
}

