module "sns_topic" {
  source = "terraform-aws-modules/sns/aws"

  name = format(module.naming.result, "ec2-sns-topic")
}

resource "aws_sns_topic_subscription" "lambda" {
  topic_arn = module.sns_topic.topic_arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.notification_handler.arn
}
