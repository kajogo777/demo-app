variable "myvar" {
    default = "example"
}

provider "aws" {
    region = "us-west-2"
}

data "aws_iam_policy_document" "main" {
}

resource "aws_cloudwatch_log_stream" "example" {
    log_group_name = aws_cloudwatch_log_group.example.name
    name = "example"
}

resource "aws_cloudwatch_log_group" "example" {
    name = var.myvar
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.example.name
}

resource "aws_vpc" "example" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example" {
    availability_zone = "us-west-2a"
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.example.id
}

resource "aws_iam_role_policy_attachment" "example-CloudWatchAgentServerPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
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
    assume_role_policy = data.aws_iam_policy_document.main.json
}