resource "hcloud_firewall" "monitoring" {
  name = "monitoring"
  apply_to {
    label_selector = "vivaconagua.org/firewall=monitoring"
  }

  rule {
    description = "ping"
    direction   = "in"
    protocol    = "icmp"
    source_ips  = ["0.0.0.0/0", "::/0"]
  }

  rule {
    description = "ssh"
    direction   = "in"
    protocol    = "tcp"
    port        = "22"
    source_ips  = ["0.0.0.0/0", "::/0"]
  }

  rule {
    description = "http"
    direction   = "in"
    protocol    = "tcp"
    port        = "80"
    source_ips  = ["0.0.0.0/0", "::/0"]
  }

  rule {
    description = "https"
    direction   = "in"
    protocol    = "tcp"
    port        = "443"
    source_ips  = ["0.0.0.0/0", "::/0"]
  }

  rule {
    description = "icinga2 node-to-node api"
    direction   = "in"
    protocol    = "tcp"
    port        = "5665"
    source_ips  = ["0.0.0.0/0", "::/0"]
  }
}
