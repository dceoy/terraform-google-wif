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
  default     = null
  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "AWS account ID must be a 12-digit numeric string."
  }
}

variable "aws_iam_role_name" {
  description = "AWS IAM role name that is authorized for Workload Identity Federation"
  type        = string
  default     = null
  validation {
    condition     = can(regex("^[\\w+=,.@-]+(?:/[\\w+=,.@-]+)*$", var.aws_iam_role_name))
    error_message = "AWS IAM role name may contain letters, numbers, and the characters +=,.@- with optional path segments separated by '/'."
  }
}

variable "github_repository" {
  description = "GitHub repository in the format 'owner/repo' that is authorized for Workload Identity Federation"
  type        = string
  default     = null
  validation {
    condition     = can(regex("^[^/]+/[^/]+$", var.github_repository))
    error_message = "GitHub repository must be in the format 'owner/repo'."
  }
}

variable "project_id" {
  description = "Project ID for Google Cloud resources"
  type        = string
  default     = null
}

variable "enabled_apis" {
  description = "List of Google APIs that need to be enabled before creating Workload Identity Federation resources"
  type        = list(string)
  default = [
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
    "aiplatform.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "storage.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com"
  ]
}

variable "project_service_disable_on_destroy" {
  description = "Set to true to disable the API when destroying google_project_service"
  type        = bool
  default     = true
}

variable "project_service_disable_dependent_services" {
  description = "Disable any services dependent on the API when disabling it"
  type        = bool
  default     = true
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
