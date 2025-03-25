terraform {
  backend "gcs" {
    bucket = "devs-mentoring-project-infrastructure"
    prefix = "terraform/state"
  }
}
