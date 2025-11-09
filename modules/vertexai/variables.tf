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

variable "aws_iam_role_arn" {
  description = "AWS IAM role ARN authorized to impersonate the Vertex AI service account"
  type        = string
  validation {
    condition     = can(regex("^arn:aws:(?:iam|sts)::[0-9]{12}:(?:assumed-role|role)/[\\w+=,.@-]+(?:/.*)?$", var.aws_iam_role_arn))
    error_message = "AWS IAM role ARN must match arn:aws:iam::123456789012:role/role-name or arn:aws:sts::123456789012:assumed-role/role-name formats."
  }
}

variable "project_id" {
  description = "Optional project ID override for Google resources; defaults to the provider project"
  type        = string
  default     = null
}

variable "service_account_create_ignore_already_exists" {
  description = "Ignore AlreadyExists errors when creating the service account"
  type        = bool
  default     = false
}

variable "service_account_iam_condition_expression" {
  description = "Optional CEL expression for the service account IAM binding"
  type        = string
  default     = null
}

variable "service_account_iam_condition_title" {
  description = "Title for the service account IAM condition"
  type        = string
  default     = null
}

variable "service_account_iam_condition_description" {
  description = "Description for the service account IAM condition"
  type        = string
  default     = null
}

variable "project_iam_member_condition_expression" {
  description = "Optional CEL expression for the project IAM binding"
  type        = string
  default     = null
}

variable "project_iam_member_condition_title" {
  description = "Title for the project IAM condition"
  type        = string
  default     = null
}

variable "project_iam_member_condition_description" {
  description = "Description for the project IAM condition"
  type        = string
  default     = null
}
