variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "Google Cloud region"
  type        = string
  default     = "us-central1"
}

variable "system_name" {
  description = "System name"
  type        = string
  default     = "gai"
}

variable "env_type" {
  description = "Environment type"
  type        = string
  default     = "dev"
}
