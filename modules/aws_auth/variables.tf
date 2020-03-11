variable "create_eks" {
  description = "Controls if EKS resources should be created (it affects almost all resources)."
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "manage_aws_auth" {
  description = "Whether to apply the aws-auth configmap file."
  default     = true
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap. See examples/basic/variables.tf for example format."
  type        = list(string)
  default     = []
}

variable "map_instances" {
  description = "IAM instance roles to add to the aws-auth configmap. See examples/basic/variables.tf for example format."
  type = list(object({
    instance_role_arn = string
    platform          = string
  }))
  default = []
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap. See examples/basic/variables.tf for example format."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap. See examples/basic/variables.tf for example format."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "wait_for_cluster_cmd" {
  description = "Custom local-exec command to execute for determining if the eks cluster is healthy. Cluster endpoint will be available as an environment variable called ENDPOINT"
  type        = string
  default     = "until wget --no-check-certificate -O - -q $ENDPOINT/healthz >/dev/null; do sleep 4; done"
}
