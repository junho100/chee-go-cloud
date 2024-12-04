data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.root}/lambda/bootstrap"
  output_path = "${path.root}/lambda/function.zip"
}

resource "aws_lambda_permission" "sns" {
  statement_id  = "AllowSNSInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.notification_handler.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = module.sns_topic.topic_arn
}

resource "aws_lambda_function" "notification_handler" {
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  function_name    = format(module.naming.result, "notification-lambda")
  role             = aws_iam_role.lambda_role.arn
  handler          = "bootstrap"
  runtime          = "provided.al2"
  timeout          = 30

  environment {
    variables = {
      DISCORD_BOT_TOKEN = var.discord_bot_token
      DISCORD_USER_ID   = var.discord_user_id
    }
  }
}


