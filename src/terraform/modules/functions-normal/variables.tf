variable "environment_variables" {
  description = "Environment variables for the function"
  type        = map(string)
  default     = {}
}

variable "runtime" {
  type    = string
  default = "python311"
}

variable "zip_file_name" {
  type = string
}
variable "functions_zip_file_path" {
  type = string
}

variable "bucket_functions_name" {
  type = string
}

variable "function_name" {
  type = string
}

variable "storage_folder_name" {
  type = string
}

variable "project_id" {
  type = string
}


variable "description" {
  type = string
}

variable "available_memory" {
  type = string
}

variable "timeout_seconds" {
  type = number
}

variable "region" {
  type = string
}

variable "entry_point" {
  type = string
}
