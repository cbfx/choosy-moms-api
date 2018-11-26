output "function_arn" {
  value = "${aws_lambda_function.lambda_function.arn}"
}

output "alias_arn" {
  value = "${aws_lambda_alias.lambda_alias.arn}"
}

output "function_name" {
  value = "${aws_lambda_function.lambda_function.function_name}"
}

output "invocation_arn" {
  value = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_alias.lambda_alias.arn}/invocations"
}
