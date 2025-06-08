locals {
  storage_folder_name       = "functions_normal"
  functions_zip_folder_name = "dist_functions"
  functions_zip_file_path   = "${path.cwd}/../${local.functions_zip_folder_name}"
}



module "function-air-pollution" {
  source                  = "./modules/functions-normal"
  project_id              = var.PROJECT_ID
  region                  = var.REGION
  function_name           = "main_air_pollution"
  description             = "Air pollution function"
  available_memory        = "256Mi"
  timeout_seconds         = 180
  entry_point             = "getPolution"
  zip_file_name           = "air_pollution"
  storage_folder_name     = locals.storage_folder_name
  functions_zip_file_path = local.functions_zip_file_path
  environment_variables = {
    PUBSUB_TOPIC = module.pubsub-weather.topic_names["air-polution"]
    PROJECT_ID   = var.PROJECT_ID
    API_KEY      = var.AIR_POLLUTION_API_KEY
  }
  bucket_functions_name = module.storage-functions.bucket_name

  depends_on = [module.storage-functions, module.pubsub-weather, module.storage-data]

}

module "function-weather" {
  source                  = "./modules/functions-normal"
  project_id              = var.PROJECT_ID
  region                  = var.REGION
  function_name           = "main_weather"
  description             = "Weather function"
  available_memory        = "256Mi"
  timeout_seconds         = 180
  entry_point             = "getWeather"
  zip_file_name           = "weather"
  storage_folder_name     = locals.storage_folder_name
  functions_zip_file_path = local.functions_zip_file_path
  environment_variables = {
    PUBSUB_TOPIC = module.pubsub-weather.topic_names["air-polution"]
    PROJECT_ID   = var.PROJECT_ID
    API_KEY      = var.AIR_POLLUTION_API_KEY
  }
  bucket_functions_name = module.storage-functions.bucket_name

  depends_on = [module.storage-functions, module.pubsub-weather, module.storage-data]

}


## To uncomment in testing PR
# module "function-weather-transform" {
#   project_id       = var.PROJECT_ID
#   api_key          = var.API_KEY
#   source           = "./modules/functions-normal"
#   zip_path         = "${path.cwd}/../dist_functions/weather_topic.zip"
#   function_name    = "${local.environment}_weather_transformation"
#   description      = "Weather transformfunction"
#   available_memory = "256Mi"
#   timeout_seconds  = 180
#   entry_point      = "weatherTransform"
#   region           = var.REGION
#   environment_variables = {
#     SUBSCRIPTION_PATH = module.pubsub.subscription_ids["weather"]
#   }
#   bucket_functions_name = module.storage.bucket_name
#   depends_on            = [module.storage, module.pubsub]
# }



# module "function-air-pollution-transform" {
#   project_id       = var.PROJECT_ID
#   api_key          = var.API_KEY
#   source           = "./modules/functions-normal"
#   zip_path         = "${path.cwd}/../dist_functions/air_pollution_topic.zip"
#   function_name    = "${local.environment}_air_pollution_transformation"
#   description      = "Air pollution transform function"
#   available_memory = "256Mi"
#   timeout_seconds  = 180
#   entry_point      = "airPolutionTransform"
#   region           = var.REGION
#   environment_variables = {
#     SUBSCRIPTION_PATH = module.pubsub.subscription_ids["air-polution"]
#   }
#   bucket_functions_name = module.storage.bucket_name
#   depends_on            = [module.storage, module.pubsub]
# }
