variable "deploy_region" {
    description = "Enter the region to deploy the lambda"
    type = string
    default = "us-east-1"
}

variable "lambda_function_name" {
    description = "Enter the name of lambda function"
    type = string 
    default = "sample-lambda-function"
}

variable "vpc_id" {
    description = "Enter the vpc id"
    type = string
    default = "vpc-XXXXX"
}

variable "public_subnet" {
    description = "Enter the vpc id"
    type = string
    default = "subnet-XXXX"
}
