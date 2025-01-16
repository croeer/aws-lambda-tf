output "lambda_function_arn" {
  value = aws_lambda_function.this.invoke_arn
}

output "lambda_function_name" {
  value = aws_lambda_function.this.function_name
}

output "iam_role_name" {
  value = aws_iam_role.lambda_exec.name
}

output "function_url" {
  value = length(aws_lambda_function_url.lambda_url) > 0 ? aws_lambda_function_url.lambda_url[0].function_url : ""
}
