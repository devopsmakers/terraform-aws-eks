resource "random_pet" "worker_groups" {
  for_each = local.worker_groups_expanded

  separator = "-"
  length    = 2

  keepers = {
    ami_id           = coalesce(each.value["ami_id"], each.value["platform"] == "windows" ? local.default_ami_id_windows : local.default_ami_id_linux)
    root_volume_size = lookup(each.value, "root_volume_size", null)
    instance_type    = each.value["instance_type"]

    override_instance_types = join("|", compact(
      lookup(each.value, "override_instance_types", [])
    ))

    iam_role_id = each.value["iam_role_id"]
    key_name    = each.value["key_name"]

    source_security_group_ids = join("|", compact(
      lookup(each.value, "source_security_group_ids", [])
    ))

    subnet_ids        = join("|", each.value["subnets"])
    worker_group_name = join("-", [var.cluster_name, each.key])
  }
}
