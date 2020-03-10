output "aws_auth_roles" {
  description = "Roles for use in aws-auth ConfigMap"
  value = [
    for k, v in local.worker_groups_expanded : {
      instance_role_arn = lookup(v, "iam_role_arn", aws_iam_role.workers[0].arn)
      platform          = v["platform"]
    }
  ]
}
