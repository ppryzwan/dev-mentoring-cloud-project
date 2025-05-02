

module "storage" {
  source                = "./modules/storage"
  project_id            = var.PROJECT_ID
  bucket_functions_name = "${var.PROJECT_ID}-${var.BUCKET_FUNCTIONS_NAME}"
  region                = var.REGION
  version_storage       = var.VERSION_STORAGE

}

module "storage-data" {
  source                = "./modules/storage"
  project_id            = var.PROJECT_ID
  bucket_functions_name = "${var.PROJECT_ID}-data"
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


module "function-air-pollution" {
  project_id       = var.PROJECT_ID
  api_key          = var.API_KEY
  source           = "./modules/functions-normal"
  zip_path         = "${path.cwd}/../dist_functions/air_pollution.zip"
  function_name    = "air_pollution"
  description      = "Air pollution function"
  available_memory = "256Mi"
  timeout_seconds  = 180
  entry_point      = "getPolution"
  region           = var.REGION
  environment_variables = {
    PUBSUB_TOPIC = module.pubsub.topic_names["air-polution"]
    PROJECT_ID   = var.PROJECT_ID
    API_KEY      = var.API_KEY
  }
  bucket_functions_name = module.storage.bucket_name
  depends_on            = [module.storage, module.pubsub, module.storage-data]
}

module "function-weather" {
  project_id       = var.PROJECT_ID
  api_key          = var.API_KEY
  source           = "./modules/functions-normal"
  zip_path         = "${path.cwd}/../dist_functions/weather.zip"
  function_name    = "weather"
  description      = "Weather function"
  available_memory = "256Mi"
  timeout_seconds  = 180
  entry_point      = "getWeather"
  region           = var.REGION
  environment_variables = {
    PUBSUB_TOPIC = module.pubsub.topic_names["weather"]
    PROJECT_ID   = var.PROJECT_ID
    API_KEY      = var.API_KEY
  }
  bucket_functions_name = module.storage.bucket_name
  depends_on            = [module.storage, module.pubsub, module.storage-data]
}



module "function-weather-transform" {
  project_id       = var.PROJECT_ID
  api_key          = var.API_KEY
  source           = "./modules/functions-normal"
  zip_path         = "${path.cwd}/../dist_functions/weather_topic.zip"
  function_name    = "weather_transformation"
  description      = "Weather transformfunction"
  available_memory = "256Mi"
  timeout_seconds  = 180
  entry_point      = "weatherTransform"
  region           = var.REGION
  environment_variables = {
    SUBSCRIPTION_PATH = module.pubsub.subscription_ids["weather"]
  }
  bucket_functions_name = module.storage.bucket_name
  depends_on            = [module.storage, module.pubsub]
}



module "function-air-pollution-transform" {
  project_id       = var.PROJECT_ID
  api_key          = var.API_KEY
  source           = "./modules/functions-normal"
  zip_path         = "${path.cwd}/../dist_functions/air_pollution_topic.zip"
  function_name    = "air_pollution_transformation"
  description      = "Air pollution transform function"
  available_memory = "256Mi"
  timeout_seconds  = 180
  entry_point      = "airPolutionTransform"
  region           = var.REGION
  environment_variables = {
    SUBSCRIPTION_PATH = module.pubsub.subscription_ids["air-polution"]
  }
  bucket_functions_name = module.storage.bucket_name
  depends_on            = [module.storage, module.pubsub]
}



module "function-pub-sub" {
  project_id           = var.PROJECT_ID
  source               = "./modules/functions-pub-sub"
  zip_path             = "${path.cwd}/../dist_functions/pubsub_function_subscriber.zip"
  pubsub_function_name = "pubsub_function"
  description          = "Pubsub function"
  available_memory     = "256Mi"
  timeout_seconds      = 180
  entry_point          = "subscribePubsub"
  pubsub_topics        = module.pubsub.topic_names
  region               = var.REGION
  environment_variables = {
    PROJECT_ID  = var.PROJECT_ID
    BUCKET_NAME = module.storage-data.bucket_name
  }
  bucket_functions_name = module.storage.bucket_name
  depends_on            = [module.storage, module.pubsub, module.storage-data]
}


module "workflow-schedule-weather" {
  project_id      = var.PROJECT_ID
  service_account = "owner-sa@turnkey-point-454612-a6.iam.gserviceaccount.com"
  region          = var.REGION
  source          = "./modules/workflows"
  function_url    = module.function-weather.function_uri
  function_name   = "weather-workflow"
  description     = "Weather workflow"
  address         = "Katowice"
  cron_expression = "0 0 * * *"
  depends_on      = [module.function-weather]
}
