

module "storage" {
  source                = "./modules/storage"
  project_id            = var.project_id
  bucket_functions_name = "${var.project_id}-${var.bucket_functions_name}"
  region                = var.region
  version_storage       = var.version_storage

}


module "pubsub" {
  source       = "./modules/pubsub"
  project_id   = var.project_id
  topic_prefix = var.topic_prefix
  topics       = var.topics
  depends_on   = [module.storage]
}


module "functions" {
  project_id                  = var.project_id
  API_KEY                     = var.API_KEY
  pubsub_topics               = module.pubsub.topic_names
  source                      = "./modules/functions"
  bucket_functions_name       = module.storage.functions_bucket_name
  path_weather_function       = "${path.cwd}/../cloud-functions/weather/"
  path_air_pollution_function = "${path.cwd}/../cloud-functions/air_pollution/"
  path_pubsub_function        = "${path.cwd}/../cloud-functions/pub_sub_subcriber/"
  weather_function_name       = "weather"
  air_pollution_function_name = "air_pollution"
  pubsub_function_name        = "pubsub_function"
  weather_entry_point         = "getWeather"
  air_pollution_entry_point   = "getPolution"
  pubsub_entry_point          = "subscribePubsub"
  polution_topic_name         = "${var.topic_prefix}-air-polution"
  weather_topic_name          = "${var.topic_prefix}-weather"
  runtime                     = "python311"
  region                      = var.region
  depends_on                  = [module.storage, module.pubsub]
}



module "schedule" {
  source          = "./modules/schedules"
  weather_uri     = module.functions.weather_function_uri
  cron_expression = var.cron_expression
  depends_on      = [module.functions]
}
