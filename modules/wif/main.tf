resource "google_project_service" "apis" {
  for_each                   = toset(var.enabled_apis)
  service                    = each.key
  project                    = local.project_id
  disable_on_destroy         = var.project_service_disable_on_destroy
  disable_dependent_services = var.project_service_disable_dependent_services
}

resource "google_iam_workload_identity_pool" "aws" {
  count                     = var.aws_account_id != null && var.aws_iam_role_name != null ? 1 : 0
  depends_on                = [google_project_service.apis]
  workload_identity_pool_id = "${var.system_name}-${var.env_type}-aws-wi-pool"
  display_name              = "${var.system_name}-${var.env_type}-aws-wi-pool"
  description               = "Workload Identity Pool for AWS IAM role authentication"
  disabled                  = false
  project                   = local.project_id
}

resource "google_iam_workload_identity_pool_provider" "aws" {
  count                              = length(google_iam_workload_identity_pool.aws) > 0 ? 1 : 0
  workload_identity_pool_id          = google_iam_workload_identity_pool.aws[0].workload_identity_pool_id
  workload_identity_pool_provider_id = "${var.system_name}-${var.env_type}-aws-wi-pool-provider"
  display_name                       = "${var.system_name}-${var.env_type}-aws-wi-pool-provider"
  description                        = "OIDC provider for AWS IAM role"
  disabled                           = false
  attribute_mapping = {
    "google.subject"           = "assertion.arn"
    "attribute.aws_iam_role"   = "assertion.arn.extract('assumed-role/{role}/')"
    "attribute.aws_account_id" = "assertion.account"
  }
  attribute_condition = "attribute.aws_account_id == '${var.aws_account_id}'"
  project             = local.project_id
  aws {
    account_id = var.aws_account_id
  }
}

resource "google_service_account" "aws" {
  count                        = length(google_iam_workload_identity_pool.aws) > 0 ? 1 : 0
  account_id                   = "${var.system_name}-${var.env_type}-wif-aws-sa"
  display_name                 = "Service Account for Workload Identity Federation from AWS"
  description                  = "Service account to be used with Workload Identity Federation from AWS"
  disabled                     = false
  project                      = local.project_id
  create_ignore_already_exists = var.service_account_create_ignore_already_exists
}

resource "google_project_iam_member" "aws" {
  for_each = toset(length(google_service_account.aws) > 0 ? var.project_iam_member_roles_for_aws : [])
  member   = "serviceAccount:${google_service_account.aws[0].email}"
  role     = each.value
  project  = local.project_id
  dynamic "condition" {
    for_each = var.project_iam_member_condition_expression != null && var.project_iam_member_condition_title != null ? [true] : []
    content {
      expression  = var.project_iam_member_condition_expression
      title       = var.project_iam_member_condition_title
      description = var.project_iam_member_condition_description
    }
  }
}

resource "google_service_account_iam_member" "aws" {
  for_each           = { for k, v in google_service_account.aws : k => v.name }
  service_account_id = each.value
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.aws[0].name}/attribute.aws_iam_role/${var.aws_iam_role_name}"
  role               = "roles/iam.workloadIdentityUser"
  dynamic "condition" {
    for_each = var.service_account_iam_condition_expression != null && var.service_account_iam_condition_title != null ? [true] : []
    content {
      expression  = var.service_account_iam_condition_expression
      title       = var.service_account_iam_condition_title
      description = var.service_account_iam_condition_description
    }
  }
}

resource "google_iam_workload_identity_pool" "gha" {
  count                     = var.github_repository != null ? 1 : 0
  depends_on                = [google_project_service.apis]
  workload_identity_pool_id = "${var.system_name}-${var.env_type}-gha-wi-pool"
  display_name              = "${var.system_name}-${var.env_type}-gha-wi-pool"
  description               = "Workload Identity Pool for GitHub Actions OIDC authentication"
  disabled                  = false
  project                   = local.project_id
}

resource "google_iam_workload_identity_pool_provider" "gha" {
  count                              = length(google_iam_workload_identity_pool.gha) > 0 ? 1 : 0
  workload_identity_pool_id          = google_iam_workload_identity_pool.gha[0].workload_identity_pool_id
  workload_identity_pool_provider_id = "${var.system_name}-${var.env_type}-gha-wi-pool-provider"
  display_name                       = "${var.system_name}-${var.env_type}-gha-wi-pool-provider"
  description                        = "OIDC provider for GitHub Actions"
  disabled                           = false
  project                            = local.project_id
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.ref"        = "assertion.ref"
    "attribute.actor"      = "assertion.actor"
    "attribute.workflow"   = "assertion.workflow"
  }
  attribute_condition = "assertion.repository == '${var.github_repository}'"
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account" "gha" {
  count                        = length(google_iam_workload_identity_pool.gha) > 0 ? 1 : 0
  account_id                   = "${var.system_name}-${var.env_type}-wif-gha-sa"
  display_name                 = "Service Account for Workload Identity Federation from GitHub Actions"
  description                  = "Service account to be used with Workload Identity Federation from GitHub Actions"
  disabled                     = false
  project                      = local.project_id
  create_ignore_already_exists = var.service_account_create_ignore_already_exists
}

resource "google_project_iam_member" "gha" {
  for_each = toset(length(google_service_account.gha) > 0 ? var.project_iam_member_roles_for_gha : [])
  member   = "serviceAccount:${google_service_account.gha[0].email}"
  role     = each.value
  project  = local.project_id
  dynamic "condition" {
    for_each = var.project_iam_member_condition_expression != null && var.project_iam_member_condition_title != null ? [true] : []
    content {
      expression  = var.project_iam_member_condition_expression
      title       = var.project_iam_member_condition_title
      description = var.project_iam_member_condition_description
    }
  }
}

