resource "google_storage_bucket" "functions_codes_bucket" {
  name     = var.bucket_functions_name
  project  = var.project_id
  location = var.region

  versioning {
    enabled = var.version_storage
  }
  uniform_bucket_level_access = true
  force_destroy               = true
  storage_class               = var.storage_class
}
