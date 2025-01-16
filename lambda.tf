data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "lambda-bucket" {
  bucket = "lambda-${var.function_name}-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_object" "package" {
  bucket = aws_s3_bucket.lambda-bucket.bucket
  key    = "${var.function_name}.zip"
  source = var.zipfile_name
  etag   = filemd5(var.zipfile_name)
}

resource "aws_lambda_function" "this" {
  function_name    = var.function_name
  s3_bucket        = aws_s3_bucket.lambda-bucket.bucket
  s3_key           = aws_s3_object.package.key
  source_code_hash = filebase64sha256(var.zipfile_name)

  handler = var.handler_name
  runtime = var.runtime

  role        = aws_iam_role.lambda_exec.arn
  memory_size = var.memory_size
  layers      = var.layers

  package_type = "Zip"

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) == 0 ? [] : [true]
    content {
      variables = var.environment_variables
    }
  }

}

resource "aws_lambda_function_url" "lambda_url" {
  count = var.create_function_url ? 1 : 0
  
  function_name      = aws_lambda_function.this.function_name
  authorization_type = "NONE"
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.function_name}_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "function_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_iam_policy" "function_logging_policy" {
  name = "${var.function_name}-logging-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect : "Allow",
        Resource : "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "function_logging_policy_attachment" {
  role       = aws_iam_role.lambda_exec.id
  policy_arn = aws_iam_policy.function_logging_policy.arn
}
