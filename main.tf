module "control_plane" {
  source = "./modules/control_plane"

  cluster_create_security_group                = var.cluster_create_security_group
  cluster_create_timeout                       = var.cluster_create_timeout
  cluster_delete_timeout                       = var.cluster_delete_timeout
  cluster_enabled_log_types                    = var.cluster_enabled_log_types
  cluster_encryption_key_arn                   = var.cluster_encryption_key_arn
  cluster_encryption_resources                 = var.cluster_encryption_resources
  cluster_endpoint_private_access              = var.cluster_endpoint_private_access
  cluster_endpoint_public_access               = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs         = var.cluster_endpoint_public_access_cidrs
  cluster_iam_role_name                        = var.cluster_iam_role_name
  cluster_log_kms_key_id                       = var.cluster_log_kms_key_id
  cluster_log_retention_in_days                = var.cluster_log_retention_in_days
  cluster_name                                 = var.cluster_name
  cluster_security_group_id                    = var.cluster_security_group_id
  cluster_version                              = var.cluster_version
  config_output_path                           = var.config_output_path
  create_eks                                   = var.create_eks
  eks_oidc_root_ca_thumbprint                  = var.eks_oidc_root_ca_thumbprint
  enable_irsa                                  = var.enable_irsa
  iam_path                                     = var.iam_path
  kubeconfig_aws_authenticator_additional_args = var.kubeconfig_aws_authenticator_additional_args
  kubeconfig_aws_authenticator_command         = var.kubeconfig_aws_authenticator_command
  kubeconfig_aws_authenticator_command_args    = var.kubeconfig_aws_authenticator_command_args
  kubeconfig_aws_authenticator_env_variables   = var.kubeconfig_aws_authenticator_env_variables
  kubeconfig_name                              = var.kubeconfig_name
  manage_cluster_iam_resources                 = var.manage_cluster_iam_resources
  permissions_boundary                         = var.permissions_boundary
  subnets                                      = var.subnets
  tags                                         = var.tags
  vpc_id                                       = var.vpc_id
  write_kubeconfig                             = var.write_kubeconfig
}

module "worker_groups" {
  source = "./modules/worker_groups"

  cluster_name              = module.control_plane.cluster_id
  cluster_security_group_id = module.control_plane.cluster_security_group_id

  attach_worker_cni_policy              = var.attach_worker_cni_policy
  create_eks                            = var.create_eks
  iam_path                              = var.iam_path
  manage_worker_iam_resources           = var.manage_worker_iam_resources
  permissions_boundary                  = var.permissions_boundary
  subnets                               = var.subnets
  tags                                  = var.tags
  vpc_id                                = var.vpc_id
  worker_additional_security_group_ids  = var.worker_additional_security_group_ids
  worker_ami_name_filter                = var.worker_ami_name_filter
  worker_ami_name_filter_windows        = var.worker_ami_name_filter_windows
  worker_ami_owner_id                   = var.worker_ami_owner_id
  worker_ami_owner_id_windows           = var.worker_ami_owner_id_windows
  worker_create_initial_lifecycle_hooks = var.worker_create_initial_lifecycle_hooks
  worker_create_security_group          = var.worker_create_security_group
  worker_groups                         = var.worker_groups
  worker_groups_additional_policies     = var.worker_groups_additional_policies
  worker_groups_defaults                = var.worker_groups_defaults
  worker_groups_role_name               = var.worker_groups_role_name
  worker_security_group_id              = var.worker_security_group_id
  worker_sg_ingress_from_port           = var.worker_sg_ingress_from_port
}

module "node_groups" {
  source = "./modules/node_groups"

  cluster_name = module.control_plane.cluster_id

  attach_node_cni_policy          = var.attach_node_cni_policy
  create_eks                      = var.create_eks
  iam_path                        = var.iam_path
  manage_node_iam_resources       = var.manage_node_iam_resources
  node_groups                     = var.node_groups
  node_groups_additional_policies = var.node_groups_additional_policies
  node_groups_defaults            = var.node_groups_defaults
  node_groups_role_name           = var.node_groups_role_name
  permissions_boundary            = var.permissions_boundary
  subnets                         = var.subnets
  tags                            = var.tags
}

module "aws_auth" {
  source = "./modules/aws_auth"

  cluster_name  = module.control_plane.cluster_id
  map_instances = concat(module.worker_groups.aws_auth_roles, module.node_groups.aws_auth_roles)

  create_eks           = var.create_eks
  manage_aws_auth      = var.manage_aws_auth
  map_accounts         = var.map_accounts
  map_roles            = var.map_roles
  map_users            = var.map_users
  wait_for_cluster_cmd = var.wait_for_cluster_cmd
}
