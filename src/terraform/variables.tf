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

variable "AIR_POLLUTION_API_KEY" {
  type    = string
  default = "value"
}
