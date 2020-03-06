output "cluster_id" {
  description = "The name/id of the EKS cluster."
  value       = element(concat(aws_eks_cluster.this.*.id, list("")), 0)
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster."
  value       = element(concat(aws_eks_cluster.this.*.arn, list("")), 0)
}

output "cluster_certificate_authority_data" {
  description = "Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster."
  value       = element(concat(aws_eks_cluster.this[*].certificate_authority[0].data, list("")), 0)
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API."
  value       = element(concat(aws_eks_cluster.this.*.endpoint, list("")), 0)
}

output "cluster_version" {
  description = "The Kubernetes server version for the EKS cluster."
  value       = element(concat(aws_eks_cluster.this[*].version, list("")), 0)
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster."
  value       = local.cluster_security_group_id
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster."
  value       = local.cluster_iam_role_arn
}
