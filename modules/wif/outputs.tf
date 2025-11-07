output "workload_identity_pool_name" {
  description = "Full resource name of the Workload Identity Pool"
  value       = google_iam_workload_identity_pool.aws.name
}

output "workload_identity_pool_provider_name" {
  description = "Full resource name of the Workload Identity Pool Provider"
  value       = google_iam_workload_identity_pool_provider.aws.name
}

output "sts_endpoint" {
  description = "STS endpoint for token exchange"
  value       = "https://sts.googleapis.com/v1/token"
}

output "sts_audience" {
  description = "Audience for STS token exchange"
  value       = "//iam.googleapis.com/${google_iam_workload_identity_pool_provider.aws.name}"
}

output "aws_configuration" {
  description = "AWS configuration instructions"
  value = {
    role_arn               = local.aws_iam_role_arn
    workload_identity_pool = google_iam_workload_identity_pool.aws.name
    provider               = google_iam_workload_identity_pool_provider.aws.name
  }
}
