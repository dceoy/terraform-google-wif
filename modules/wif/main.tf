resource "google_project_service" "apis" {
  for_each                   = toset(var.enabled_apis)
  service                    = each.key
  project                    = local.project_id
  disable_on_destroy         = var.project_service_disable_on_destroy
  disable_dependent_services = var.project_service_disable_dependent_services
}

resource "google_iam_workload_identity_pool" "aws" {
  depends_on                = [google_project_service.apis]
  workload_identity_pool_id = "${var.system_name}-${var.env_type}-aws-wip"
  display_name              = "${var.system_name}-${var.env_type}-aws-wip"
  description               = "Identity pool for AWS IAM role authentication"
  disabled                  = false
  project                   = local.project_id
}

resource "google_iam_workload_identity_pool_provider" "aws" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.aws.workload_identity_pool_id
  workload_identity_pool_provider_id = "${var.system_name}-${var.env_type}-aws-wip-provider"
  display_name                       = "AWS Workload Identity Pool Provider for ${var.env_type}"
  description                        = "OIDC provider for AWS IAM role"
  disabled                           = false
  attribute_mapping = {
    "google.subject"       = "assertion.arn"
    "attribute.aws_role"   = "assertion.arn.extract('assumed-role/{role}/')"
    "attribute.account_id" = "assertion.account"
  }
  attribute_condition = "assertion.arn == '${var.aws_iam_role_arn}'"
  project             = local.project_id
  aws {
    account_id = local.aws_account_id
  }
}
