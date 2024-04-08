resource "aws_cloudwatch_metric_alarm" "alb_healthyhosts" {
  alarm_name          = "red_alert"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  alarm_description   = "Number of healthy nodes in Target Group"
  actions_enabled     = "true"
  alarm_actions       = [aws_sns_topic.alarm.arn]
  dimensions = {
    TargetGroup  = aws_lb_target_group.sun_api.arn_suffix
    LoadBalancer = aws_alb.sun_api.arn_suffix
  }
}

# SNS topic to send emails with the Alerts
resource "aws_sns_topic" "alarm" {
  name              = "my-alarm-topic"
  kms_master_key_id = aws_kms_key.sns_encryption_key.id
  delivery_policy   = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
  ## This local exec, suscribes your email to the topic 
  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.your_email} --region ${var.main_region}"
  }
}


## KMS Key to encrypt the SNS topic (security best practises)
resource "aws_kms_key" "sns_encryption_key" {
  description             = "alarms sns topic encryption key"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

# variable "your_email" {
#   type = string
#   default = "abc@123.com"
# }

# variable "main_region" {
#   type = string
#   default = "ap-east-1"
# }