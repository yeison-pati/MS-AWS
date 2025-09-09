terraform {
  backend "s3" {
    bucket         = "ms-aws-terraform-state-bucket"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
