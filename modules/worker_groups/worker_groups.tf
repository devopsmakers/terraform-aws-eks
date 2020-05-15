# Worker Groups using Launch Templates

resource "aws_autoscaling_group" "worker_groups" {
  for_each = local.worker_groups_expanded

  name_prefix = join(
    "-",
    compact(
      [
        var.cluster_name,
        coalesce(each.value["name"], each.key),
        each.value["recreate_on_change"] ? random_pet.worker_groups[each.key].id : ""
      ]
    )
  )

  desired_capacity          = each.value["desired_capacity"]
  max_size                  = each.value["max_size"]
  min_size                  = each.value["min_size"]
  force_delete              = each.value["force_delete"]
  target_group_arns         = each.value["target_group_arns"]
  service_linked_role_arn   = each.value["service_linked_role_arn"]
  vpc_zone_identifier       = each.value["subnets"]
  protect_from_scale_in     = each.value["protect_from_scale_in"]
  suspended_processes       = each.value["suspended_processes"]
  enabled_metrics           = each.value["enabled_metrics"]
  placement_group           = each.value["placement_group"]
  termination_policies      = each.value["termination_policies"]
  max_instance_lifetime     = each.value["max_instance_lifetime"]
  default_cooldown          = each.value["default_cooldown"]
  health_check_grace_period = each.value["health_check_grace_period"]

  dynamic "mixed_instances_policy" {
    iterator = item
    for_each = (lookup(each.value, "override_instance_types", null) != null) || (lookup(each.value, "on_demand_allocation_strategy", null) != null) ? list(each.value) : []

    content {
      instances_distribution {

        on_demand_base_capacity                  = item.value["on_demand_base_capacity"]
        on_demand_percentage_above_base_capacity = item.value["on_demand_percentage_above_base_capacity"]
        on_demand_allocation_strategy            = lookup(item.value, "on_demand_allocation_strategy", "prioritized")

        spot_allocation_strategy = item.value["spot_allocation_strategy"]
        spot_instance_pools      = item.value["spot_instance_pools"]
        spot_max_price           = item.value["spot_max_price"]
      }

      launch_template {

        launch_template_specification {
          launch_template_id = aws_launch_template.worker_groups[each.key].id
          version            = item.value["launch_template_version"]
        }

        dynamic "override" {
          for_each = item.value["override_instance_types"]

          content {
            instance_type = override.value
          }
        }
      }
    }
  }

  dynamic "launch_template" {
    iterator = item
    for_each = (lookup(each.value, "override_instance_types", null) != null) || (lookup(each.value, "on_demand_allocation_strategy", null) != null) ? [] : list(each.value)

    content {
      id      = aws_launch_template.worker_groups[each.key].id
      version = item.value["launch_template_version"]
    }
  }

  dynamic "initial_lifecycle_hook" {
    for_each = var.worker_create_initial_lifecycle_hooks ? each.value["initial_lifecycle_hooks"] : []
    content {
      name                    = initial_lifecycle_hook.value["name"]
      lifecycle_transition    = initial_lifecycle_hook.value["lifecycle_transition"]
      notification_metadata   = lookup(initial_lifecycle_hook.value, "notification_metadata", null)
      heartbeat_timeout       = lookup(initial_lifecycle_hook.value, "heartbeat_timeout", null)
      notification_target_arn = lookup(initial_lifecycle_hook.value, "notification_target_arn", null)
      role_arn                = lookup(initial_lifecycle_hook.value, "role_arn", null)
      default_result          = lookup(initial_lifecycle_hook.value, "default_result", null)
    }
  }

  tags = concat(
    [
      {
        "key"                 = "Name"
        "value"               = "${var.cluster_name}-${coalesce(each.value["name"], each.key)}-eks_asg"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "kubernetes.io/cluster/${var.cluster_name}"
        "value"               = "owned"
        "propagate_at_launch" = true
      },
    ],
    local.asg_tags,
    each.value["tags"]
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }

  depends_on = [
    aws_iam_role_policy_attachment.workers_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.workers_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.workers_AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_launch_template" "worker_groups" {
  for_each = local.worker_groups_expanded

  name_prefix = "${var.cluster_name}-${coalesce(each.value["name"], each.key)}"

  network_interfaces {
    associate_public_ip_address = each.value["public_ip"]
    delete_on_termination       = each.value["eni_delete"]
    security_groups = flatten([
      local.worker_security_group_id,
      var.worker_additional_security_group_ids,
      each.value["additional_security_group_ids"],
    ])
  }

  iam_instance_profile {
    name = coalescelist(
      var.manage_worker_iam_resources ? [aws_iam_instance_profile.worker_groups[each.key].name] : [],
      var.manage_worker_iam_resources ? [] : [data.aws_iam_instance_profile.custom_worker_group_launch_template_iam_instance_profile[each.key].name],
      [""]
    )[0]
  }

  image_id = coalesce(each.value["ami_id"], each.value["platform"] == "windows" ? local.default_ami_id_windows : local.default_ami_id_linux)

  instance_type = each.value["instance_type"]
  key_name      = each.value["key_name"]

  user_data = base64encode(
    data.template_file.launch_template_userdata[each.key].rendered,
  )

  ebs_optimized = contains(
    local.ebs_optimized_not_supported,
    each.value["instance_type"]
  ) ? false : each.value["ebs_optimized"]

  credit_specification {
    cpu_credits = each.value["cpu_credits"]
  }

  monitoring {
    enabled = each.value["enable_monitoring"]
  }

  dynamic "placement" {
    for_each = each.value["launch_template_placement_group"] != null ? [each.value["launch_template_placement_group"]] : []

    content {
      tenancy    = each.value["launch_template_placement_tenancy"]
      group_name = placement.value
    }
  }

  dynamic "instance_market_options" {
    for_each = lookup(each.value, "market_type", null) == null ? [] : list(lookup(each.value, "market_type", null))
    content {
      market_type = instance_market_options.value
    }
  }

  block_device_mappings {
    device_name = each.value["root_block_device_name"]

    ebs {
      volume_size           = each.value["root_volume_size"]
      volume_type           = each.value["root_volume_type"]
      iops                  = each.value["root_iops"]
      encrypted             = each.value["root_encrypted"]
      kms_key_id            = each.value["root_kms_key_id"]
      delete_on_termination = true
    }
  }

  dynamic "tag_specifications" {
    for_each = ["volume", "instance"]

    content {
      resource_type = tag_specifications.value

      tags = merge(
        {
          "Name"                                      = "${var.cluster_name}-${coalesce(each.value["name"], each.key)}-eks_asg",
          "kubernetes.io/cluster/${var.cluster_name}" = "owned",
        },
        var.tags,
      )
    }
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "worker_groups" {
  for_each = var.manage_worker_iam_resources ? local.worker_groups_expanded : {}

  name_prefix = "${var.cluster_name}-${coalesce(each.value["name"], each.key)}"
  role        = each.value["iam_role_id"]
  path        = var.iam_path
}

resource "aws_security_group" "worker_groups" {
  count = local.worker_create_security_group ? 1 : 0

  name_prefix = var.cluster_name
  description = "Security group for all workers in the cluster."
  vpc_id      = var.vpc_id
  tags = merge(
    var.tags,
    {
      "Name"                                      = "${var.cluster_name}-eks_workers_sg"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    },
  )
}

resource "aws_security_group_rule" "workers_egress_internet" {
  count             = local.worker_create_security_group ? 1 : 0
  description       = "Allow nodes all egress to the Internet."
  protocol          = "-1"
  security_group_id = local.worker_security_group_id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "workers_ingress_self" {
  count                    = local.worker_create_security_group ? 1 : 0
  description              = "Allow node to communicate with each other."
  protocol                 = "-1"
  security_group_id        = local.worker_security_group_id
  source_security_group_id = local.worker_security_group_id
  from_port                = 0
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_ingress_cluster" {
  count                    = local.worker_create_security_group ? 1 : 0
  description              = "Allow workers pods to receive communication from the cluster control plane."
  protocol                 = "tcp"
  security_group_id        = local.worker_security_group_id
  source_security_group_id = var.cluster_security_group_id
  from_port                = var.worker_sg_ingress_from_port
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_ingress_cluster_kubelet" {
  count                    = local.worker_create_security_group ? var.worker_sg_ingress_from_port > 10250 ? 1 : 0 : 0
  description              = "Allow workers Kubelets to receive communication from the cluster control plane."
  protocol                 = "tcp"
  security_group_id        = local.worker_security_group_id
  source_security_group_id = var.cluster_security_group_id
  from_port                = 10250
  to_port                  = 10250
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_ingress_cluster_https" {
  count                    = local.worker_create_security_group ? 1 : 0
  description              = "Allow pods running extension API servers on port 443 to receive communication from cluster control plane."
  protocol                 = "tcp"
  security_group_id        = local.worker_security_group_id
  source_security_group_id = var.cluster_security_group_id
  from_port                = 443
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_https_workers_ingress" {
  count                    = local.worker_create_security_group ? 1 : 0
  description              = "Allow pods to communicate with the EKS cluster API."
  protocol                 = "tcp"
  security_group_id        = var.cluster_security_group_id
  source_security_group_id = local.worker_security_group_id
  from_port                = 443
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_iam_role" "worker_groups" {
  count                 = var.manage_worker_iam_resources && var.create_eks ? 1 : 0
  name_prefix           = var.workers_role_name != "" ? null : var.cluster_name
  name                  = var.workers_role_name != "" ? var.workers_role_name : null
  assume_role_policy    = data.aws_iam_policy_document.workers_assume_role_policy.json
  permissions_boundary  = var.permissions_boundary
  path                  = var.iam_path
  force_detach_policies = true
  tags                  = var.tags
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEKSWorkerNodePolicy" {
  count      = var.manage_worker_iam_resources && var.create_eks ? 1 : 0
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker_groups[0].name
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEKS_CNI_Policy" {
  count      = var.manage_worker_iam_resources && var.attach_worker_cni_policy && var.create_eks ? 1 : 0
  policy_arn = "${local.policy_arn_prefix}/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker_groups[0].name
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEC2ContainerRegistryReadOnly" {
  count      = var.manage_worker_iam_resources && var.create_eks ? 1 : 0
  policy_arn = "${local.policy_arn_prefix}/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker_groups[0].name
}

resource "aws_iam_role_policy_attachment" "workers_additional_policies" {
  count      = var.manage_worker_iam_resources && var.create_eks ? length(var.workers_additional_policies) : 0
  role       = aws_iam_role.worker_groups[0].name
  policy_arn = var.workers_additional_policies[count.index]
}
