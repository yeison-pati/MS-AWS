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


resource "aws_api_gateway_integration" "lambda" {
rest_api_id = aws_api_gateway_rest_api.this.id
resource_id = aws_api_gateway_resource.proxy.id
http_method = aws_api_gateway_method.any.http_method
integration_http_method = "POST"
type = "AWS_PROXY"
uri = var.lambda_invoke_arn
}


output "api_id" { value = aws_api_gateway_rest_api.this.id }