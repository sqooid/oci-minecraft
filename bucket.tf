data "oci_objectstorage_namespace" "current" {
  compartment_id = oci_identity_compartment.main.id
}

resource "oci_objectstorage_bucket" "setup" {
  compartment_id = oci_identity_compartment.main.id
  name           = "minecraft-setup"
  namespace      = data.oci_objectstorage_namespace.current.namespace
}

resource "random_string" "bucket_namespace" {
  length  = 16
  special = false
}

resource "oci_objectstorage_preauthrequest" "setup_access" {
  name         = "minecraft-setup-access"
  access_type  = "AnyObjectRead"
  bucket       = oci_objectstorage_bucket.setup.name
  namespace    = oci_objectstorage_bucket.setup.namespace
  time_expires = "2999-01-01T01:00:00Z"
}

resource "oci_objectstorage_object" "server_setup_base" {
  object    = "server-setup-base.sh"
  bucket    = oci_objectstorage_bucket.setup.name
  source    = "${path.root}/data/server-setup-base.sh"
  namespace = oci_objectstorage_bucket.setup.namespace
}

resource "oci_objectstorage_object" "user_data_lazy" {
  object = "user-data-lazy.sh"
  bucket = oci_objectstorage_bucket.setup.name
  content = templatefile("${path.root}/data/user-data-lazy.sh", {
    volume_iqn    = oci_core_volume_attachment.main.iqn
    volume_ip     = oci_core_volume_attachment.main.ipv4
    volume_port   = oci_core_volume_attachment.main.port
    setup_request = oci_objectstorage_preauthrequest.setup_access.access_uri
    region        = var.region
    timezone      = var.timezone
  })
  namespace = oci_objectstorage_bucket.setup.namespace
}
