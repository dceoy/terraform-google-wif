module "wif" {
  source            = "../../modules/wif"
  system_name       = var.system_name
  env_type          = var.env_type
  aws_account_id    = var.aws_account_id
  aws_iam_role_name = var.aws_iam_role_name
  project_id        = var.project_id
}
