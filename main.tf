variable "tags" {
    default = {
        Environment = "dev"
        Owner = "my-team"
    }
    type = map(string)
}

variable "vpc_config" {
    default = {
        endpoint_private_access = true
        endpoint_public_access = true
        public_access_cidrs = [
            "0.0.0.0/0",
        ]
        security_group_ids = [
            "sg-12345678",
        ]
        subnet_ids = [
            "subnet-12345678",
        ]
    }
    type = object({
        endpoint_private_access = bool
        endpoint_public_access = bool
        public_access_cidrs = list(string)
        security_group_ids = list(string)
        subnet_ids = list(string)
      })
}

variable "enabled_cluster_log_types" {
    default = [
        "api",
        "audit",
    ]
    type = list(string)
}

variable "cluster_name" {
    default = "my-eks-cluster"
    type = string
}

variable "role_arn" {
    default = "arn:aws:iam::123456789012:role/my-eks-cluster-role"
    type = string
}

variable "kubernetes_network_config" {
    default = {
        ip_family = "ipv4"
        service_ipv4_cidr = "10.100.0.0/16"
    }
    type = object({
        ip_family = string
        service_ipv4_cidr = string
      })
}

resource "aws_cloudwatch_log_group" "example" {
    name = "/aws/eks/${var.cluster_name}/cluster"
    retention_in_days = 7
}

resource "aws_eks_cluster" "this" {
    enabled_cluster_log_types = var.enabled_cluster_log_types
    kubernetes_network_config {
        ip_family = var.kubernetes_network_config.ip_family
        service_ipv4_cidr = var.kubernetes_network_config.service_ipv4_cidr
    }
    name = var.cluster_name
    role_arn = var.role_arn
    tags = var.tags
    vpc_config {
        endpoint_private_access = var.vpc_config.endpoint_private_access
        endpoint_public_access = var.vpc_config.endpoint_public_access
        public_access_cidrs = var.vpc_config.public_access_cidrs
        security_group_ids = var.vpc_config.security_group_ids
        subnet_ids = var.vpc_config.subnet_ids
    }
}