variable "bucket_functions_name" {

  type = string
}

variable "path_weather_function" {
  type = string
}

variable "path_air_pollution_function" {
  type = string
}

variable "path_pubsub_function" {
  type = string
}

variable "weather_function_name" {
  type = string
}

variable "air_pollution_function_name" {
  type = string
}

variable "pubsub_function_name" {
  type = string
}

variable "weather_entry_point" {
  type = string
}

variable "air_pollution_entry_point" {
  type = string
}

variable "pubsub_entry_point" {
  type = string
}

variable "runtime" {
  type    = string
  default = "python311"
}

variable "project_id" {
  type = string
}

variable "api_key" {
  type      = string
  sensitive = true
}

variable "pubsub_topics" {
  type = map(string)
}
variable "weather_topic_name" {
  type = string
}
variable "polution_topic_name" {
  type = string
}

variable "region" {
  type = string

}