resource "google_service_account_iam_member" "gha" {
  for_each           = { for k, v in google_service_account.gha : k => v.name }
  service_account_id = each.value
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.gha[0].name}/attribute.repository/${var.github_repository}"
  role               = "roles/iam.workloadIdentityUser"
  dynamic "condition" {
    for_each = var.service_account_iam_condition_expression != null && var.service_account_iam_condition_title != null ? [true] : []
    content {
      expression  = var.service_account_iam_condition_expression
      title       = var.service_account_iam_condition_title
      description = var.service_account_iam_condition_description
    }
  }
}

resource "google_storage_bucket" "logs" {
  depends_on                  = [google_project_service.apis]
  count                       = var.storage_logs_bucket_name != null ? 1 : 0
  name                        = var.storage_logs_bucket_name
  project                     = local.project_id
  location                    = local.region
  force_destroy               = var.force_destroy
  storage_class               = var.storage_class
  default_event_based_hold    = var.storage_default_event_based_hold
  enable_object_retention     = false
  requester_pays              = var.storage_requester_pays
  rpo                         = var.storage_rpo
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  dynamic "versioning" {
    for_each = var.storage_versioning_enabled != null ? [true] : []
    content {
      enabled = var.storage_versioning_enabled
    }
  }
  dynamic "autoclass" {
    for_each = var.storage_autoclass_enabled != null ? [true] : []
    content {
      enabled                = var.storage_autoclass_enabled
      terminal_storage_class = var.storage_autoclass_terminal_storage_class
    }
  }
  dynamic "hierarchical_namespace" {
    for_each = var.storage_hierarchical_namespace_enabled ? [true] : []
    content {
      enabled = true
    }
  }
  dynamic "retention_policy" {
    for_each = var.storage_retention_policy_retention_period > 0 ? [true] : []
    content {
      is_locked        = false
      retention_period = var.storage_retention_policy_retention_period
    }
  }
  dynamic "encryption" {
    for_each = local.storage_kms_default_key_name != null ? [true] : []
    content {
      default_kms_key_name = local.storage_kms_default_key_name
    }
  }
  dynamic "custom_placement_config" {
    for_each = length(var.storage_custom_placement_config_data_locations) > 0 ? [true] : []
    content {
      data_locations = var.storage_custom_placement_config_data_locations
    }
  }
  labels = {
    name        = var.storage_logs_bucket_name
    system-name = var.system_name
    env-type    = var.env_type
  }
}

resource "google_storage_bucket" "io" {
  depends_on                  = [google_project_service.apis]
  count                       = var.storage_io_bucket_name != null ? 1 : 0
  name                        = var.storage_io_bucket_name
  project                     = local.project_id
  location                    = local.region
  force_destroy               = var.force_destroy
  storage_class               = var.storage_class
  default_event_based_hold    = var.storage_default_event_based_hold
  enable_object_retention     = false
  requester_pays              = var.storage_requester_pays
  rpo                         = var.storage_rpo
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  dynamic "versioning" {
    for_each = var.storage_versioning_enabled != null ? [true] : []
    content {
      enabled = var.storage_versioning_enabled
    }
  }
  dynamic "autoclass" {
    for_each = var.storage_autoclass_enabled != null ? [true] : []
    content {
      enabled                = var.storage_autoclass_enabled
      terminal_storage_class = var.storage_autoclass_terminal_storage_class
    }
  }
  dynamic "hierarchical_namespace" {
    for_each = var.storage_hierarchical_namespace_enabled ? [true] : []
    content {
      enabled = true
    }
  }
  dynamic "retention_policy" {
    for_each = var.storage_retention_policy_retention_period > 0 ? [true] : []
    content {
      is_locked        = false
      retention_period = var.storage_retention_policy_retention_period
    }
  }
  dynamic "logging" {
    for_each = length(google_storage_bucket.logs) > 0 ? [true] : []
    content {
      log_bucket        = google_storage_bucket.logs[0].name
      log_object_prefix = "cloudstorage/${var.storage_io_bucket_name}/"
    }
  }
  dynamic "encryption" {
    for_each = local.storage_kms_default_key_name != null ? [true] : []
    content {
      default_kms_key_name = local.storage_kms_default_key_name
    }
  }
  dynamic "custom_placement_config" {
    for_each = length(var.storage_custom_placement_config_data_locations) > 0 ? [true] : []
    content {
      data_locations = var.storage_custom_placement_config_data_locations
    }
  }
  labels = {
    name        = var.storage_io_bucket_name
    system-name = var.system_name
    env-type    = var.env_type
  }
}

resource "google_kms_key_ring" "storage" {
  count    = var.storage_kms_create ? 1 : 0
  name     = local.storage_kms_key_ring_name
  location = local.storage_kms_key_location
  project  = local.project_id
}

resource "google_kms_crypto_key" "storage" {
  count           = var.storage_kms_create ? 1 : 0
  name            = local.storage_kms_crypto_key_name
  key_ring        = google_kms_key_ring.storage[0].id
  purpose         = "ENCRYPT_DECRYPT"
  rotation_period = var.storage_kms_crypto_key_rotation_period
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_crypto_key_iam_member" "storage_sa" {
  for_each = var.storage_kms_create ? merge(
    { for k, v in google_service_account.aws : "aws-${k}" => v.email },
    { for k, v in google_service_account.gha : "gha-${k}" => v.email }
  ) : {}
  crypto_key_id = google_kms_crypto_key.storage[0].id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${each.value}"
}

resource "google_kms_crypto_key_iam_member" "storage_gcs" {
  count         = var.storage_kms_create ? 1 : 0
  crypto_key_id = google_kms_crypto_key.storage[0].id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${local.storage_service_account}"
}
