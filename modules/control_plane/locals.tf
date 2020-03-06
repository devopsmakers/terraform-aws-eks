locals {
  cluster_security_group_id = var.cluster_create_security_group ? join("", aws_security_group.cluster.*.id) : var.cluster_security_group_id
  cluster_iam_role_name     = var.manage_cluster_iam_resources ? join("", aws_iam_role.cluster.*.name) : var.cluster_iam_role_name
  cluster_iam_role_arn      = var.manage_cluster_iam_resources ? join("", aws_iam_role.cluster.*.arn) : join("", data.aws_iam_role.custom_cluster_iam_role.*.arn)
  kubeconfig_name           = var.kubeconfig_name == "" ? "eks_${var.cluster_name}" : var.kubeconfig_name
}
