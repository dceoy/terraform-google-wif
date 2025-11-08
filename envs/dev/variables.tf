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

variable "aws_iam_role_arn" {
  description = "AWS IAM role ARN authorized for Workload Identity Federation"
  type        = string
  validation {
    condition     = can(regex("^arn:aws:(?:iam|sts)::[0-9]{12}:(?:assumed-role|role)/[\\w+=,.@-]+(?:/.*)?$", var.aws_iam_role_arn))
    error_message = "AWS IAM role ARN must match arn:aws:iam::123456789012:role/role-name or arn:aws:sts::123456789012:assumed-role/role-name formats."
  }
}
