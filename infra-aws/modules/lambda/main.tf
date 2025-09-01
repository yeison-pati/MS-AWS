resource "aws_iam_role" "lambda_role" {
  name               = "lambda-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}


data "aws_iam_policy_document" "lambda_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}


resource "aws_lambda_function" "fn" {
  filename         = var.package_file # path to zip
  function_name    = "example-lambda-${var.environment}"
  role             = aws_iam_role.lambda_role.arn
  handler          = var.handler
  runtime          = var.runtime
  source_code_hash = filebase64sha256(var.package_file)
  timeout          = var.timeout
  memory_size      = var.memory_size
}


output "lambda_arn" { value = aws_lambda_function.fn.arn }
