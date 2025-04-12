provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "inspector_lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "inspector_auto_triage" {
  function_name = "inspector-auto-triage"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "handler.lambda_handler"
  runtime       = "python3.11"
  timeout       = 10

  filename         = "${path.module}/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda.zip")
}

resource "aws_cloudwatch_event_rule" "inspector_findings" {
  name        = "inspector-findings-trigger"
  description = "Trigger Lambda on new Inspector finding"
  event_pattern = jsonencode({
    source = ["aws.inspector2"],
    "detail-type" = ["Inspector2 Finding"]
  })
}

resource "aws_cloudwatch_event_target" "trigger_lambda" {
  rule      = aws_cloudwatch_event_rule.inspector_findings.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.inspector_auto_triage.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.inspector_auto_triage.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.inspector_findings.arn
}
