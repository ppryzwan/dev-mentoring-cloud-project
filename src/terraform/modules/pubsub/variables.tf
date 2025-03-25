variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "topic_prefix" {
  description = "Prefix to be used in resource names"
  type        = string
}

variable "topics" {
  description = "List of Pub/Sub topics to create"
  type        = list(string)
}

variable "message_retention_duration" {
  description = "Minimum duration to retain a message after it is published"
  type        = string
  default     = "604800s"
}

variable "ack_deadline_seconds" {
  description = "Maximum time after a subscriber receives a message before it must acknowledge the message"
  type        = number
  default     = 20
}

variable "retain_acked_messages" {
  description = "Whether to retain acknowledged messages"
  type        = bool
  default     = false
}
