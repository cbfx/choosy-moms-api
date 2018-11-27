data "aws_acm_certificate" "ssl_cert_for_login" {
  domain       = "${local.login_cert_domain}"
  statuses     = ["ISSUED"]
  most_recent  = true
}

module "cognito_auth" {
  source  = "github.com/cbfx/terraform-aws-cognito-auth?ref=master"

  namespace                      = "${var.service_name}-auth"
  region                         = "${var.aws_region}"
  cognito_identity_pool_name     = "${var.service_name_readable} Admin"
  cognito_identity_pool_provider = "${local.login_domain}"
  api_stage                      = "${var.stage}"

  # Optional: Default UI
  app_hosted_zone_id             = "${data.aws_route53_zone.domain.zone_id}"
  app_certificate_arn            = "${data.aws_acm_certificate.ssl_cert_for_login.arn}"
  app_domain                     = "${local.login_domain}"
  app_origin                     = "${local.ui_domain}"

  # Optional: Email delivery
  ses_sender_address             = "${var.contact_email}"
}
