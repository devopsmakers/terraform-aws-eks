terraform {
  required_version = ">= 0.12.9"

  required_providers {
    aws        = ">= 2.52.0"
    null       = ">= 2.1"
    template   = ">= 2.1"
    kubernetes = ">= 1.6.2"
  }
}
