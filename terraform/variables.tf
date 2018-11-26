variable "aws_region" {
  type = "string"
  default = "us-east-1"
}

variable "service_name" {
  type = "string"
  default = "choosy_moms_api"
}

variable "api_domain" {
  type = "string"
  default = "gif.cbfx.net"
}

variable "swagger_file" {
  type = "string"
  default = "../swagger/api.yml"
}

variable "stage" {
  type = "string"
  default = "live"
}

locals {
  is_production = "${var.stage == "prod" ? 1 : 0}"
}

locals {
  deploy_domain = "${local.is_production ? format("api.%s", var.api_domain) : format("%s.api.%s", var.stage, var.api_domain)}"
  cert_domain   = "${local.is_production ? var.api_domain : format("*.%s", var.api_domain)}"
  domain_zone   = "${var.api_domain}"
}
