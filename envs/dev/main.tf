module "wif" {
  source                           = "../../modules/wif"
  system_name                      = var.system_name
  env_type                         = var.env_type
  aws_account_id                   = var.aws_account_id
  aws_iam_role_name                = var.aws_iam_role_name
  github_repository                = var.github_repository
  project_iam_member_roles_for_aws = var.project_iam_member_roles_for_aws
  project_iam_member_roles_for_gha = var.project_iam_member_roles_for_gha
}
