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

variable "region" {
  description = "Region for Google Cloud resources"
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
    "cloudresourcemanager.googleapis.com",
    "storage.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "aiplatform.googleapis.com"
  ]
}

variable "project_service_disable_on_destroy" {
  description = "Set to true to disable the API when destroying google_project_service"
  type        = bool
  default     = false
}

variable "project_service_disable_dependent_services" {
  description = "Disable any services dependent on the API when disabling it"
  type        = bool
  default     = false
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
  default = [
    "roles/aiplatform.user",
    "roles/storage.objectAdmin"
  ]
}

variable "project_iam_member_roles_for_gha" {
  description = "List of project-level IAM roles to grant to the WIF service account for GitHub Actions"
  type        = list(string)
  default = [
    "roles/config.admin",
    "roles/storage.admin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/iam.workloadIdentityPoolAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/resourcemanager.projectIamAdmin"
  ]
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

variable "storage_bucket_name" {
  description = "Name of the storage bucket to be created"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Whether to delete all contained objects when deleting the bucket"
  type        = bool
  default     = false
}

variable "storage_storage_class" {
  description = "Storage class of the storage bucket"
  type        = string
  default     = "STANDARD"
  validation {
    condition     = contains(["STANDARD", "MULTI_REGIONAL", "REGIONAL", "NEARLINE", "COLDLINE", "ARCHIVE"], var.storage_storage_class)
    error_message = "Storage class must be one of STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, or ARCHIVE."
  }
}

variable "storage_versioning_enabled" {
  description = "Whether to enable versioning for objects in the storage bucket"
  type        = bool
  default     = true
}

variable "storage_autoclass_enabled" {
  description = "Whether to enable autoclass for the storage bucket"
  type        = bool
  default     = true
}

variable "storage_default_event_based_hold" {
  description = "Whether to automatically apply an eventBasedHold to new objects added to the storage bucket"
  type        = bool
  default     = false
}

variable "storage_retention_policy_retention_period" {
  description = "The period of time, in seconds, that objects in the storage bucket must be retained and cannot be deleted, overwritten, or archived"
  type        = number
  default     = 0
  validation {
    condition     = var.storage_retention_policy_retention_period >= 0 && var.storage_retention_policy_retention_period < 2147483647
    error_message = "Retention period must be between 0 and 2,147,483,647 seconds."
  }
}

variable "storage_requester_pays" {
  description = "Whether to enable requester pays on the storage bucket"
  type        = bool
  default     = false
}

variable "storage_rpo" {
  description = "Recovery point objective for cross-region replication of the storage bucket (applicable only for dual and multi-region buckets)"
  type        = string
  default     = null
  validation {
    condition     = var.storage_rpo == null || contains(["DEFAULT", "ASYNC_TURBO"], var.storage_rpo)
    error_message = "RPO must be either DEFAULT or ASYNC_TURBO."
  }
}

variable "storage_logging_log_bucket" {
  description = "Log bucket name for access and storage logs of the storage bucket"
  type        = string
  default     = null
}

variable "storage_encryption_default_kms_key_name" {
  description = "ID of a Cloud KMS key that will be used to encrypt objects inserted into the storage bucket"
  type        = string
  default     = null
}

variable "storage_custom_placement_config_data_locations" {
  description = "List of individual regions that comprise a dual-region storage bucket"
  type        = list(string)
  default     = []
}

variable "storage_hierarchical_namespace_enabled" {
  description = "Whether to enable hierarchical namespace for the storage bucket"
  type        = bool
  default     = false
}
