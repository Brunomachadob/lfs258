terraform {
  backend "gcs" {
    bucket      = "lfclass-terraform-dev"
    credentials = "./service_account_key.json"
  }
}
