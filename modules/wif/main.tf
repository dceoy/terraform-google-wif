resource "google_project_service" "apis" {
  for_each = toset([
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
    "aiplatform.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "storage.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com"
  ])
  project            = local.project_id
  service            = each.key
  disable_on_destroy = false
}

resource "google_iam_workload_identity_pool" "aws" {
  depends_on                = [google_project_service.apis]
  workload_identity_pool_id = "${var.system_name}-${var.env_type}-aws-wip"
  display_name              = "AWS Workload Identity Pool for ${var.env_type}"
  description               = "Identity pool for AWS IAM role authentication"
  disabled                  = false
}

resource "google_iam_workload_identity_pool_provider" "aws" {
  depends_on                         = [google_iam_workload_identity_pool.aws]
  workload_identity_pool_provider_id = "${var.system_name}-${var.env_type}-aws-wip-provider"
  workload_identity_pool_id          = google_iam_workload_identity_pool.aws.workload_identity_pool_id
  display_name                       = "AWS Workload Identity Pool Provider for ${var.env_type}"
  description                        = "OIDC provider for AWS IAM role"
  disabled                           = false
  attribute_mapping = {
    "google.subject"       = "assertion.arn"
    "attribute.aws_role"   = "assertion.arn.extract('assumed-role/{role}/')"
    "attribute.account_id" = "assertion.account"
  }
  attribute_condition = "assertion.arn == '${var.aws_iam_role_arn}'"
  aws {
    account_id = local.aws_account_id
  }
}
