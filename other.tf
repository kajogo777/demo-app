resource "aws_iam_role" "example" {
    assume_role_policy = jsonencode({
            Version = "2012-10-17"
            Statement = [
              {
                Action = "sts:AssumeRole"
                Principal = {
                  Service = "eks.amazonaws.com"
                }
                Effect = "Allow"
              }
            ]
          })
    description = "EKS cluster role"
    name = "example"
}