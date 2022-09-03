terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = ">=4.0.0"
    }
  }
  backend "http" {
    address       = "https://objectstorage.ap-melbourne-1.oraclecloud.com/p/VGLgkDlzUnEbW1oRHdEyfeZT5M_AQwIgGxe7p-zR1AX_nr3lMWqVs7E1ySB4Yv4w/n/axt3lxcfu9il/b/terraform-tfstate/o/minecraft/terraform.tfstate"
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
