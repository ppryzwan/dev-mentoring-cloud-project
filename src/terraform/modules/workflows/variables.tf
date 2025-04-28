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

variable "function_name" {
  type = string
}

variable "description" {
  type = string
}

variable "function_url" {
  type = string
}
variable "cron_expression" {
  type = string
}

variable "address" {
  type = string
}
variable "service_account" {
  type = string
}
