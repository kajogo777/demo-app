terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.46.0"
        }
    }
}

variable "aws_region" {
    default =  "eu-north-1" 
}

variable "aws_profile" {
    default =  "bubblegum" 
}

variable "tf_state_bucket_name" {
    default = "my-tf-test-bucket"
}

variable "tf_role_name" {
    default = "terraform-123"
}

variable "tf_repositories" {
    default = [
        "kajogo777/demo-app",
    ]
}

provider "aws" {
    profile = var.aws_profile
    region = var.aws_region
}

module "aws_github_oidc" {
    create_oidc_provider = true
    create_oidc_role = true
    oidc_role_attach_policies = [
        "arn:aws:iam::aws:policy/AdministratorAccess",
    ]
    repositories = var.tf_repositories
    role_name = var.tf_role_name
    source = "terraform-module/github-oidc-provider/aws"
    tags = {
        app = "terraform"
    }
    version = "2.2.0"
}

resource "aws_s3_bucket_versioning" "tf_state_bucket_versioning" {
    bucket = aws_s3_bucket.tf_state.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_acl" "tf_state_bucket_acl" {
    acl = "private"
    bucket = aws_s3_bucket.tf_state.id
}

resource "aws_dynamodb_table" "tf_state_lock" {
    attribute {
        name = "LockID"
        type = "S"
    }
    hash_key = "LockID"
    name = var.tf_state_bucket_name
    read_capacity = 1
    write_capacity = 1
}

resource "aws_s3_bucket" "tf_state" {
    bucket = var.tf_state_bucket_name
    lifecycle {
        prevent_destroy = true
    }
    tags = {
        app = "terraform"
    }
}