resource "aws_api_gateway_rest_api" "this" {
name = "api-${var.environment}"
}


resource "aws_api_gateway_resource" "proxy" {
rest_api_id = aws_api_gateway_rest_api.this.id
parent_id = aws_api_gateway_rest_api.this.root_resource_id
path_part = "{proxy+}"
}


resource "aws_api_gateway_method" "any" {
rest_api_id = aws_api_gateway_rest_api.this.id
resource_id = aws_api_gateway_resource.proxy.id
http_method = "ANY"
authorization = "NONE"
}



output "api_id" { value = aws_api_gateway_rest_api.this.id }