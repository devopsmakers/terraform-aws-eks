locals {
  cluster_security_group_id = var.cluster_create_security_group ? aws_security_group.cluster.0.id : var.cluster_security_group_id
  cluster_iam_role_name     = var.manage_cluster_iam_resources ? aws_iam_role.cluster.0.name : var.cluster_iam_role_name
  cluster_iam_role_arn      = var.manage_cluster_iam_resources ? aws_iam_role.cluster.0.arn : data.aws_iam_role.custom_cluster_iam_role.0.arn
  kubeconfig_name           = var.kubeconfig_name == "" ? "eks_${var.cluster_name}" : var.kubeconfig_name
}
