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
  storage_folder_name     = local.storage_folder_name
  functions_zip_file_path = local.functions_zip_file_path
  environment_variables = {
    PUBSUB_TOPIC = module.pubsub-air-pollution.topic_names["air-polution"]
    PROJECT_ID   = var.PROJECT_ID
    API_KEY      = var.AIR_POLLUTION_API_KEY
  }
  bucket_functions_name = module.storage-functions.bucket_name

  depends_on = [module.storage-functions, module.pubsub-weather, module.storage-data, google_project_service.cloudrun, google_project_service.cloudfunctions, google_project_service.cloudbuild, google_project_service.secretmanager, google_project_service.cloudresourcemanager]

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
  storage_folder_name     = local.storage_folder_name
  functions_zip_file_path = local.functions_zip_file_path
  environment_variables = {
    PUBSUB_TOPIC = module.pubsub-weather.topic_names["weather"]
    PROJECT_ID   = var.PROJECT_ID
    API_KEY      = var.AIR_POLLUTION_API_KEY
  }
  bucket_functions_name = module.storage-functions.bucket_name

  depends_on = [module.storage-functions, module.pubsub-weather, module.storage-data]

}


module "function-weather-transform" {
  source                  = "./modules/functions-normal"
  project_id              = var.PROJECT_ID
  region                  = var.REGION
  function_name           = "main_weather_transformation"
  description             = "Weather Transformation function"
  available_memory        = "256Mi"
  timeout_seconds         = 180
  entry_point             = "weatherTransform"
  zip_file_name           = "weather_topic"
  storage_folder_name     = local.storage_folder_name
  functions_zip_file_path = local.functions_zip_file_path
  environment_variables = {
    PUBSUB_TOPIC = module.pubsub-weather.topic_names["weather"]
    PROJECT_ID   = var.PROJECT_ID
    API_KEY      = var.AIR_POLLUTION_API_KEY
  }
  bucket_functions_name = module.storage-functions.bucket_name

  depends_on = [module.storage-functions, module.pubsub-weather, module.storage-data]

}


module "function-air-pollution-transform" {
  source                  = "./modules/functions-normal"
  project_id              = var.PROJECT_ID
  region                  = var.REGION
  function_name           = "main_air_pollution_transformation"
  description             = "Air pollution Transformation function"
  available_memory        = "256Mi"
  timeout_seconds         = 180
  entry_point             = "airPolutionTransform"
  zip_file_name           = "air_pollution_topic"
  storage_folder_name     = local.storage_folder_name
  functions_zip_file_path = local.functions_zip_file_path
  environment_variables = {
    PUBSUB_TOPIC = module.pubsub-air-pollution.topic_names["air-polution"]
    PROJECT_ID   = var.PROJECT_ID
    API_KEY      = var.AIR_POLLUTION_API_KEY
  }
  bucket_functions_name = module.storage-functions.bucket_name

  depends_on = [module.storage-functions, module.pubsub-air-pollution, module.storage-data]
}
