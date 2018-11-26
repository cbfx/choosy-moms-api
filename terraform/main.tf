provider "template" {
  version = "~> 1.0"
}

provider "aws" {
  region = "${var.aws_region}"
  version = "~> 1.24"
}

terraform {
  backend "s3" {
    encrypt = true
    bucket = "terraform-state-bucket-choosy-moms"
    key = "states/choosy-moms-api.tfstate"
    region = "us-east-1"
  }
}
