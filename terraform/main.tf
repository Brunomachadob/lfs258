resource "google_compute_instance_template" "lfclass_template" {
  name        = "lfclass-template"
  description = "This template is used to create lfclass server instances."

  tags = ["lfclass"]

  labels = {
    environment = "dev"
  }

  instance_description = "lfclass"
  machine_type         = "n1-standard-2"
  can_ip_forward       = false

  scheduling {
    preemptible       = true
    automatic_restart = false
  }

  disk {
    source_image = "ubuntu-1804-lts"
    auto_delete  = true
    boot         = true
    disk_size_gb = 20
  }

  network_interface {
    network    = "${google_compute_network.vpc_network.name}"
    subnetwork = "${google_compute_subnetwork.vpc_network_subnetwork.name}"
  }
}

resource "google_compute_instance_from_template" "lfclass_master" {
  name                     = "lfclass-master"
  source_instance_template = "${google_compute_instance_template.lfclass_template.id}"
}

resource "google_compute_instance_from_template" "lfclass_worker1" {
  name                     = "lfclass-worker-1"
  source_instance_template = "${google_compute_instance_template.lfclass_template.id}"
}
