terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.51.1"
        }
    }
}

output "kubeconfig-certificate-authority-data" {
    value = aws_eks_cluster.example.certificate_authority[0].data
}

output "endpoint" {
    value = aws_eks_cluster.example.endpoint
}