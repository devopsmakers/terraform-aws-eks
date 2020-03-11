variable "create_eks" {
  description = "Controls if EKS resources should be created (it affects almost all resources)."
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "Name of the parent EKS cluster."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
}

variable "worker_groups_defaults" {
  description = "Map of values to be applied to all worker groups. See documentation above for more details."
  type        = any
  default     = {}
}

variable "worker_groups" {
  description = "Map of map of worker groups to create. See documentation above for more details."
  type        = any
  default     = {}
}

variable "subnets" {
  description = "A list of subnets to place the EKS cluster and workers within."
  type        = list(string)
}

variable "worker_groups_role_name" {
  description = "User defined worker groups role name."
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

variable "attach_worker_cni_policy" {
  description = "Whether to attach the Amazon managed `AmazonEKS_CNI_Policy` IAM policy to the default worker groups IAM role. WARNING: If set `false` the permissions must be assigned to the `aws-worker` DaemonSet pods via another method or workers will not be able to join the cluster."
  type        = bool
  default     = true
}

variable "worker_groups_additional_policies" {
  description = "Additional policies to be added to worker groups."
  type        = list(string)
  default     = []
}

variable "workers_role_name" {
  description = "User defined workers role name."
  type        = string
  default     = ""
}

variable "worker_ami_name_filter" {
  description = "Name filter for AWS EKS worker AMI. If not provided, the latest official AMI for the specified 'cluster_version' is used."
  type        = string
  default     = ""
}

variable "worker_ami_name_filter_windows" {
  description = "Name filter for AWS EKS Windows worker AMI. If not provided, the latest official AMI for the specified 'cluster_version' is used."
  type        = string
  default     = ""
}

variable "worker_ami_owner_id" {
  description = "The ID of the owner for the AMI to use for the AWS EKS workers. Valid values are an AWS account ID, 'self' (the current account), or an AWS owner alias (e.g. 'amazon', 'aws-marketplace', 'microsoft')."
  type        = string
  default     = "602401143452" // The ID of the owner of the official AWS EKS AMIs.
}

variable "worker_ami_owner_id_windows" {
  description = "The ID of the owner for the AMI to use for the AWS EKS Windows workers. Valid values are an AWS account ID, 'self' (the current account), or an AWS owner alias (e.g. 'amazon', 'aws-marketplace', 'microsoft')."
  type        = string
  default     = "801119661308" // The ID of the owner of the official AWS EKS Windows AMIs.
}

variable "manage_worker_iam_resources" {
  description = "Whether to let the module manage worker IAM resources. If set to false, iam_instance_profile_name must be specified for workers."
  type        = bool
  default     = true
}

variable "worker_create_security_group" {
  description = "Whether to create a security group for the workers or attach the workers to `worker_security_group_id`."
  type        = bool
  default     = true
}

variable "worker_create_initial_lifecycle_hooks" {
  description = "Whether to create initial lifecycle hooks provided in worker groups."
  type        = bool
  default     = false
}

variable "workers_additional_policies" {
  description = "Additional policies to be added to workers"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "VPC where the cluster and workers will be deployed."
  type        = string
}

variable "worker_additional_security_group_ids" {
  description = "A list of additional security group ids to attach to worker instances"
  type        = list(string)
  default     = []
}

variable "cluster_security_group_id" {
  description = "If provided, the EKS cluster will be attached to this security group. If not given, a security group will be created with necessary ingress/egress to work with the workers"
  type        = string
}

variable "worker_sg_ingress_from_port" {
  description = "Minimum port number from which pods will accept communication. Must be changed to a lower value if some pods in your cluster will expose a port lower than 1025 (e.g. 22, 80, or 443)."
  type        = number
  default     = 1025
}

variable "worker_security_group_id" {
  description = "If provided, all workers will be attached to this security group. If not given, a security group will be created with necessary ingress/egress to work with the EKS cluster."
  type        = string
  default     = ""
}
