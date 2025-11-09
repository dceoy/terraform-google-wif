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
