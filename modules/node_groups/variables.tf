variable "create_eks" {
  description = "Controls if EKS resources should be created (it affects almost all resources)."
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "Name of parent cluster."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
}

variable "node_groups_defaults" {
  description = "Map of values to be applied to all node groups. See documentation above for more details."
  type        = any
  default     = {}
}

variable "node_groups" {
  description = "Map of map of node groups to create. See documentation above for more details."
  type        = any
  default     = {}
}

variable "subnets" {
  description = "A list of subnets to place the EKS cluster and nodes within."
  type        = list(string)
}

variable "manage_node_iam_resources" {
  description = "Whether to let the module manage node group IAM resources. If set to false, iam_instance_profile_name must be specified for nodes."
  type        = bool
  default     = true
}

variable "node_groups_role_name" {
  description = "User defined node groups role name."
  type        = string
  default     = ""
}

variable "permissions_boundary" {
  description = "If provided, all IAM roles will be created with this permissions boundary attached."
  type        = string
  default     = null
}

variable "iam_path" {
  description = "If provided, all IAM roles will be created on this path."
  type        = string
  default     = "/"
}

variable "attach_node_cni_policy" {
  description = "Whether to attach the Amazon managed `AmazonEKS_CNI_Policy` IAM policy to the default node groups IAM role. WARNING: If set `false` the permissions must be assigned to the `aws-node` DaemonSet pods via another method or nodes will not be able to join the cluster."
  type        = bool
  default     = true
}

variable "node_groups_additional_policies" {
  description = "Additional policies to be added to node groups."
  type        = list(string)
  default     = []
}
