terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.46.0"
        }
    }
}

data "aws_iam_policy_document" "main" {
}

resource "aws_iam_role" "main" {
    assume_role_policy = data.aws_iam_policy_document.main.json
}

resource "aws_eks_cluster" "main" {
    name = "main"
    role_arn = aws_iam_role.main.arn
}