# eks `aws_auth` submodule

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| kubernetes | >= 1.6.2 |
| template | >= 2.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| create\_eks | Controls if EKS resources should be created (it affects almost all resources). | `bool` | `true` | no |
| manage\_aws\_auth | Whether to apply the aws-auth configmap file. | `bool` | `true` | no |
| map\_accounts | Additional AWS account numbers to add to the aws-auth configmap. See examples/basic/variables.tf for example format. | `list(string)` | `[]` | no |
| map\_instances | IAM instance roles to add to the aws-auth configmap. See examples/basic/variables.tf for example format. | <pre>list(object({<br>    instance_role_arn = string<br>    platform          = string<br>  }))</pre> | `[]` | no |
| map\_roles | Additional IAM roles to add to the aws-auth configmap. See examples/basic/variables.tf for example format. | <pre>list(object({<br>    rolearn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| map\_users | Additional IAM users to add to the aws-auth configmap. See examples/basic/variables.tf for example format. | <pre>list(object({<br>    userarn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| config\_map\_aws\_auth | A kubernetes configuration to authenticate to this EKS cluster. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
