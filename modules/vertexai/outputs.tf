output "service_account_name" {
  description = "Full name of the Vertex AI service account resource"
  value       = google_service_account.vertexai.name
}

output "service_account_email" {
  description = "Email of the Vertex AI service account"
  value       = google_service_account.vertexai.email
}

output "service_account_unique_id" {
  description = "Unique ID of the Vertex AI service account"
  value       = google_service_account.vertexai.unique_id
}

output "service_account_member" {
  description = "IAM member string for the Vertex AI service account"
  value       = google_service_account.vertexai.member
}

output "google_service_account_iam_member_etag" {
  description = "ETag of the service account IAM member binding"
  value       = google_service_account_iam_member.wif.etag
}

output "google_project_iam_member_etag" {
  description = "ETag of the project IAM member binding"
  value       = google_project_iam_member.aiplatformuser.etag
}
