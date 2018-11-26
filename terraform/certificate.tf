data "aws_acm_certificate" "ssl_cert" {
  domain       = "${local.cert_domain}"
  statuses     = ["ISSUED"]
  most_recent  = true
}
