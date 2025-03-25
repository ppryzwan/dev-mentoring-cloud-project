variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "The default Google Cloud region for resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The default Google Cloud zone for resources"
  type        = string
  default     = "us-central1-a"
}

variable "version_storage" {
  type    = bool
  default = false
}
variable "storage_class" {
  type    = string
  default = "STANDARD"
}

variable "bucket_functions_name" {
  type    = string
  default = "functions-code-bucket"
}
