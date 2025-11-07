output "service_account_email" {
  description = "Email of the Vertex AI service account"
  value       = google_service_account.vertexai.email
}

output "service_account_name" {
  description = "Full name of the Vertex AI service account resource"
  value       = google_service_account.vertexai.name
}

output "vertex_ai_endpoint" {
  description = "Vertex AI endpoint for the specified region"
  value       = "https://${local.region}-aiplatform.googleapis.com"
}

output "gemini_model_path" {
  description = "Full path to the configured Gemini model"
  value       = "projects/${local.project_id}/locations/${local.region}/publishers/google/models/${var.gemini_model}"
}

output "cloud_storage_bucket_name" {
  description = "Name of the GCS bucket used for Vertex AI operations"
  value       = length(google_storage_bucket.vertexai) > 0 ? google_storage_bucket.vertexai[0].name : null
}

output "cloud_storage_bucket_uri" {
  description = "GCS bucket URI used for Vertex AI operations"
  value       = length(google_storage_bucket.vertexai) > 0 ? "gs://${google_storage_bucket.vertexai[0].name}" : null
}

output "cloud_storage_bucket_paths" {
  description = "Convenience GCS paths for structured data"
  value = length(google_storage_bucket.vertexai) > 0 ? {
    training_data = "gs://${google_storage_bucket.vertexai[0].name}/training-data/"
    models        = "gs://${google_storage_bucket.vertexai[0].name}/models/"
    datasets      = "gs://${google_storage_bucket.vertexai[0].name}/datasets/"
    temp          = "gs://${google_storage_bucket.vertexai[0].name}/temp/"
    exports       = "gs://${google_storage_bucket.vertexai[0].name}/exports/"
    logs          = "gs://${google_storage_bucket.vertexai[0].name}/logs/"
  } : null
}
