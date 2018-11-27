data "aws_acm_certificate" "ssl_cert" {
  domain       = "${local.api_cert_domain}"
  statuses     = ["ISSUED"]
  most_recent  = true
}
