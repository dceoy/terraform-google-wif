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
