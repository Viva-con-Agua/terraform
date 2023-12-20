// General terraform configuration and dependency specification
terraform {
  required_version = ">=1.3.9"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">=1.44.1"
    }
    template = {
      version = ">=2.0.0"
    }
    local = {
      version = ">=2.0.0"
    }
  }
}
