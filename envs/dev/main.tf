module "wif" {
  source      = "../../modules/iam"
  project_id  = var.project_id
  region      = var.region
  system_name = var.system_name
  env_type    = var.env_type
}
