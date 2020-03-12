output "aws_auth_roles" {
  description = "Roles for use in aws-auth ConfigMap"
  value = [
    for k, v in local.worker_groups_expanded : {
      instance_role_arn = lookup(v, "iam_role_arn", try(aws_iam_role.worker_groups[0].arn, ""))
      platform          = v["platform"]
    }
  ]
}

output "workers_asg_arns" {
  description = "IDs of the autoscaling groups containing workers."
  value       = values(aws_autoscaling_group.worker_groups).*.arn
}

output "workers_asg_names" {
  description = "Names of the autoscaling groups containing workers."
  value       = values(aws_autoscaling_group.worker_groups).*.id
}

output "workers_user_data" {
  description = "User data of worker groups"
  value       = values(data.template_file.launch_template_userdata).*.rendered
}

output "workers_default_ami_id" {
  description = "ID of the default worker group AMI"
  value       = data.aws_ami.eks_worker.id
}

output "workers_launch_template_ids" {
  description = "IDs of the worker launch templates."
  value       = values(aws_launch_template.worker_groups).*.id
}

output "workers_launch_template_arns" {
  description = "ARNs of the worker launch templates."
  value       = values(aws_launch_template.worker_groups).*.arn
}

output "workers_launch_template_latest_versions" {
  description = "Latest versions of the worker launch templates."
  value       = values(aws_launch_template.worker_groups).*.latest_version
}

output "worker_security_group_id" {
  description = "Security group ID attached to the EKS workers."
  value       = local.worker_security_group_id
}

output "worker_iam_instance_profile_arns" {
  description = "default IAM instance profile ARN for EKS worker groups"
  value       = values(aws_iam_instance_profile.worker_groups).*.arn
}

output "worker_iam_instance_profile_names" {
  description = "default IAM instance profile name for EKS worker groups"
  value       = values(aws_iam_instance_profile.worker_groups).*.name
}

output "worker_iam_role_name" {
  description = "default IAM role name for EKS worker groups"
  value = coalescelist(
    aws_iam_role.worker_groups.*.name,
    values(data.aws_iam_instance_profile.custom_worker_group_launch_template_iam_instance_profile).*.role_name,
    [""]
  )[0]
}

output "worker_iam_role_arn" {
  description = "default IAM role ARN for EKS worker groups"
  value = coalescelist(
    aws_iam_role.worker_groups.*.arn,
    values(data.aws_iam_instance_profile.custom_worker_group_launch_template_iam_instance_profile).*.role_arn,
    [""]
  )[0]
}
