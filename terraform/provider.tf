provider "google" {
  credentials = "${file("service_account_key.json")}"
  project     = "${var.PROJECT_ID}"
  region      = "europe-west3"
  zone        = "europe-west3-a"
}
