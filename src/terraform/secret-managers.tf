module "secret-API-weather" {
  source       = "./modules/secret-manager"
  secret_id    = "API-weather"
  secret_value = var.AIR_POLLUTION_API_KEY
  region       = var.REGION
  label        = "testing_label"
}
