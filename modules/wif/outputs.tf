output "project_service_ids" {
  description = "List of enabled Google API service IDs"
  value       = [for svc in google_project_service.apis : svc.service]
}

output "workload_identity_pool_name_for_aws" {
  description = "Full resource name of the Workload Identity Pool for AWS"
  value       = length(google_iam_workload_identity_pool.aws) > 0 ? google_iam_workload_identity_pool.aws[0].name : null
}

output "workload_identity_pool_provider_name_for_aws" {
  description = "Full resource name of the Workload Identity Pool Provider for AWS"
  value       = length(google_iam_workload_identity_pool_provider.aws) > 0 ? google_iam_workload_identity_pool_provider.aws[0].name : null
}

output "service_account_name_for_aws" {
  description = "Full name of the WIF service account resource for AWS"
  value       = length(google_service_account.aws) > 0 ? google_service_account.aws[0].name : null
}

output "service_account_email_for_aws" {
  description = "Email of the WIF service account for AWS"
  value       = length(google_service_account.aws) > 0 ? google_service_account.aws[0].email : null
}

output "service_account_unique_id_for_aws" {
  description = "Unique ID of the WIF service account for AWS"
  value       = length(google_service_account.aws) > 0 ? google_service_account.aws[0].unique_id : null
}

output "service_account_member_for_aws" {
  description = "IAM member string for the WIF service account for AWS"
  value       = length(google_service_account.aws) > 0 ? "serviceAccount:${google_service_account.aws[0].email}" : null
}

output "google_service_account_iam_member_etag_for_aws" {
  description = "ETag of the service account IAM member binding for AWS"
  value       = length(google_service_account_iam_member.aws) > 0 ? google_service_account_iam_member.aws[0].etag : null
}

output "google_project_iam_member_etag_for_aws" {
  description = "ETags of the project IAM member bindings keyed by role for AWS"
  value       = { for role, binding in google_project_iam_member.aws : role => binding.etag }
}

output "workload_identity_pool_name_for_gha" {
  description = "Full resource name of the Workload Identity Pool for GitHub Actions"
  value       = length(google_iam_workload_identity_pool.gha) > 0 ? google_iam_workload_identity_pool.gha[0].name : null
}

output "workload_identity_pool_provider_name_for_gha" {
  description = "Full resource name of the Workload Identity Pool Provider for GitHub Actions"
  value       = length(google_iam_workload_identity_pool_provider.gha) > 0 ? google_iam_workload_identity_pool_provider.gha[0].name : null
}

output "service_account_name_for_gha" {
  description = "Full name of the WIF service account resource for GitHub Actions"
  value       = length(google_service_account.gha) > 0 ? google_service_account.gha[0].name : null
}

output "service_account_email_for_gha" {
  description = "Email of the WIF service account for GitHub Actions"
  value       = length(google_service_account.gha) > 0 ? google_service_account.gha[0].email : null
}

output "service_account_unique_id_for_gha" {
  description = "Unique ID of the WIF service account for GitHub Actions"
  value       = length(google_service_account.gha) > 0 ? google_service_account.gha[0].unique_id : null
}

output "service_account_member_for_gha" {
  description = "IAM member string for the WIF service account for GitHub Actions"
  value       = length(google_service_account.gha) > 0 ? "serviceAccount:${google_service_account.gha[0].email}" : null
}

output "google_service_account_iam_member_etag_for_gha" {
  description = "ETag of the service account IAM member binding for GitHub Actions"
  value       = length(google_service_account_iam_member.gha) > 0 ? google_service_account_iam_member.gha[0].etag : null
}

output "google_project_iam_member_etag_for_gha" {
  description = "ETags of the project IAM member bindings keyed by role for GitHub Actions"
  value       = { for role, binding in google_project_iam_member.gha : role => binding.etag }
}
