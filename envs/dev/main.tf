module "wif" {
  source            = "../../modules/wif"
  system_name       = var.system_name
  env_type          = var.env_type
  aws_account_id    = var.aws_account_id
  aws_iam_role_name = var.aws_iam_role_name
}

module "vertexai" {
  source                      = "../../modules/vertexai"
  system_name                 = var.system_name
  env_type                    = var.env_type
  workload_identity_pool_name = module.wif.workload_identity_pool_name
  aws_iam_role_name           = var.aws_iam_role_name
  gemini_model                = var.gemini_model
  enable_fine_tuning          = var.enable_fine_tuning
  data_retention_days         = var.data_retention_days
  model_retention_days        = var.model_retention_days
  kms_key_name                = var.kms_key_name
}
