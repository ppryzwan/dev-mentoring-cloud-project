resource "google_workflows_workflow" "workflow_trigger" {
  name                = var.function_name
  region              = var.region
  description         = var.description
  call_log_level      = "LOG_ERRORS_ONLY"
  deletion_protection = false
  service_account     = var.service_account
  source_contents = templatefile(
    "${path.module}/workflow-example.yaml",
    {
      function_url = var.function_url
      address      = var.address
    }
  )
}
resource "google_cloud_scheduler_job" "workflow_trigger" {
  name        = "${var.function_name}-workflow-trigger"
  description = "Triggers ${var.function_name} workflow every 24 hours"
  schedule    = var.cron_expression
  time_zone   = "UTC"

  http_target {
    http_method = "POST"
    uri         = "https://workflowexecutions.googleapis.com/v1/projects/${var.project_id}/locations/${var.region}/workflows/${google_workflows_workflow.workflow_trigger.name}/executions"

  }
}
