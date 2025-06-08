module "pubsub-weather" {
  source       = "./modules/pubsub"
  project_id   = var.PROJECT_ID
  topic_prefix = "main"
  topics       = ["weather"]
  depends_on   = [module.storage-data]
}

module "pubsub-air-pollution" {
  source       = "./modules/pubsub"
  project_id   = var.PROJECT_ID
  topic_prefix = "main"
  topics       = ["air-polution"]
  depends_on   = [module.storage-data]
}
