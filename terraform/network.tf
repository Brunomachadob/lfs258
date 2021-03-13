resource "google_compute_network" "vpc_network" {
  name                    = "vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_network_subnetwork" {
  name          = "vpc-network-subnetwork"
  ip_cidr_range = "10.128.0.0/9"
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_firewall" "vpc_network_firewall" {
  name    = "vpc-network-firewall"
  network = google_compute_network.vpc_network.name

  direction = "INGRESS"

  allow {
    protocol = "all"
  }
}

resource "google_compute_router" "router" {
  name    = "my-router"
  region  = google_compute_subnetwork.vpc_network_subnetwork.region
  network = google_compute_network.vpc_network.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "my-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}