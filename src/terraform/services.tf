resource "google_project_service" "cloudresourcemanager" {
  project = var.PROJECT_ID
  service = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = true
}

# Then enable other APIs with dependencies
resource "google_project_service" "storage" {
  project = var.PROJECT_ID
  service = "storage.googleapis.com"
  disable_on_destroy = true
  
  depends_on = [google_project_service.cloudresourcemanager]
}

resource "google_project_service" "secretmanager" {
  project = var.PROJECT_ID
  service = "secretmanager.googleapis.com"
  disable_on_destroy = true
  
  depends_on = [google_project_service.cloudresourcemanager]
}

resource "google_project_service" "cloudfunctions" {
  project = var.PROJECT_ID
  service = "cloudfunctions.googleapis.com"
  disable_on_destroy = true
  
  depends_on = [google_project_service.cloudresourcemanager]
}

resource "google_project_service" "cloudbuild" {
  project = var.PROJECT_ID
  service = "cloudbuild.googleapis.com"
  disable_on_destroy = true
  
  depends_on = [google_project_service.cloudresourcemanager]
}

resource "google_project_service" "cloudrun" {
  project = var.PROJECT_ID
  service = "run.googleapis.com"
  disable_on_destroy = true
  
  depends_on = [google_project_service.cloudresourcemanager]
}