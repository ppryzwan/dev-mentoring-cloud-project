data "google_compute_default_service_account" "default" {
}

resource "google_cloud_scheduler_job" "job" {
  name             = "function_scheduler_weather"
  schedule         = var.cron_expression
  time_zone        = "Europe/Warsaw"
  attempt_deadline = "320s"

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "GET"
    uri         = var.weather_uri ## Somehow this isn't working for addresses
    headers = {
      "Content-Type" = "application/json"
    }
    oidc_token {
      service_account_email = data.google_compute_default_service_account.default.email
    }
  }

}
