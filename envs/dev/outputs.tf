output "workload_identity_pool_name" {
  description = "Full resource name of the Workload Identity Pool"
  value       = module.wif.workload_identity_pool_name
}

output "workload_identity_pool_provider_name" {
  description = "Full resource name of the Workload Identity Pool Provider"
  value       = module.wif.workload_identity_pool_provider_name
}

output "project_service_ids" {
  description = "List of enabled Google API service IDs"
  value       = module.wif.project_service_ids
}

output "service_account_email" {
  description = "Email of the Vertex AI service account"
  value       = module.wif.service_account_email
}

output "service_account_name" {
  description = "Full name of the Vertex AI service account resource"
  value       = module.wif.service_account_name
}

output "service_account_unique_id" {
  description = "Unique ID of the Vertex AI service account"
  value       = module.wif.service_account_unique_id
}

output "service_account_member" {
  description = "IAM member string for the Vertex AI service account"
  value       = module.wif.service_account_member
}

output "google_service_account_iam_member_etag" {
  description = "ETag of the service account IAM member binding"
  value       = module.wif.google_service_account_iam_member_etag
}

output "google_project_iam_member_etag" {
  description = "ETags of the project IAM member bindings keyed by role"
  value       = module.wif.google_project_iam_member_etag
}
