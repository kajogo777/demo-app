terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.51.1"
        }
    }
}

provider "aws" {
    region = "us-west-2"
}

resource "aws_iam_role_policy_attachment" "example-CloudWatchAgentServerPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
    role = aws_iam_role.example.name
}

resource "aws_iam_role" "example" {
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Action = "sts:AssumeRole"
          Principal = {
            Service = "eks.amazonaws.com"
          }
          Effect = "Allow"
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

resource "aws_vpc" "example" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.example.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSVPCResourceControllerPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceControllerPolicy"
    role = aws_iam_role.example.name
}

resource "aws_eks_cluster" "example" {
    name = "example"
    role_arn = aws_iam_role.example.arn
    vpc_config {
        subnet_ids = [
            aws_subnet.example.id,
        ]
    }
}

resource "aws_iam_role" "main" {
}

resource "aws_eks_cluster" "main" {
    role_arn = aws_iam_role.main.arn
}

output "kubeconfig-certificate-authority-data" {
    value = aws_eks_cluster.example.certificate_authority[0].data
}

output "endpoint" {
    value = aws_eks_cluster.example.endpoint
}