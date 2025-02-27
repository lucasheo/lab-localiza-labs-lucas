
locals {
  viewer_request_lambda  = "viewer_request_lambda"
  origin_response_lambda = "origin_response_lambda"
}

resource "aws_iam_role" "lambda_role" {

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
            "lambda.amazonaws.com",
            "edgelambda.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_cloudwatch_log_group" "terraform_lambda_edge_python_log_group" {
  name              = "/aws/lambda/us-east-1.terraform_lambda_edge_python"
  retention_in_days = 14
  tags = {
    Use         = "site-localiza"
    Type        = "static website"
    Environment = "dev"
    Name        = "lambda_edge_cloudfront_terraform"
  }
}

resource "aws_iam_policy" "lambda_logging" {
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

data "archive_file" "origin_response_lambda" {
  type        = "zip"
  source_file = "../lambda/origin_response.py"
  output_path = "origin_response_lambda.zip"
}

resource "aws_lambda_function" "origin_response_lambda" {
  depends_on    = [aws_iam_role_policy_attachment.lambda_logs]
  filename      = data.archive_file.origin_response_lambda.output_path
  function_name = local.origin_response_lambda
  role          = aws_iam_role.lambda_role.arn
  handler       = "origin_response.handler"

  source_code_hash = filebase64sha256(data.archive_file.origin_response_lambda.output_path)

  runtime = "python3.7"

  publish = true

  vpc_config {
    subnet_ids         = [aws_subnet.subnet_private.id]
    security_group_ids = [aws_default_security_group.default_security_group.id]
  }

   tags = var.tags
   
}

data "archive_file" "viewer_request_lambda" {
  type        = "zip"
  source_file = "./lambda/src/viewer_request.py"
  output_path = "viewer_request_lambda.zip"
}

resource "aws_lambda_function" "viewer_request_lambda" {
  depends_on    = [aws_iam_role_policy_attachment.lambda_logs]
  filename      = data.archive_file.viewer_request_lambda.output_path
  function_name = local.viewer_request_lambda
  role          = aws_iam_role.lambda_role.arn
  handler       = "viewer_request.handler"

  source_code_hash = filebase64sha256(data.archive_file.viewer_request_lambda.output_path)

  runtime = "python3.7"

  publish = true

  vpc_config {
    subnet_ids         = [aws_subnet.subnet_private.id]
    security_group_ids = [aws_default_security_group.default_security_group.id]
   }

  tags = var.tags
  
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_lambda_basic_execution" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}