data "google_client_config" "current" {}

locals {
  project_id       = var.project_id != null ? var.project_id : data.google_client_config.current.project
  region           = var.region != null ? var.region : data.google_client_config.current.region
  aws_sts_role_arn = var.aws_account_id != null && var.aws_iam_role_name != null ? "arn:aws:sts::${var.aws_account_id}:assumed-role/${var.aws_iam_role_name}" : null
}
