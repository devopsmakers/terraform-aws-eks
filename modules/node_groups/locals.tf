locals {
  # Merge defaults and per-group values to make code cleaner
  node_groups_expanded = { for k, v in var.node_groups : k => merge(
    {
      iam_role_arn     = aws_iam_role.node_groups[0].arn
      instance_type    = "m4.large"  # Size of the node group instances.
      desired_capacity = "1"         # Desired node capacity in the autoscaling group and changing its value will not affect the autoscaling group's desired capacity because the cluster-autoscaler manages up and down scaling of the nodes. Cluster-autoscaler add nodes when pods are in pending state and remove the nodes when they are not required by modifying the desirec_capacity of the autoscaling group. Although an issue exists in which if the value of the asg_min_size is changed it modifies the value of asg_desired_capacity.
      max_capacity     = "3"         # Maximum node group capacity in the autoscaling group.
      min_capacity     = "1"         # Minimum node group capacity in the autoscaling group. NOTE: Change in this paramater will affect the asg_desired_capacity, like changing its value to 2 will change asg_desired_capacity value to 2 but bringing back it to 1 will not affect the asg_desired_capacity.
      key_name         = ""          # The key name that should be used for the instances in the autoscaling group
      subnets          = var.subnets # A list of subnets to place the nodes in. i.e. ["subnet-123", "subnet-456", "subnet-789"]
    },
    var.node_groups_defaults,
    v,
  ) if var.create_eks }
}
