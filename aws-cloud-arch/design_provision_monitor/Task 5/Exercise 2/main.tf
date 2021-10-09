provider "aws" {
  region = var.deploy_region
}

resource "aws_instance" "t2micro" {
    count = 2
    ami               = "ami-087c17d1fe0178315"
    instance_type     = "t2.micro"
    availability_zone = "us-east-1f"
    subnet_id = var.public_subnet

    tags = {
    Name = "Udacity T2 micro ${count.index + 1}"
    }
}

# resource "aws_instance" "m4large" {
#     count = 2
#     ami               = "ami-087c17d1fe0178315"
#     instance_type     = "m4.large"
#     availability_zone = "us-east-1f"
#     subnet_id = var.public_subnet

#     tags = {
#     Name = "Udacity M4 ${count.index + 1}"
#     }
# }

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "lambda" {
    filename = "greet_lambda.py.zip"
    function_name = var.lambda_function_name
    role = aws_iam_role.iam_for_lambda.arn
    handler = "greet_lambda.lambda_handler"
    source_code_hash = filebase64sha256("greet_lambda.py.zip")
    
    runtime = "python3.8"
    environment {
      variables = {
          "greeting" = "hello!"
      } 
    }

    depends_on = [
        aws_iam_role_policy_attachment.lambda_logs,
        aws_cloudwatch_log_group.example,
    ]
}


resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}