resource "google_service_account" "vertexai" {
  account_id   = "${var.system_name}-${var.env_type}-vertexai-sa"
  display_name = "Vertex AI Gemini Service Account for ${var.env_type}"
  description  = "Service account for accessing Vertex AI Gemini API from AWS"
}

resource "google_service_account_iam_member" "workload_identity_binding" {
  service_account_id = google_service_account.vertexai.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${var.workload_identity_pool_name}/attribute.aws_role/${var.aws_iam_role_name}"
}

resource "google_project_iam_member" "vertexai_user" {
  project = local.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.vertexai.email}"
}

resource "google_project_iam_member" "ml_developer" {
  count   = var.enable_fine_tuning ? 1 : 0
  project = local.project_id
  role    = "roles/ml.developer"
  member  = "serviceAccount:${google_service_account.vertexai.email}"
}

resource "google_project_iam_custom_role" "vertex_ai_fine_tuning" {
  count       = var.enable_fine_tuning ? 1 : 0
  project     = local.project_id
  role_id     = "vertexAiFineTuning${title(var.env_type)}"
  title       = "Vertex AI Fine-tuning Role for ${var.env_type}"
  description = "Permissions for fine-tuning Gemini models in Vertex AI"

  permissions = [
    # Model operations
    "aiplatform.models.create",
    "aiplatform.models.delete",
    "aiplatform.models.export",
    "aiplatform.models.get",
    "aiplatform.models.list",
    "aiplatform.models.update",

    # Training operations
    "aiplatform.trainingPipelines.create",
    "aiplatform.trainingPipelines.get",
    "aiplatform.trainingPipelines.list",
    "aiplatform.trainingPipelines.cancel",

    # Dataset operations
    "aiplatform.datasets.create",
    "aiplatform.datasets.get",
    "aiplatform.datasets.list",
    "aiplatform.datasets.update",
    "aiplatform.datasets.delete",
    "aiplatform.datasets.import",
    "aiplatform.datasets.export",

    # Endpoint operations
    "aiplatform.endpoints.create",
    "aiplatform.endpoints.deploy",
    "aiplatform.endpoints.get",
    "aiplatform.endpoints.list",
    "aiplatform.endpoints.predict",
    "aiplatform.endpoints.explain",
    "aiplatform.endpoints.undeploy",
    "aiplatform.endpoints.update",
    "aiplatform.endpoints.delete",

    # Job operations
    "aiplatform.customJobs.create",
    "aiplatform.customJobs.get",
    "aiplatform.customJobs.list",
    "aiplatform.customJobs.cancel",

    # Storage operations
    "storage.buckets.get",
    "storage.buckets.list",
    "storage.objects.create",
    "storage.objects.delete",
    "storage.objects.get",
    "storage.objects.list",
    "storage.objects.update",
  ]
}

resource "google_project_iam_member" "vertex_ai_fine_tuning_member" {
  count   = var.enable_fine_tuning ? 1 : 0
  project = local.project_id
  role    = google_project_iam_custom_role.vertex_ai_fine_tuning[0].id
  member  = "serviceAccount:${google_service_account.vertexai.email}"
}

resource "google_storage_bucket" "vertexai" {
  count         = var.enable_fine_tuning ? 1 : 0
  project       = local.project_id
  name          = "${var.system_name}-${var.env_type}-vertexai-${local.region}-${local.project_id}"
  location      = local.region
  force_destroy = var.env_type == "dev"

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age            = var.data_retention_days
      matches_prefix = ["training-data/"]
      with_state     = "ANY"
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age            = 90
      matches_prefix = ["models/"]
      with_state     = "ANY"
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }

  lifecycle_rule {
    condition {
      age            = var.model_retention_days
      matches_prefix = ["models/"]
      with_state     = "ANY"
    }
    action {
      type          = "SetStorageClass"
      storage_class = "ARCHIVE"
    }
  }

  lifecycle_rule {
    condition {
      age            = 7
      matches_prefix = ["temp/"]
      with_state     = "ANY"
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      num_newer_versions = 3
      matches_prefix     = ["datasets/"]
      with_state         = "ARCHIVED"
    }
    action {
      type = "Delete"
    }
  }

  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }

  encryption {
    default_kms_key_name = var.kms_key_name != "" ? var.kms_key_name : null
  }

  labels = {
    name        = "${var.system_name}-${var.env_type}-vertexai-${local.region}-${local.project_id}"
    system-name = var.system_name
    env-type    = var.env_type
  }
}

resource "google_storage_bucket_iam_member" "vertexai" {
  count  = var.enable_fine_tuning ? 1 : 0
  bucket = google_storage_bucket.vertexai[0].name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.vertexai.email}"
}

resource "google_storage_bucket_object" "directory_structure" {
  for_each = var.enable_fine_tuning && var.env_type == "dev" ? toset([
    "training-data/README.md",
    "models/README.md",
    "datasets/README.md",
    "temp/README.md",
    "exports/README.md",
    "logs/README.md"
  ]) : toset([])

  name   = each.key
  bucket = google_storage_bucket.vertexai[0].name

  content = <<-EOT
    # ${dirname(each.key)} Directory

    ## Purpose
    ${
  dirname(each.key) == "training-data" ? "Store training data files in JSONL format for fine-tuning" :
  dirname(each.key) == "models" ? "Store fine-tuned model artifacts and checkpoints" :
  dirname(each.key) == "datasets" ? "Store processed datasets for Vertex AI" :
  dirname(each.key) == "temp" ? "Temporary files (auto-deleted after 7 days)" :
  dirname(each.key) == "exports" ? "Exported predictions and evaluation results" :
  dirname(each.key) == "logs" ? "Training and prediction logs" :
  "General storage"
  }

    ## Directory Structure
    ```
    ${dirname(each.key)}/
    ${
  dirname(each.key) == "training-data" ? "├── raw/\n├── processed/\n└── jsonl/" :
  dirname(each.key) == "models" ? "├── fine-tuned/\n├── checkpoints/\n└── exported/" :
  dirname(each.key) == "datasets" ? "├── train/\n├── validation/\n└── test/" :
  dirname(each.key) == "temp" ? "└── [temporary files]" :
  dirname(each.key) == "exports" ? "├── predictions/\n└── evaluations/" :
  dirname(each.key) == "logs" ? "├── training/\n└── serving/" :
  ""
  }
    ```

    ## Retention Policy
    ${
  dirname(each.key) == "training-data" ? "Files are automatically deleted after ${var.data_retention_days} days" :
  dirname(each.key) == "models" ? "Files are moved to NEARLINE after 90 days, ARCHIVE after ${var.model_retention_days} days" :
  dirname(each.key) == "datasets" ? "Only the 3 most recent versions are kept" :
  dirname(each.key) == "temp" ? "Files are automatically deleted after 7 days" :
  "No automatic retention policy"
}
  EOT
}
