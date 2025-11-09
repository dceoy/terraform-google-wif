resource "google_service_account" "vertexai" {
  account_id                   = "${var.system_name}-${var.env_type}-vertexai-sa"
  display_name                 = "Vertex AI Gemini Service Account for ${var.env_type}"
  description                  = "Service account for accessing Vertex AI Gemini API from AWS"
  disabled                     = false
  project                      = local.project_id
  create_ignore_already_exists = var.service_account_create_ignore_already_exists
}

resource "google_service_account_iam_member" "wif" {
  service_account_id = google_service_account.vertexai.name
  member             = "principalSet://iam.googleapis.com/${var.workload_identity_pool_name}/attribute.aws_role/${local.aws_iam_role_name}"
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

resource "google_project_iam_member" "aiplatformuser" {
  project = local.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.vertexai.email}"
  dynamic "condition" {
    for_each = var.project_iam_member_condition_expression != null && var.project_iam_member_condition_title != null ? [true] : []
    content {
      expression  = var.project_iam_member_condition_expression
      title       = var.project_iam_member_condition_title
      description = var.project_iam_member_condition_description
    }
  }
}
