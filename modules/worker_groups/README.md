# eks `worker_groups` submodule

This submodule is designed for use by both the parent `eks` module and by the user.

> :warning: **Launch Configuration driven worker groups have been superceded by Launch Template driven worker groups**

`worker_groups` is a map of maps. Key of first level will be used as unique value for `for_each` resources and in the `aws_autoscaling_group` and `aws_launch_template` name. Inner map can take the below values.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| aws | >= 2.52.0 |
| random | >= 2.1 |
| template | >= 2.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| attach\_worker\_cni\_policy | Whether to attach the Amazon managed `AmazonEKS_CNI_Policy` IAM policy to the default worker groups IAM role. WARNING: If set `false` the permissions must be assigned to the `aws-worker` DaemonSet pods via another method or workers will not be able to join the cluster. | `bool` | `true` | no |
| cluster\_name | Name of the parent EKS cluster. | `string` | n/a | yes |
| cluster\_security\_group\_id | If provided, the EKS cluster will be attached to this security group. If not given, a security group will be created with necessary ingress/egress to work with the workers | `string` | n/a | yes |
| create\_eks | Controls if EKS resources should be created (it affects almost all resources). | `bool` | `true` | no |
| iam\_path | If provided, all IAM roles will be created on this path. | `string` | `"/"` | no |
| manage\_worker\_iam\_resources | Whether to let the module manage worker IAM resources. If set to false, iam\_instance\_profile\_name must be specified for workers. | `bool` | `true` | no |
| permissions\_boundary | If provided, all IAM roles will be created with this permissions boundary attached. | `string` | n/a | yes |
| subnets | A list of subnets to place the EKS cluster and workers within. | `list(string)` | n/a | yes |
| tags | A map of tags to add to all resources. | `map(string)` | n/a | yes |
| vpc\_id | VPC where the cluster and workers will be deployed. | `string` | n/a | yes |
| worker\_additional\_security\_group\_ids | A list of additional security group ids to attach to worker instances | `list(string)` | `[]` | no |
| worker\_ami\_name\_filter | Name filter for AWS EKS worker AMI. If not provided, the latest official AMI for the specified 'cluster\_version' is used. | `string` | `""` | no |
| worker\_ami\_name\_filter\_windows | Name filter for AWS EKS Windows worker AMI. If not provided, the latest official AMI for the specified 'cluster\_version' is used. | `string` | `""` | no |
| worker\_ami\_owner\_id | The ID of the owner for the AMI to use for the AWS EKS workers. Valid values are an AWS account ID, 'self' (the current account), or an AWS owner alias (e.g. 'amazon', 'aws-marketplace', 'microsoft'). | `string` | `"602401143452"` | no |
| worker\_ami\_owner\_id\_windows | The ID of the owner for the AMI to use for the AWS EKS Windows workers. Valid values are an AWS account ID, 'self' (the current account), or an AWS owner alias (e.g. 'amazon', 'aws-marketplace', 'microsoft'). | `string` | `"801119661308"` | no |
| worker\_create\_initial\_lifecycle\_hooks | Whether to create initial lifecycle hooks provided in worker groups. | `bool` | `false` | no |
| worker\_create\_security\_group | Whether to create a security group for the workers or attach the workers to `worker_security_group_id`. | `bool` | `true` | no |
| worker\_groups | Map of map of worker groups to create. See documentation above for more details. | `any` | `{}` | no |
| worker\_groups\_additional\_policies | Additional policies to be added to worker groups. | `list(string)` | `[]` | no |
| worker\_groups\_defaults | Map of values to be applied to all worker groups. See documentation above for more details. | `any` | `{}` | no |
| worker\_groups\_role\_name | User defined worker groups role name. | `string` | `""` | no |
| worker\_security\_group\_id | If provided, all workers will be attached to this security group. If not given, a security group will be created with necessary ingress/egress to work with the EKS cluster. | `string` | `""` | no |
| worker\_sg\_ingress\_from\_port | Minimum port number from which pods will accept communication. Must be changed to a lower value if some pods in your cluster will expose a port lower than 1025 (e.g. 22, 80, or 443). | `number` | `1025` | no |
| workers\_additional\_policies | Additional policies to be added to workers | `list(string)` | `[]` | no |
| workers\_role\_name | User defined workers role name. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws\_auth\_roles | Roles for use in aws-auth ConfigMap |
| worker\_iam\_instance\_profile\_arns | default IAM instance profile ARN for EKS worker groups |
| worker\_iam\_instance\_profile\_names | default IAM instance profile name for EKS worker groups |
| worker\_iam\_role\_arn | default IAM role ARN for EKS worker groups |
| worker\_iam\_role\_name | default IAM role name for EKS worker groups |
| worker\_security\_group\_id | Security group ID attached to the EKS workers. |
| workers\_asg\_arns | IDs of the autoscaling groups containing workers. |
| workers\_asg\_names | Names of the autoscaling groups containing workers. |
| workers\_default\_ami\_id | ID of the default worker group AMI |
| workers\_launch\_template\_arns | ARNs of the worker launch templates. |
| workers\_launch\_template\_ids | IDs of the worker launch templates. |
| workers\_launch\_template\_latest\_versions | Latest versions of the worker launch templates. |
| workers\_user\_data | User data of worker groups |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
