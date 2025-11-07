output "workload_identity_pool_name" {
  description = "Full resource name of the Workload Identity Pool"
  value       = module.wif.workload_identity_pool_name
}

output "workload_identity_pool_provider_name" {
  description = "Full resource name of the Workload Identity Pool Provider"
  value       = module.wif.workload_identity_pool_provider_name
}

output "sts_endpoint" {
  description = "STS endpoint for token exchange"
  value       = module.wif.sts_endpoint
}

output "sts_audience" {
  description = "Audience for STS token exchange"
  value       = module.wif.sts_audience
}

output "aws_configuration" {
  description = "AWS configuration details for establishing Workload Identity Federation"
  value       = module.wif.aws_configuration
}

output "service_account_email" {
  description = "Email of the Vertex AI service account"
  value       = module.vertexai.service_account_email
}

output "service_account_name" {
  description = "Full name of the Vertex AI service account resource"
  value       = module.vertexai.service_account_name
}

output "vertex_ai_endpoint" {
  description = "Vertex AI endpoint for the specified region"
  value       = module.vertexai.vertex_ai_endpoint
}

output "gemini_model_path" {
  description = "Full path to the configured Gemini model"
  value       = module.vertexai.gemini_model_path
}

output "cloud_storage_bucket_name" {
  description = "Name of the GCS bucket used for Vertex AI operations"
  value       = module.vertexai.cloud_storage_bucket_name
}

output "cloud_storage_bucket_uri" {
  description = "GCS bucket URI used for Vertex AI operations"
  value       = module.vertexai.cloud_storage_bucket_uri
}

output "cloud_storage_bucket_paths" {
  description = "Convenience GCS paths for structured data"
  value       = module.vertexai.cloud_storage_bucket_paths
}
