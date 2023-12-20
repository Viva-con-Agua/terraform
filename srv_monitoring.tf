// Definitions for our monitoring server
resource "hcloud_server" "monitoring" {
  name = "monitoring.srv.vivaconagua.org"
  labels = {
    "vivaconagua.org/purpose" : "monitoring"
    "vivaconagua.org/public_dns" : "monitoring.srv.vivaconagua.org"
    "vivaconagua.org/firewall" : "monitoring"
  }
  server_type        = "cax11"
  location           = var.offsite_location
  backups            = true
  image              = data.hcloud_image.debian_arm.id
  user_data          = data.template_file.cloud-init-config.rendered
  delete_protection  = var.enable_delete_protection
  rebuild_protection = var.enable_delete_protection

  lifecycle {
    ignore_changes = [image, user_data, ssh_keys]
  }
}

resource "hcloud_rdns" "monitoring-ipv4" {
  server_id  = hcloud_server.monitoring.id
  dns_ptr    = hcloud_server.monitoring.name
  ip_address = hcloud_server.monitoring.ipv4_address
}

resource "hcloud_rdns" "monitoring-ipv6" {
  server_id  = hcloud_server.monitoring.id
  dns_ptr    = hcloud_server.monitoring.name
  ip_address = hcloud_server.monitoring.ipv6_address
}

output "monitoring_server" {
  value = "${hcloud_server.monitoring.ipv4_address} & ${hcloud_server.monitoring.ipv6_address}"
}
