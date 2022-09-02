resource "oci_core_vcn" "main" {
  display_name   = "minecraft-main-vcn"
  compartment_id = oci_identity_compartment.main.id
  cidr_blocks    = ["10.0.0.0/24"]
}

resource "oci_core_subnet" "main" {
  display_name   = "minecraft-main-subnet"
  cidr_block     = "10.0.0.0/24"
  compartment_id = oci_identity_compartment.main.id
  vcn_id         = oci_core_vcn.main.id
}
