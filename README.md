# terraform-aws-eks

[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-green.svg)](https://conventionalcommits.org)

This is a complete rework of the upstream community EKS module: https://github.com/terraform-aws-modules/terraform-aws-eks

> :warning: **Only `Terraform >= 0.12` will be supported. Based on `v9.0.0` of the upstream module.**


The interface to the module is the same but it attempts to be more flexible
by allowing users to create and use components separately by splitting out
sub-modules for:
- EKS Control Plane
- EKS Worker Groups
- EKS Managed Node Groups

The submodules are designed to be used as individual modules to help the user
perform actions in between creating the control plane and creating workers and nodes
(Custom CNI Configuration).

By breaking out separate sub modules we create a clearer separation of concerns and
reduce tight coupling of control plane and worker nodes whilst maintaining the same
interface for seamless migration to this module. The interface has become an example
implementation of the sub-modules.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

No provider.

## Inputs

No input.

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
