terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.50.0"
        }
    }
}

provider "aws" {
    region = "us-west-2"
}

resource "aws_iam_role" "main" {
}

resource "aws_eks_cluster" "example" {
    depends_on = [
        aws_iam_role_policy_attachment.example,
    ]
    name = "example"
    role_arn = aws_iam_role.example.arn
    vpc_config {
        subnet_ids = [
            aws_subnet.example.id,
        ]
    }
}

resource "aws_vpc" "example" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_iam_role" "example" {
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "eks.amazonaws.com"
          }
        }]
      })
    description = "EKS cluster role"
    name = "example"
}

resource "aws_subnet" "example" {
    availability_zone = "us-west-2a"
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.example.id
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
    role = aws_iam_role.example.name
}

resource "aws_iam_role_policy_attachment" "example" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.example.name
}

resource "aws_eks_cluster" "main" {
    name = "main"
    role_arn = aws_iam_role.main.arn
}