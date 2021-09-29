resource "aws_iam_user" "ecr-user" {
  name = "ecr-pull-user"
  path = "/system/"
}

resource "aws_iam_access_key" "ec2-user-access-key" {
  user = aws_iam_user.ecr-user.name
}

resource "aws_iam_user_policy" "ecrro" {
    name = "policy-for-ecrro"
    user = aws_iam_user.ecr-user.id
    
    policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
    "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:DescribeRepositories",
        "ecr:GetRepositoryPolicy",
        "ecr:ListImages",
        "ecr:BatchCheckLayerAvailability"
    ],
    "Effect": "Allow",
    "Resource": "*"
    }
]
}
EOF
}