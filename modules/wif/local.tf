data "google_client_config" "current" {}
data "google_project" "current" {
  project_id = local.project_id
}

locals {
  project_id = var.project_id != null ? var.project_id : data.google_client_config.current.project
  region     = var.region != null ? var.region : data.google_client_config.current.region

  kms_key_ring_name   = coalesce(var.kms_key_ring_name, "${var.system_name}-${var.env_type}-storage-kr")
  kms_crypto_key_name = coalesce(var.kms_crypto_key_name, "${var.system_name}-${var.env_type}-storage-ck")
  kms_key_location    = coalesce(var.kms_key_location, local.region)

  kms_default_key_name = var.storage_encryption_default_kms_key_name != null ? var.storage_encryption_default_kms_key_name : (
    var.kms_create ? google_kms_crypto_key.storage[0].id : null
  )

  storage_service_account = "service-${data.google_project.current.number}@gs-project-accounts.iam.gserviceaccount.com"
}
