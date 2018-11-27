variable "aws_region" {
  type = "string"
  default = "us-east-1"
}

variable "service_name" {
  type = "string"
  default = "choosy-moms-api"
}

variable "service_name_readable" {
  type = "string"
  default = "Choosy Moms API"
}

variable "api_domain" {
  type = "string"
  default = "gif.cbfx.net"
}

variable "swagger_file" {
  type = "string"
  default = "../swagger/api.yml"
}

variable "contact_email" {
  type = "string"
  default = "infra@cbfx.net"
}

variable "stage" {
  type = "string"
  default = "live"
}

locals {
  is_production = "${var.stage == "prod" ? 1 : 0}"
}

locals {
  api_url = "${format("api.%s", var.api_domain)}"
  login_url = "${format("login.%s", var.api_domain)}"
}

locals {
  login_domain          = "${local.is_production ? local.login_url : format("%s-%s", var.stage, local.login_url)}"
  login_cert_domain     = "${format("*.%s", var.api_domain)}"
  api_deploy_domain     = "${local.is_production ? local.api_url : format("%s-%s", var.stage, local.api_url)}"
  api_cert_domain       = "${format("*.%s", var.api_domain)}"
  api_domain_zone       = "${var.api_domain}"
  ui_domain             = "${local.is_production ? var.api_domain : format("%s.%s", var.stage, var.api_domain)}"
}
