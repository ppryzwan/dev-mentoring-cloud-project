module "storage-functions" {
  source                = "./modules/storage"
  project_id            = var.PROJECT_ID
  bucket_functions_name = "${var.PROJECT_ID}-main-functions-code-bucket"
  region                = var.REGION
  version_storage       = false
  storage_class         = "STANDARD"

}

module "storage-data" {
  source                = "./modules/storage"
  project_id            = var.PROJECT_ID
  bucket_functions_name = "${var.PROJECT_ID}-main-data"
  region                = var.REGION
  version_storage       = false
  storage_class         = "STANDARD"
}
