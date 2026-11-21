locals {
  name_prefix = "${var.project_name}-${var.environment}"
  tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket" "landing" {
  bucket = "${local.name_prefix}-landing"
  tags   = local.tags
}

resource "aws_sqs_queue" "events" {
  name                       = "${local.name_prefix}-events"
  visibility_timeout_seconds = 30
  tags                       = local.tags
}

resource "aws_iam_role" "lambda_role" {
  name = "${local.name_prefix}-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
  tags = local.tags
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "${local.name_prefix}-lambda-policy"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["sqs:SendMessage"]
        Resource = aws_sqs_queue.events.arn
      }
    ]
  })
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda.zip"
  source {
    filename = "index.py"
    content  = file("${path.module}/lambda.py")
  }
}

resource "aws_lambda_function" "notify" {
  function_name    = "${local.name_prefix}-notify"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  runtime          = "python3.12"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  environment {
    variables = { QUEUE_URL = aws_sqs_queue.events.id }
  }
  tags             = local.tags
}

output "bucket_name" { value = aws_s3_bucket.landing.bucket }
output "queue_url"   { value = aws_sqs_queue.events.id }
output "lambda_name" { value = aws_lambda_function.notify.function_name }
output "lambda_role" { value = aws_iam_role.lambda_role.arn }
