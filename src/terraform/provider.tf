terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.26.0"
    }
  }
}

provider "google" {
  project = var.PROJECT_ID
  region  = var.REGION
  zone    = var.ZONE
}
