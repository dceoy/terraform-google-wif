data "google_client_config" "current" {}

locals {
  project_id = data.google_client_config.current.project
  region     = data.google_client_config.current.region
}
