locals {
  lambda = {
    rules = {
      name                = "UnusedEBSvolume_Lambda_Function"
      handler             = "index"
      lambda_handler      = "lambda_handler"
      python_ver          = "python3.11"
      source_dir          = "data_python"
      output_path         = "index.zip"
      type                = "zip"
      timeout             = 30
      environments_string = join(",", var.tag_environments)
      sns_topic_arn       = "${aws_sns_topic.lambda_error_topic.arn}"
    }
  }
  eventbridge = {
    rules = {
      schedule     = var.trigger_cron
      name         = "DailyLambdaEBSUnusuedTrigger"
      target_id    = "LambdaTarget"
      statement_id = "AllowExecutionFromCloudWatch"
      action       = "lambda:InvokeFunction"
      principal    = "events.amazonaws.com"
      description  = "Trigger for UnusedEBS"
    }
  }
  sns = {
    rules = {
      name           = "ambda_error_topic"
      protocol       = "email"
      endpoint_email = var.email
    }
  }
}

