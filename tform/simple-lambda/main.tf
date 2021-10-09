provider "aws" {
  region = var.deploy_region
}

data "archive_file" "Zip-Lambda-Function" {
  type        = "zip"
  source_file = "lambda-source/greet_lambda.py"
  output_path = "lambda-src.zip"
}