resource "aws_s3_bucket_object" "lambda_package_object" {
  bucket = "${var.bucket}"
  key    = "${basename(var.package)}"
  source = "${pathexpand(var.package)}"
  etag = "${md5(file(pathexpand(var.package)))}"
}

resource "aws_lambda_function" "lambda_function" {
  function_name = "${var.service_name}-${var.name}"
  s3_bucket = "${var.bucket}"
  s3_key    = "${basename(var.package)}"
  s3_object_version = "${aws_s3_bucket_object.lambda_package_object.version_id}"
  # used to trigger updates
  source_code_hash = "${base64sha256(file(pathexpand(var.package)))}"
  handler = "${var.handler}"
  runtime = "nodejs8.10"
  role = "${var.role}"
  environment {
    variables= "${var.environment_variables}"
  }
}

resource "aws_lambda_alias" "lambda_alias" {
  name             = "${var.alias}"
  function_name    = "${aws_lambda_function.lambda_function.arn}"
  function_version = "${aws_lambda_function.lambda_function.version}"
  depends_on = ["aws_lambda_function.lambda_function"]
}
