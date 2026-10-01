terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 7.9.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region = var.region
  default_labels = {
    system-name = var.system_name
    env-type = var.env_type
  }
}
