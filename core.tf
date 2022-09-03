resource "oci_identity_compartment" "main" {
  compartment_id = var.tenancy_ocid
  name           = "minecraft-compartment"
  description    = "Compartment for Minecraft server deployment"
}

data "oci_identity_availability_domains" "available" {
  compartment_id = oci_identity_compartment.main.id
}

data "oci_core_images" "main" {
  compartment_id           = oci_identity_compartment.main.id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = "VM.Standard.A1.Flex"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "main" {
  display_name        = "minecraft-server"
  compartment_id      = oci_identity_compartment.main.id
  availability_domain = data.oci_identity_availability_domains.available.availability_domains[0].name
  shape               = "VM.Standard.A1.Flex"

  metadata = {
    ssh_authorized_keys = join("\n", var.ssh_keys)
    user_data           = base64encode(templatefile("${path.root}/data/user-data.sh", {}))
  }

  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.main.id
    nsg_ids          = [oci_core_network_security_group.main.id]
  }

  source_details {
    boot_volume_size_in_gbs = 200
    source_id               = data.oci_core_images.main.images[0].id
    source_type             = "image"
  }

  shape_config {
    memory_in_gbs = 24
    ocpus         = 4
  }
}
