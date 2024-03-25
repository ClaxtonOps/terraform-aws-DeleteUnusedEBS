data "archive_file" "zip_the_python_code" {
  type        = local.lambda.rules.type
  source_dir  = "${path.module}/${local.lambda.rules.source_dir}/"
  output_path = "${path.module}/${local.lambda.rules.source_dir}/${local.lambda.rules.output_path}"
}

resource "aws_lambda_function" "lambda_function" {
  filename      = "${path.module}/${local.lambda.rules.source_dir}/${local.lambda.rules.output_path}"
  handler       = "${local.lambda.rules.handler}.${local.lambda.rules.lambda_handler}"
  function_name = local.lambda.rules.name
  runtime       = local.lambda.rules.python_ver
  role          = aws_iam_role.lambda_role_ebs.arn
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  timeout       = local.lambda.rules.timeout

  environment {
    variables = {
      SNS_TOPIC_ARN = local.lambda.rules.sns_topic_arn
      ENVIRONMENTS  = local.lambda.rules.environments_string
    }
  }
}

