locals {
  node_group_defaults = {
    iam_role_arn     = concat(aws_iam_role.node_groups.*.arn, [""])[0]
    instance_type    = "m4.large"  # Size of the node group instances.
    desired_capacity = "1"         # Desired node group capacity in the autoscaling group. Note: Ignored on change. Hint: Use the Cluster Autoscaler.
    max_capacity     = "3"         # Maximum node group capacity in the autoscaling group.
    min_capacity     = "1"         # Minimum node group capacity in the autoscaling group. Note: Should =< desired_capacity
    key_name         = ""          # The key name that should be used for the instances in the autoscaling group
    subnets          = var.subnets # A list of subnets to place the nodes in. i.e. ["subnet-123", "subnet-456", "subnet-789"]
  }

  # Merge defaults and per-group values to make code cleaner
  node_groups_expanded = { for k, v in var.node_groups : k => merge(
    local.node_group_defaults,
    var.node_groups_defaults,
    v,
  ) if var.create_eks }
}
