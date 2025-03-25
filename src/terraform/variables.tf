variable "PROJECT_ID" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "REGION" {
  description = "The default Google Cloud region for resources"
  type        = string
  default     = "us-central1"
}

variable "ZONE" {
  description = "The default Google Cloud zone for resources"
  type        = string
  default     = "us-central1-a"
}

variable "VERSION_STORAGE" {
  type    = bool
  default = false
}
variable "STORAGE_CLASS" {
  type    = string
  default = "STANDARD"
}
variable "BUCKET_FUNCTIONS_NAME" {
  type    = string
  default = "functions-code-bucket"
}
variable "TOPICS" {
  description = "List of Pub/Sub topics to create"
  type        = list(string)
}
variable "TOPIC_PREFIX" {
  description = "Prefix to be used in resource names"
  type        = string
}
variable "API_KEY" {
  type      = string
  sensitive = true
}

variable "CRON_EXPRESSION" {
  type    = string
  default = "0 */12 * * *"
}
