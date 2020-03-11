data "template_file" "map_instances" {
  count    = var.create_eks ? length(var.map_instances) : 0
  template = file("${path.module}/templates/worker-role.tpl")

  vars = var.map_instances[count.index]
}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

resource "null_resource" "wait_for_cluster" {
  count = var.create_eks && var.manage_aws_auth ? 1 : 0

  provisioner "local-exec" {
    environment = {
      ENDPOINT = data.aws_eks_cluster.this.endpoint
    }

    command = var.wait_for_cluster_cmd
  }
}

resource "kubernetes_config_map" "aws_auth" {
  count = var.create_eks && var.manage_aws_auth ? 1 : 0

  depends_on = [
    null_resource.wait_for_cluster[0]
  ]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles    = <<EOF
${join("", distinct(data.template_file.map_instances.*.rendered))}
%{if length(var.map_roles) != 0}${yamlencode(var.map_roles)}%{endif}
EOF
    mapUsers    = yamlencode(var.map_users)
    mapAccounts = yamlencode(var.map_accounts)
  }
}
