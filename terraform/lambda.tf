resource "aws_s3_bucket" "lambdas" {
  bucket = "${var.service_name}-lambdas"
  versioning {
    enabled = true
  }
}

data "aws_iam_policy_document" "lambda_exec" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
        "apigateway.amazonaws.com",
      ]
    }
    actions = [
      "sts:AssumeRole",
    ]
  }
}

data "aws_iam_policy_document" "base_lambda_policy" {
  statement {
    actions = [
      "logs:*",
      "lambda:InvokeFunction",
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.service_name}_lambda"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_exec.json}"
}

resource "aws_iam_role_policy" "base_lambda_policy" {
  name   = "${var.service_name}_lambda_policy"
  role   = "${aws_iam_role.lambda_exec.id}"
  policy = "${data.aws_iam_policy_document.base_lambda_policy.json}"
}

module "giphy_lambda" {
  source = "./modules/lambda"
  alias = "${var.stage}"
  service_name = "${var.service_name}"
  name =  "giphy"
  package = "../build/giphy.zip"
  aws_region = "${var.aws_region}"
  role = "${aws_iam_role.lambda_exec.arn}"
  bucket = "${aws_s3_bucket.lambdas.id}"
  environment_variables = {
    GIPHY_API_KEY = "${var.giphy_api_key}"
  }
}

module "users_lambda" {
  source = "./modules/lambda"
  alias = "${var.stage}"
  service_name = "${var.service_name}"
  name =  "users"
  package = "../build/users.zip"
  aws_region = "${var.aws_region}"
  role = "${aws_iam_role.lambda_exec.arn}"
  bucket = "${aws_s3_bucket.lambdas.id}"
}

module "collections_lambda" {
  source = "./modules/lambda"
  alias = "${var.stage}"
  service_name = "${var.service_name}"
  name =  "collections"
  package = "../build/collections.zip"
  aws_region = "${var.aws_region}"
  role = "${aws_iam_role.lambda_exec.arn}"
  bucket = "${aws_s3_bucket.lambdas.id}"
}

module "saved_lambda" {
  source = "./modules/lambda"
  alias = "${var.stage}"
  service_name = "${var.service_name}"
  name =  "saved"
  package = "../build/saved.zip"
  aws_region = "${var.aws_region}"
  role = "${aws_iam_role.lambda_exec.arn}"
  bucket = "${aws_s3_bucket.lambdas.id}"
}
