variable "aws_region" {
  type = "string"
  default = "us-east-1"
}

variable "service_name" {
  type = "string"
  default = "choosy-moms-api"
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
  api_url = "${format("api.%s", var.api_domain)}"
}

locals {
  deploy_domain = "${local.is_production ? local.api_url : format("%s.%s", var.stage, local.api_url)}"
  cert_domain   = "${local.is_production ? local.api_url : format("*.%s", local.api_url)}"
  domain_zone   = "${var.api_domain}"
}
