resource "google_compute_network" "vpc_network" {
  name = "vpc-network"
}

resource "google_compute_firewall" "vpc_network_firewall" {
  name    = "vpc-network-firewall"
  network = "${google_compute_network.vpc_network.name}"

  direction = "INGRESS"

  allow {
    protocol = "all"
  }
}
