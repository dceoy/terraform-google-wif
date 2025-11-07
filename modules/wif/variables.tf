variable "system_name" {
  description = "System name"
  type        = string
}

variable "env_type" {
  description = "Environment type"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID for Workload Identity Federation"
  type        = string
  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "AWS Account ID must be a 12-digit number."
  }
}

variable "aws_iam_role_name" {
  description = "AWS IAM Role name that will access Google Cloud resources"
  type        = string
}
