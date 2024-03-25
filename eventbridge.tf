resource "aws_cloudwatch_event_rule" "daily_trigger_rule" {
  for_each = local.eventbridge

  name                = each.value.name
  description         = each.value.description
  schedule_expression = each.value.schedule
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  for_each = local.eventbridge

  rule      = aws_cloudwatch_event_rule.daily_trigger_rule[each.key].name
  target_id = each.value.target_id
  arn       = aws_lambda_function.lambda_function.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  for_each = local.eventbridge


  statement_id  = each.value.statement_id
  action        = each.value.action
  function_name = aws_lambda_function.lambda_function.arn
  principal     = each.value.principal

  source_arn = aws_cloudwatch_event_rule.daily_trigger_rule[each.key].arn
}