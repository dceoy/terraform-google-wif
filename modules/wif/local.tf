data "google_client_config" "current" {}

locals {
  project_id       = var.project_id != null ? var.project_id : data.google_client_config.current.project
  aws_sts_role_arn = "arn:aws:sts::${var.aws_account_id}:assumed-role/${var.aws_iam_role_name}"
}
