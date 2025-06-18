locals {
  function_dir = "${path.cwd}/../dist_functions"
}

resource "google_storage_bucket_object" "function_zip" {
  name   = "${var.storage_folder_name}/${var.zip_file_name}.zip"
  bucket = var.bucket_functions_name
  source = "${local.function_dir}/${var.zip_file_name}.zip"
}

resource "google_cloudfunctions2_function" "function-normal" {
  name        = var.function_name
  description = var.description
  location    = var.region

  build_config {
    runtime     = var.runtime
    entry_point = var.entry_point
    source {
      storage_source {
        bucket = var.bucket_functions_name
        object = google_storage_bucket_object.function_zip.name
      }
    }
  }

  service_config {
    available_memory      = var.available_memory
    timeout_seconds       = var.timeout_seconds
    environment_variables = var.environment_variables
  }
}
