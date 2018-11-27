data "aws_iam_policy_document" "api_gateway_invoker" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_invoke" {
  statement {
    actions = [
      "logs:*",
      "lambda:InvokeFunction",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "api_gateway_invoker" {
  name               = "${var.service_name}_${var.stage}_APIGatewayInvoker"
  assume_role_policy = "${data.aws_iam_policy_document.api_gateway_invoker.json}"
}

resource "aws_iam_role_policy" "lambda_invoke_policy" {
  name   = "${var.service_name}_lambda_invoke"
  role   = "${aws_iam_role.api_gateway_invoker.id}"
  policy = "${data.aws_iam_policy_document.lambda_invoke.json}"
}

data "template_file" "swagger_file" {
  template = "${file(pathexpand(var.swagger_file))}"

  vars {
    invoker_role                = "${aws_iam_role.api_gateway_invoker.arn}"
    giphy_invocation_arn        = "${module.giphy_lambda.invocation_arn}"
    users_invocation_arn        = "${module.users_lambda.invocation_arn}"
    collections_invocation_arn  = "${module.collections_lambda.invocation_arn}"
    saved_invocation_arn        = "${module.saved_lambda.invocation_arn}"
    stage                       = "${var.stage}"
    cognito_user_pool_arn      =  "${module.cognito_auth.cognito_user_pool_arn}"
  }
}

resource "aws_api_gateway_rest_api" "rest_api" {
  name               = "${var.service_name}_${var.stage}"
  body               = "${data.template_file.swagger_file.rendered}"
  description        = "${var.service_name} (stage: ${var.stage})"
}

resource "aws_api_gateway_deployment" "rest_api" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  stage_name  = "${var.stage}"
  variables = {
    "swaggerMd5" = "${md5(data.template_file.swagger_file.rendered)}"
  }
  # https://github.com/hashicorp/terraform/issues/10674#issuecomment-290767062
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_domain_name" "api_domain" {
  domain_name     = "${local.api_deploy_domain}"
  certificate_arn = "${data.aws_acm_certificate.ssl_cert.arn}"
}

resource "aws_api_gateway_base_path_mapping" "api_basepath" {
  api_id      = "${aws_api_gateway_rest_api.rest_api.id}"
  stage_name  = "${aws_api_gateway_deployment.rest_api.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.api_domain.domain_name}"
}

data "aws_route53_zone" "domain" {
  name  = "${local.api_domain_zone}."
}

resource "aws_route53_record" "api_custom_domain_record" {
  zone_id = "${data.aws_route53_zone.domain.zone_id}"
  name    = "${aws_api_gateway_domain_name.api_domain.domain_name}"
  type    = "A"

  alias {
    name = "${aws_api_gateway_domain_name.api_domain.cloudfront_domain_name}"
    zone_id = "${aws_api_gateway_domain_name.api_domain.cloudfront_zone_id}"
    # You cannot set this to true for Cloudfront targets.
    evaluate_target_health = false
  }
}

output "swagger" {
  value = "${data.template_file.swagger_file.rendered}"
}

output "base_url" {
  value = "${aws_api_gateway_deployment.rest_api.invoke_url}"
}
