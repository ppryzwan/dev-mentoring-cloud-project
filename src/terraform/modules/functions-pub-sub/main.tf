resource "google_storage_bucket_object" "trigger_function_zip" {
  name   = "${var.pubsub_function_name}-${filemd5(var.zip_path)}.zip"
  source = var.zip_path
  bucket = var.bucket_functions_name
}

resource "google_cloudfunctions2_function" "trigger-function" {
  for_each    = var.pubsub_topics
  name        = "${var.pubsub_function_name}_${each.key}"
  description = var.description
  location    = var.region

  build_config {
    runtime     = var.runtime
    entry_point = var.entry_point
    source {
      storage_source {
        bucket = var.bucket_functions_name
        object = google_storage_bucket_object.trigger_function_zip.name
      }
    }
  }

  service_config {
    available_memory      = var.available_memory
    timeout_seconds       = var.timeout_seconds
    environment_variables = var.environment_variables
  }
  event_trigger {
    trigger_region = var.region
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = "projects/${var.project_id}/topics/${each.value}"
    retry_policy   = "RETRY_POLICY_RETRY"
  }

}
