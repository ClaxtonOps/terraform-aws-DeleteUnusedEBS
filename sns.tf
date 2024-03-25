resource "aws_sns_topic" "lambda_error_topic" {
  name = local.sns.rules.name
}

resource "aws_sns_topic_subscription" "lambda_error_email_subscription" {

  protocol  = local.sns.rules.protocol
  endpoint  = local.sns.rules.endpoint_email
  topic_arn = aws_sns_topic.lambda_error_topic.arn
}


