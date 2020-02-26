provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_policy" "policy" {
  name = "test_policy"
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Effect" : "Allow",
      "Action" : [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource" : "arn:aws:logs:*:*:*"
    },
    {
      "Effect" : "Allow",
      "Action" : [
        "ec2:Start*",
        "ec2:Stop*",
        "ec2:*"
      ],
      "Resource" : "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_role"
  assume_role_policy = <<EOF
{
    "Version" : "2012-10-17",
    "Statement" : {
        "Effect" : "Allow",
        "Principal" : {"Service" : "lambda.amazonaws.com"},
        "Action" : "sts:AssumeRole"
      }
}
  EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  #name = "test-attach"
  role = "lambda_role"
  policy_arn = "arn:aws:iam::620636132257:policy/test_policy"
}

resource "aws_lambda_function" "start_instance" {
  #role = "aws_iam_role.lambda_exec_role.arn"
  role = "arn:aws:iam::620636132257:role/lambda_role"
  handler = "start_instance.lambda_handler"
  runtime = "python3.6"
  filename = "start_instance.py.zip"
  function_name = "myStart"
}

resource "aws_lambda_function" "stop_instance" {
  #role = "aws_iam_role.lambda_exec_role.arn"
  role = "arn:aws:iam::620636132257:role/lambda_role"
  handler = "stop_instance.lambda_handler"
  runtime = "python3.6"
  filename = "stop_instance.py.zip"
  function_name = "myStop"
}

resource "aws_cloudwatch_event_rule" "cron_start" {
  name = "cron_start"
  schedule_expression = "cron(5 20 ? * MON-FRI *)"
}

resource "aws_cloudwatch_event_rule" "cron_stop" {
  name = "cron_stop"
  schedule_expression = "cron(5 19 ? * MON-FRI *)"
}

resource "aws_cloudwatch_event_target" "run_start_lambda" {
  rule = "cron_start"
  target_id = "aws_lambda_function.start_instance.id"
  arn = "arn:aws:lambda:us-east-1:620636132257:function:myStart"
}

resource "aws_cloudwatch_event_target" "run_stop_lambda" {
  rule = "cron_stop"
  target_id = "aws_lambda_function.stop_instance.id"
  arn = "arn:aws:lambda:us-east-1:620636132257:function:myStop"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  action = "lambda:InvokeFunction"
  function_name = "myStart"
  source_arn    = "arn:aws:events:us-east-1:620636132257:rule/cron_start"
  principal = "events.amazonaws.com"
}

resource "aws_lambda_permission" "allow_cloudwatch_2" {
  action = "lambda:InvokeFunction"
  function_name = "myStop"
  source_arn    = "arn:aws:events:us-east-1:620636132257:rule/cron_stop"
  principal = "events.amazonaws.com"
}
