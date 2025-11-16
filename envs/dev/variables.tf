variable "system_name" {
  description = "System name"
  type        = string
}

variable "env_type" {
  description = "Environment type"
  type        = string
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

variable "github_repository" {
  description = "GitHub repository in the format 'owner/repo' that is authorized for Workload Identity Federation"
  type        = string
  validation {
    condition     = can(regex("^[^/]+/[^/]+$", var.github_repository))
    error_message = "GitHub repository must be in the format 'owner/repo'."
  }
}

variable "project_iam_member_roles_for_aws" {
  description = "List of project-level IAM roles to grant to the WIF service account for AWS"
  type        = list(string)
  default     = ["roles/aiplatform.user"]
}

variable "project_iam_member_roles_for_gha" {
  description = "List of project-level IAM roles to grant to the WIF service account for GitHub Actions"
  type        = list(string)
  default     = ["roles/config.admin"]
}
