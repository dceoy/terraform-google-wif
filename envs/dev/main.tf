module "wif" {
  source           = "../../modules/wif"
  system_name      = var.system_name
  env_type         = var.env_type
  aws_iam_role_arn = var.aws_iam_role_arn
}

module "vertexai" {
  source                      = "../../modules/vertexai"
  system_name                 = var.system_name
  env_type                    = var.env_type
  workload_identity_pool_name = module.wif.workload_identity_pool_name
  aws_iam_role_arn            = var.aws_iam_role_arn
}
