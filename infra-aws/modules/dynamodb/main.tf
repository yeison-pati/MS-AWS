resource "aws_dynamodb_table" "example" {
  name         = "example-table-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"
  range_key    = "sk"


  attribute {
    name = "pk"
    type = "S"
  }
  attribute {
    name = "sk"
    type = "S"
  }


  ttl {
    attribute_name = "ttl"
    enabled        = false
  }


  tags = { Environment = var.environment }
}


output "dynamodb_table_name" { value = aws_dynamodb_table.example.name }
