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
