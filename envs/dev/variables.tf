variable "system_name" {
  description = "System name"
  type        = string
}

variable "env_type" {
  description = "Environment type"
  type        = string
}

variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "Google Cloud region"
  type        = string
  default     = "us-central1"
}

variable "aws_account_id" {
  description = "AWS Account ID authorized for Workload Identity Federation"
  type        = string
}

variable "aws_iam_role_name" {
  description = "AWS IAM Role allowed to impersonate the Vertex AI service account"
  type        = string
}

variable "gemini_model" {
  description = "Gemini model to use"
  type        = string
  default     = "gemini-2.5-pro"
}

variable "enable_fine_tuning" {
  description = "Enable resources required for fine-tuning"
  type        = bool
  default     = true
}

variable "data_retention_days" {
  description = "Number of days to retain training data in GCS"
  type        = number
  default     = 90
}

variable "model_retention_days" {
  description = "Number of days to retain model artifacts"
  type        = number
  default     = 365
}

variable "kms_key_name" {
  description = "Optional CMEK key for encrypting the Vertex AI bucket"
  type        = string
  default     = ""
}
