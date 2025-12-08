data "google_client_config" "current" {}

locals {
  project_id = var.project_id != null ? var.project_id : data.google_client_config.current.project
  region     = var.region != null ? var.region : data.google_client_config.current.region
}
