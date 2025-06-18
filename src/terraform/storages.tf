module "storage-functions" {
  source                = "./modules/storage"
  project_id            = var.PROJECT_ID
  bucket_functions_name = "${var.PROJECT_ID}-main-functions-code-bucket"
  region                = var.REGION
  version_storage       = false
  storage_class         = "STANDARD"
  depends_on            = [google_project_service.storage, google_project_service.cloudresourcemanager]
}

module "storage-data" {
  source                = "./modules/storage"
  project_id            = var.PROJECT_ID
  bucket_functions_name = "${var.PROJECT_ID}-main-data"
  region                = var.REGION
  version_storage       = false
  storage_class         = "STANDARD"
  depends_on            = [google_project_service.storage]
}
