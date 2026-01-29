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

output "service_account_member_for_aws" {
  description = "Member of the WIF service account for AWS"
  value       = length(google_service_account.aws) > 0 ? google_service_account.aws[0].member : null
}

output "service_account_unique_id_for_aws" {
  description = "Unique ID of the WIF service account for AWS"
  value       = length(google_service_account.aws) > 0 ? google_service_account.aws[0].unique_id : null
}

output "project_iam_member_etags_for_aws" {
  description = "ETags of the project IAM member bindings keyed by role for AWS"
  value       = { for k, v in google_project_iam_member.aws : k => v.etag }
}

output "service_account_iam_member_etags_for_aws" {
  description = "ETags of the service account IAM member binding for AWS"
  value       = { for k, v in google_service_account_iam_member.aws : k => v.etag }
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

output "service_account_member_for_gha" {
  description = "Member of the WIF service account for GitHub Actions"
  value       = length(google_service_account.gha) > 0 ? google_service_account.gha[0].member : null
}

output "service_account_unique_id_for_gha" {
  description = "Unique ID of the WIF service account for GitHub Actions"
  value       = length(google_service_account.gha) > 0 ? google_service_account.gha[0].unique_id : null
}

output "project_iam_member_etags_for_gha" {
  description = "ETags of the project IAM member bindings keyed by role for GitHub Actions"
  value       = { for k, v in google_project_iam_member.gha : k => v.etag }
}

output "service_account_iam_member_etags_for_gha" {
  description = "ETags of the service account IAM member binding for GitHub Actions"
  value       = { for k, v in google_service_account_iam_member.gha : k => v.etag }
}

output "kms_key_ring_id" {
  description = "KMS key ring ID"
  value       = length(google_kms_key_ring.main) > 0 ? google_kms_key_ring.main[0].id : null
}

output "kms_crypto_key_id" {
  description = "KMS crypto key ID"
  value       = length(google_kms_crypto_key.main) > 0 ? google_kms_crypto_key.main[0].id : null
}

output "storage_logs_bucket_self_link" {
  description = "URI of the cloud storage bucket for logs"
  value       = length(google_storage_bucket.logs) > 0 ? google_storage_bucket.logs[0].self_link : null
}

output "storage_logs_bucket_url" {
  description = "Base URL of the cloud storage bucket for logs"
  value       = length(google_storage_bucket.logs) > 0 ? google_storage_bucket.logs[0].url : null
}

output "storage_io_bucket_self_link" {
  description = "URI of the cloud storage bucket for IO"
  value       = length(google_storage_bucket.io) > 0 ? google_storage_bucket.io[0].self_link : null
}

output "storage_io_bucket_url" {
  description = "Base URL of the cloud storage bucket for IO"
  value       = length(google_storage_bucket.io) > 0 ? google_storage_bucket.io[0].url : null
}
