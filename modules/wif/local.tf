data "google_client_config" "current" {}

data "google_storage_project_service_account" "current" {
  project = local.project_id
}

locals {
  project_id                = var.project_id != null ? var.project_id : data.google_client_config.current.project
  region                    = var.region != null ? var.region : data.google_client_config.current.region
  storage_project_sa_member = data.google_storage_project_service_account.current.member
  storage_io_bucket_name    = var.create_storage_io_bucket ? "${var.system_name}-${var.env_type}-io-${local.region}-${local.project_id}" : null
  storage_logs_bucket_name  = var.create_storage_logs_bucket && var.storage_logging_log_bucket == null ? "${var.system_name}-${var.env_type}-logs-${local.region}-${local.project_id}" : null
}
