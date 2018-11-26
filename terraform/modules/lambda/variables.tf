variable "alias" {}

variable "name" {}

variable "package" {}

variable "aws_region" {}

variable "role" {}

variable "bucket" {}

variable "handler" {
  default = "index.handler"
}

variable "environment_variables" {
  type = "map"
  default = {
    NOT = "EMPTY"
  }
}
