resource "google_service_account" "vertexai" {
  account_id   = "${var.system_name}-${var.env_type}-vertexai-sa"
  display_name = "Vertex AI Gemini Service Account for ${var.env_type}"
  description  = "Service account for accessing Vertex AI Gemini API from AWS"
}

resource "google_service_account_iam_member" "wif" {
  service_account_id = google_service_account.vertexai.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${var.workload_identity_pool_name}/attribute.aws_role/${local.aws_iam_role_name}"
}

resource "google_project_iam_member" "aiplatformuser" {
  project = local.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.vertexai.email}"
}
