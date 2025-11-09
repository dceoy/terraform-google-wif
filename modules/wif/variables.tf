variable "system_name" {
  description = "System name"
  type        = string
}

variable "env_type" {
  description = "Environment type"
  type        = string
}

variable "aws_iam_role_arn" {
  description = "AWS IAM role ARN that is authorized for Workload Identity Federation"
  type        = string
  validation {
    condition     = can(regex("^arn:aws:(?:iam|sts)::[0-9]{12}:(?:assumed-role|role)/[\\w+=,.@-]+(?:/.*)?$", var.aws_iam_role_arn))
    error_message = "AWS IAM role ARN must match arn:aws:iam::123456789012:role/role-name or arn:aws:sts::123456789012:assumed-role/role-name formats."
  }
}

variable "project_id" {
  description = "Optional project ID override for all Google resources; defaults to the provider project"
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
