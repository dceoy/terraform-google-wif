output "project_service_ids" {
  description = "List of enabled Google API service IDs"
  value       = [for svc in google_project_service.apis : svc.service]
}

output "workload_identity_pool_name" {
  description = "Full resource name of the Workload Identity Pool"
  value       = google_iam_workload_identity_pool.aws.name
}

output "workload_identity_pool_provider_name" {
  description = "Full resource name of the Workload Identity Pool Provider"
  value       = google_iam_workload_identity_pool_provider.aws.name
}

output "service_account_name" {
  description = "Full name of the WIF service account resource"
  value       = google_service_account.wif.name
}

output "service_account_email" {
  description = "Email of the WIF service account"
  value       = google_service_account.wif.email
}

output "service_account_unique_id" {
  description = "Unique ID of the WIF service account"
  value       = google_service_account.wif.unique_id
}

output "service_account_member" {
  description = "IAM member string for the WIF service account"
  value       = google_service_account.wif.member
}

output "google_service_account_iam_member_etag" {
  description = "ETag of the service account IAM member binding"
  value       = google_service_account_iam_member.wif.etag
}

output "google_project_iam_member_etag" {
  description = "ETags of the project IAM member bindings keyed by role"
  value       = { for role, binding in google_project_iam_member.wif : role => binding.etag }
}
