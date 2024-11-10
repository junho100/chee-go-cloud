resource "aws_ecr_repository" "backend_ecr_repository" {
  name = format(module.naming.result, "backend-ecr")

  force_delete = true
}

resource "aws_ecr_repository" "noti_ecr_repository" {
  name = format(module.naming.result, "noti-ecr")

  force_delete = true
}
