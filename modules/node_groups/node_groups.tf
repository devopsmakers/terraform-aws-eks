resource "aws_eks_node_group" "node_groups" {
  for_each = local.node_groups_expanded

  node_group_name = lookup(each.value, "name", join("-", [var.cluster_name, each.key, random_pet.node_groups[each.key].id]))

  cluster_name  = var.cluster_name
  node_role_arn = each.value["iam_role_arn"]
  subnet_ids    = each.value["subnets"]

  scaling_config {
    desired_size = each.value["desired_capacity"]
    max_size     = each.value["max_capacity"]
    min_size     = each.value["min_capacity"]
  }

  ami_type        = lookup(each.value, "ami_type", null)
  disk_size       = lookup(each.value, "disk_size", null)
  instance_types  = [each.value["instance_type"]]
  release_version = lookup(each.value, "ami_release_version", null)

  dynamic "remote_access" {
    for_each = each.value["key_name"] != "" ? [{
      ec2_ssh_key               = each.value["key_name"]
      source_security_group_ids = lookup(each.value, "source_security_group_ids", [])
    }] : []

    content {
      ec2_ssh_key               = remote_access.value["ec2_ssh_key"]
      source_security_group_ids = remote_access.value["source_security_group_ids"]
    }
  }

  version = lookup(each.value, "version", null)

  labels = merge(
    lookup(var.node_groups_defaults, "k8s_labels", {}),
    lookup(var.node_groups[each.key], "k8s_labels", {})
  )

  tags = merge(
    var.tags,
    lookup(var.node_groups_defaults, "additional_tags", {}),
    lookup(var.node_groups[each.key], "additional_tags", {}),
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [scaling_config.0.desired_size]
  }

  depends_on = [
    aws_iam_role_policy_attachment.nodes_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes_AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_iam_role" "node_groups" {
  count                 = var.manage_node_iam_resources && var.create_eks ? 1 : 0
  name_prefix           = var.node_groups_role_name != "" ? null : var.cluster_name
  name                  = var.node_groups_role_name != "" ? var.node_groups_role_name : null
  assume_role_policy    = data.aws_iam_policy_document.node_groups_assume_role_policy.json
  permissions_boundary  = var.permissions_boundary
  path                  = var.iam_path
  force_detach_policies = true
  tags                  = var.tags
}

resource "aws_iam_role_policy_attachment" "nodes_AmazonEKSWorkerNodePolicy" {
  count      = var.manage_node_iam_resources && var.create_eks ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_groups[0].name
}

resource "aws_iam_role_policy_attachment" "nodes_AmazonEKS_CNI_Policy" {
  count      = var.manage_node_iam_resources && var.attach_node_cni_policy && var.create_eks ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_groups[0].name
}

resource "aws_iam_role_policy_attachment" "nodes_AmazonEC2ContainerRegistryReadOnly" {
  count      = var.manage_node_iam_resources && var.create_eks ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_groups[0].name
}

resource "aws_iam_role_policy_attachment" "nodes_additional_policies" {
  count      = var.manage_node_iam_resources && var.create_eks ? length(var.node_groups_additional_policies) : 0
  role       = aws_iam_role.node_groups[0].name
  policy_arn = var.node_groups_additional_policies[count.index]
}
