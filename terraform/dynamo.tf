resource "aws_dynamodb_table" "collections" {
  name           = "${replace(var.service_name_readable, " ", "")}.Collections.V1"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "user_id"
  range_key      = "id"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_table" "saved" {
  name           = "${replace(var.service_name_readable, " ", "")}.Saved.V1"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "user_id"
  range_key      = "id"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "id"
    type = "S"
  }
}
