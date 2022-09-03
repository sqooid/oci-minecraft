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

resource "oci_core_internet_gateway" "main" {
  compartment_id = oci_identity_compartment.main.id
  vcn_id         = oci_core_vcn.main.id
  enabled        = true
}

resource "oci_core_route_table" "main" {
  compartment_id = oci_identity_compartment.main.id
  vcn_id         = oci_core_vcn.main.id

  route_rules {
    network_entity_id = oci_core_internet_gateway.main.id
    destination       = "0.0.0.0/0"
  }
}

resource "oci_core_route_table_attachment" "subnet" {
  subnet_id      = oci_core_subnet.main.id
  route_table_id = oci_core_route_table.main.id
}
