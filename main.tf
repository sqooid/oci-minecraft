terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = ">=4.0.0"
    }
  }
  backend "http" {
    # address       = TF_HTTP_ADDRESS
    update_method = "PUT"
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  private_key_path = var.private_key_path
  fingerprint      = var.fingerprint
  region           = var.region
}
