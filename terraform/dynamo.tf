resource "aws_dynamodb_table" "collections" {
  name           = "${var.service_name}-collections"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "userId"
  range_key      = "id"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_table" "saved" {
  name           = "${var.service_name}-saved"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "userId"
  range_key      = "id"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "id"
    type = "S"
  }
}
