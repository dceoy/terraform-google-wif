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
  description = "AWS account ID that owns the IAM role authorized for Workload Identity Federation"
  type        = string
  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "AWS account ID must be a 12-digit numeric string."
  }
}

variable "aws_iam_role_name" {
  description = "AWS IAM role name authorized for Workload Identity Federation"
  type        = string
  validation {
    condition     = can(regex("^[\\w+=,.@-]+(?:/[\\w+=,.@-]+)*$", var.aws_iam_role_name))
    error_message = "AWS IAM role name may contain letters, numbers, and the characters +=,.@- with optional path segments separated by '/'."
  }
}
