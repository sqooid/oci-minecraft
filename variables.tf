variable "tenancy_ocid" {
  type = string
}
variable "user_ocid" {
  type = string
}
variable "private_key_path" {
  type = string
}
variable "fingerprint" {
  type = string
}
variable "region" {
  type = string
}
variable "ssh_keys" {
  type    = set(string)
  default = []
}
