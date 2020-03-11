locals {
  worker_ami_name_filter = var.worker_ami_name_filter != "" ? var.worker_ami_name_filter : "amazon-eks-node-${data.aws_eks_cluster.this.version}-v*"

  # Windows nodes are available from k8s 1.14. If cluster version is less than 1.14, fix ami filter to some constant to not fail on 'terraform plan'.
  worker_ami_name_filter_windows = (var.worker_ami_name_filter_windows != "" ?
    var.worker_ami_name_filter_windows : "Windows_Server-2019-English-Core-EKS_Optimized-${tonumber(data.aws_eks_cluster.this.version) >= 1.14 ? data.aws_eks_cluster.this.version : 1.14}-*"
  )
}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_iam_policy_document" "workers_assume_role_policy" {
  statement {
    sid = "EKSWorkerAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_ami" "eks_worker" {
  filter {
    name   = "name"
    values = [local.worker_ami_name_filter]
  }

  most_recent = true

  owners = [var.worker_ami_owner_id]
}

data "aws_ami" "eks_worker_windows" {
  filter {
    name   = "name"
    values = [local.worker_ami_name_filter_windows]
  }

  filter {
    name   = "platform"
    values = ["windows"]
  }

  most_recent = true

  owners = [var.worker_ami_owner_id_windows]
}

data "template_file" "launch_template_userdata" {
  for_each = local.worker_groups_expanded

  template = coalesce(
    each.value["userdata_template_file"],
    file(
      each.value["platform"] == "windows"
      ? "${path.module}/templates/userdata_windows.tpl"
      : "${path.module}/templates/userdata.sh.tpl"
    )
  )

  vars = merge({
    platform             = each.value["platform"]
    cluster_name         = var.cluster_name
    endpoint             = data.aws_eks_cluster.this.endpoint
    cluster_auth_base64  = data.aws_eks_cluster.this.certificate_authority.0.data
    pre_userdata         = each.value["pre_userdata"]
    additional_userdata  = each.value["additional_userdata"]
    bootstrap_extra_args = each.value["bootstrap_extra_args"]
    kubelet_extra_args   = each.value["kubelet_extra_args"]
    },
    each.value["userdata_template_extra_args"]
  )
}

data "aws_iam_instance_profile" "custom_worker_group_launch_template_iam_instance_profile" {
  for_each = var.manage_worker_iam_resources ? {} : local.worker_groups_expanded

  name = each.value["iam_instance_profile_name"]
}

data "aws_region" "current" {}
