resource "aws_eks_cluster" "main" {
    name = "main"
    role_arn = aws_iam_role.main.arn
}