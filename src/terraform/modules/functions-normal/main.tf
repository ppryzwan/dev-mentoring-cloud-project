resource "google_storage_bucket_object" "function_zip" {
  name   = "${storage_folder_name}/${var.zip_file_name}.zip"
  bucket = var.bucket_functions_name
  source = "${var.functions_zip_file_path}/${var.zip_file_name}.zip"

  lifecycle {
    ignore_changes = [
      source,
      content,
      md5hash,
      crc32c
    ]
  }
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
  lifecycle {
    ignore_changes = [build_config[0].source[0].storage_source[0].object]
  }

  service_config {
    available_memory      = var.available_memory
    timeout_seconds       = var.timeout_seconds
    environment_variables = var.environment_variables
  }
}
