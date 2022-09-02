resource "oci_core_network_security_group" "main" {
  compartment_id = oci_identity_compartment.main.id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "minecraft-core-sg"
}

resource "oci_core_network_security_group_security_rule" "main_out" {
  network_security_group_id = oci_core_network_security_group.main.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
}

resource "oci_core_network_security_group_security_rule" "main_ssh" {
  network_security_group_id = oci_core_network_security_group.main.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      max = 22
      min = 22
    }
  }
}

resource "oci_core_network_security_group_security_rule" "main_mc_tcp" {
  network_security_group_id = oci_core_network_security_group.main.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      max = 25565
      min = 25565
    }
  }
}

resource "oci_core_network_security_group_security_rule" "main_mc_udp" {
  network_security_group_id = oci_core_network_security_group.main.id
  direction                 = "INGRESS"
  protocol                  = "17"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  udp_options {
    destination_port_range {
      max = 25565
      min = 25565
    }
  }
}
