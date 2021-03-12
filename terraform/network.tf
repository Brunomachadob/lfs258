resource "google_compute_network" "vpc_network" {
  name                    = "vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_network_subnetwork" {
  name          = "vpc-network-subnetwork"
  ip_cidr_range = "10.128.0.0/9"
  network       = "${google_compute_network.vpc_network.name}"
}

resource "google_compute_firewall" "vpc_network_firewall" {
  name    = "vpc-network-firewall"
  network = "${google_compute_network.vpc_network.name}"

  direction = "INGRESS"

  allow {
    protocol = "all"
  }
}
