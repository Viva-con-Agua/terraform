variable "enable_delete_protection" {
  type    = bool
  default = true
}

variable "main_location" {
  type    = string
  default = "fsn1" # frankfurt
}

variable "offsite_location" {
  type    = string
  default = "hel1" # helsinki
}

data "template_file" "cloud-init-config" {
  template = file("${path.root}/resources/cloud-config.yml")
  vars = {
    ftsell_pubkey = file("${path.root}/resources/users/ftsell_id_rsa.pub")
    ftsell_pwhash = file("${path.root}/resources/users/ftsell_pwhash.secret.txt")
  }
}

data "hcloud_image" "debian_x86" {
  name              = "debian-12"
  with_status       = ["available"]
  with_architecture = "x86"
  most_recent       = true
}

data "hcloud_image" "debian_arm" {
  name              = "debian-12"
  with_status       = ["available"]
  with_architecture = "arm"
  most_recent       = true
}

data "dns_a_record_set" "backend_server" {
  host = "backend.srv.vivaconagua.org"
}
data "dns_a_record_set" "live_server" {
  host = "live.srv.vivaconagua.org"
}
data "dns_a_record_set" "production_server" {
  host = "production.srv.vivaconagua.org"
}

resource "hcloud_ssh_key" "ftsell" {
  name       = "ftsell"
  public_key = file("${path.root}/resources/users/ftsell_id_rsa.pub")
}
