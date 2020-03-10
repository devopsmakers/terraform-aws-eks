output "cluster_id" {
  description = "The name/id of the EKS cluster."
  value       = module.control_plane.cluster_id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster."
  value       = module.control_plane.cluster_arn
}

output "cluster_certificate_authority_data" {
  description = "Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster."
  value       = module.control_plane.cluster_certificate_authority_data
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API."
  value       = module.control_plane.cluster_endpoint
}

output "cluster_version" {
  description = "The Kubernetes server version for the EKS cluster."
  value       = module.control_plane.cluster_version
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster."
  value       = module.control_plane.cluster_security_group_id
}

output "config_map_aws_auth" {
  description = "A kubernetes configuration to authenticate to this EKS cluster."
  value       = module.aws_auth.config_map_aws_auth
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster."
  value       = module.control_plane.cluster_iam_role_arn
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster OIDC Issuer"
  value       = module.control_plane.cluster_oidc_issuer_url
}

output "cloudwatch_log_group_name" {
  description = "Name of cloudwatch log group created"
  value       = module.control_plane.cloudwatch_log_group_name
}

output "kubeconfig" {
  description = "kubectl config file contents for this EKS cluster."
  value       = module.control_plane.kubeconfig
}

output "kubeconfig_filename" {
  description = "The filename of the generated kubectl config."
  value       = module.control_plane.kubeconfig_filename
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider if `enable_irsa = true`."
  value       = module.control_plane.oidc_provider_arn
}

output "workers_asg_arns" {
  description = "IDs of the autoscaling groups containing workers."
  value       = module.worker_groups.workers_asg_arns
}

output "workers_asg_names" {
  description = "Names of the autoscaling groups containing workers."
  value       = module.worker_groups.workers_asg_names
}

output "workers_user_data" {
  description = "User data of worker groups"
  value       = module.worker_groups.workers_user_data
}

output "workers_default_ami_id" {
  description = "ID of the default worker group AMI"
  value       = module.worker_groups.workers_default_ami_id
}

output "workers_launch_template_ids" {
  description = "IDs of the worker launch templates."
  value       = module.worker_groups.workers_launch_template_ids
}

output "workers_launch_template_arns" {
  description = "ARNs of the worker launch templates."
  value       = module.worker_groups.workers_launch_template_arns
}

output "workers_launch_template_latest_versions" {
  description = "Latest versions of the worker launch templates."
  value       = module.worker_groups.workers_launch_template_latest_versions
}

output "worker_security_group_id" {
  description = "Security group ID attached to the EKS workers."
  value       = module.worker_groups.worker_security_group_id
}

output "worker_iam_instance_profile_arns" {
  description = "default IAM instance profile ARN for EKS worker groups"
  value       = module.worker_groups.worker_iam_instance_profile_arns
}

output "worker_iam_instance_profile_names" {
  description = "default IAM instance profile name for EKS worker groups"
  value       = module.worker_groups.worker_iam_instance_profile_names
}

output "worker_iam_role_name" {
  description = "default IAM role name for EKS worker groups"
  value       = module.worker_groups.worker_iam_role_name
}

output "worker_iam_role_arn" {
  description = "default IAM role ARN for EKS worker groups"
  value       = module.worker_groups.worker_iam_role_arn
}

output "node_groups" {
  description = "Outputs from EKS node groups. Map of maps, keyed by var.node_groups keys"
  value       = module.node_groups.node_groups
}
