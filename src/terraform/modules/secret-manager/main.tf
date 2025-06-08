resource "google_secret_manager_secret" "secret-basic" {
  secret_id = var.secret_id

  labels = {
    label = var.label
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "secret-version" {
  secret      = google_secret_manager_secret.secret-basic.id
  secret_data = var.secret_value
}
