data "google_client_config" "current" {}

locals {
  project_id     = var.project_id != null ? var.project_id : data.google_client_config.current.project
  aws_account_id = split(":", var.aws_iam_role_arn)[4]
}
