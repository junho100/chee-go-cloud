module "metric_alarm" {
  source = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"

  alarm_name          = format(module.naming.result, "ec2-err-alarm")
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "0"

  dimensions = {
    InstanceId = aws_instance.bastion_host.id
  }

  alarm_actions = [module.sns_topic.topic_arn]
}
