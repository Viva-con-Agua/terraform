// Definitions for the main load-balancer that targets our kubernetes cluster
resource "hcloud_load_balancer" "kubernetes" {
  name               = "kubernetes"
  load_balancer_type = "lb11"
  delete_protection  = var.enable_delete_protection
}

resource "hcloud_load_balancer_target" "kubernetes-backend-srv" {
  type             = "ip"
  load_balancer_id = hcloud_load_balancer.kubernetes.id
  ip               = data.dns_a_record_set.backend_server.addrs[0]
}
resource "hcloud_load_balancer_target" "kubernetes-live-srv" {
  type             = "ip"
  load_balancer_id = hcloud_load_balancer.kubernetes.id
  ip               = data.dns_a_record_set.live_server.addrs[0]
}
resource "hcloud_load_balancer_target" "kubernetes-production-srv" {
  type             = "ip"
  load_balancer_id = hcloud_load_balancer.kubernetes.id
  ip               = data.dns_a_record_set.production_server.addrs[0]
}

resource "hcloud_load_balancer_service" "kubernetes-ingress-http" {
  load_balancer_id = hcloud_load_balancer.kubernetes.id
  protocol         = "tcp"
  listen_port      = 80
  destination_port = 30080
  proxyprotocol    = true
  health_check {
    protocol = "tcp"
    port     = 30080
    interval = 15
    timeout  = 5
    retries  = 3
  }
}
resource "hcloud_load_balancer_service" "kubernetes-ingress-https" {
  load_balancer_id = hcloud_load_balancer.kubernetes.id
  protocol         = "tcp"
  listen_port      = 443
  destination_port = 30443
  proxyprotocol    = true
  health_check {
    protocol = "tcp"
    port     = 30443
    interval = 15
    timeout  = 5
    retries  = 3
  }
}
