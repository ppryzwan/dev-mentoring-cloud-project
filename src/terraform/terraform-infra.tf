

module "storage" {
  source                = "./modules/storage"
  project_id            = var.PROJECT_ID
  bucket_functions_name = "${var.PROJECT_ID}-${var.BUCKET_FUNCTIONS_NAME}"
  region                = var.REGION
  version_storage       = var.VERSION_STORAGE

}


module "pubsub" {
  source       = "./modules/pubsub"
  project_id   = var.PROJECT_ID
  topic_prefix = var.TOPIC_PREFIX
  topics       = var.TOPICS
  depends_on   = [module.storage]
}


module "functions" {
  project_id                  = var.PROJECT_ID
  api_key                     = var.API_KEY
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
  polution_topic_name         = "${var.TOPIC_PREFIX}-air-polution"
  weather_topic_name          = "${var.TOPIC_PREFIX}-weather"
  runtime                     = "python311"
  region                      = var.REGION
  depends_on                  = [module.storage, module.pubsub]
}


module "schedule" {
  source          = "./modules/schedules"
  weather_uri     = module.functions.weather_function_uri
  cron_expression = var.CRON_EXPRESSION
  depends_on      = [module.functions]
}
