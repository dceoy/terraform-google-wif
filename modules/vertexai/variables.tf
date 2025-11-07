variable "system_name" {
  description = "System name"
  type        = string
}

variable "env_type" {
  description = "Environment type"
  type        = string
}

variable "workload_identity_pool_name" {
  description = "Full resource name of the Workload Identity Pool used for federation"
  type        = string
}

variable "aws_iam_role_name" {
  description = "AWS IAM role that is allowed to impersonate the Vertex AI service account"
  type        = string
}

variable "gemini_model" {
  description = "Gemini model to use"
  type        = string
  default     = "gemini-2.5-pro"
}

variable "enable_fine_tuning" {
  description = "Enable fine-tuning capabilities and additional IAM permissions"
  type        = bool
  default     = true
}

variable "data_retention_days" {
  description = "Number of days to retain training data in the Vertex AI bucket"
  type        = number
  default     = 90
}

variable "model_retention_days" {
  description = "Number of days to retain model artifacts"
  type        = number
  default     = 365
}

variable "kms_key_name" {
  description = "Optional CMEK key to use for Vertex AI bucket encryption"
  type        = string
  default     = ""
}
