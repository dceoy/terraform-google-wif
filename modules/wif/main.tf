resource "google_project_service" "apis" {
  for_each                   = toset(var.enabled_apis)
  service                    = each.key
  project                    = local.project_id
  disable_on_destroy         = var.project_service_disable_on_destroy
  disable_dependent_services = var.project_service_disable_dependent_services
}

resource "google_iam_workload_identity_pool" "aws" {
  depends_on                = [google_project_service.apis]
  workload_identity_pool_id = "${var.system_name}-${var.env_type}-aws-wip"
  display_name              = "${var.system_name}-${var.env_type}-aws-wip"
  description               = "Workload Identity Pool for AWS IAM role authentication"
  disabled                  = false
  project                   = local.project_id
}

resource "google_iam_workload_identity_pool_provider" "aws" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.aws.workload_identity_pool_id
  workload_identity_pool_provider_id = "${var.system_name}-${var.env_type}-aws-wip-provider"
  display_name                       = "Workload Identity Pool Provider for AWS IAM role"
  description                        = "OIDC provider for AWS IAM role"
  disabled                           = false
  attribute_mapping = {
    "google.subject"       = "assertion.arn"
    "attribute.aws_role"   = "assertion.arn.extract('assumed-role/{role}/')"
    "attribute.account_id" = "assertion.account"
  }
  attribute_condition = "assertion.arn == '${local.aws_sts_role_arn}'"
  project             = local.project_id
  aws {
    account_id = var.aws_account_id
  }
}

resource "google_service_account" "wif" {
  depends_on                   = [google_project_service.apis]
  account_id                   = "${var.system_name}-${var.env_type}-wif-sa"
  display_name                 = "Service Account for Workload Identity Federation from AWS"
  description                  = "Service account to be used with Workload Identity Federation from AWS"
  disabled                     = false
  project                      = local.project_id
  create_ignore_already_exists = var.service_account_create_ignore_already_exists
}

resource "google_service_account_iam_member" "wif" {
  service_account_id = google_service_account.wif.name
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.aws.name}/attribute.aws_role/${var.aws_iam_role_name}"
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

resource "google_project_iam_member" "vertexai" {
  member  = "serviceAccount:${google_service_account.wif.email}"
  role    = "roles/aiplatform.user"
  project = local.project_id
  dynamic "condition" {
    for_each = var.project_iam_member_condition_expression != null && var.project_iam_member_condition_title != null ? [true] : []
    content {
      expression  = var.project_iam_member_condition_expression
      title       = var.project_iam_member_condition_title
      description = var.project_iam_member_condition_description
    }
  }
}
