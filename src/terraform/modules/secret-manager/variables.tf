variable "secret_id" {
  type = string

}
variable "label" {
  type = string
}

variable "region" {
  type = string
}

variable "secret_value" {
  sensitive = true
  type      = string

}
