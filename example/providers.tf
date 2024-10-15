provider "aviatrix" {
  username                = var.controller_username
  password                = var.controller_password
  controller_ip           = var.controller_address
  skip_version_validation = true
}

provider "aws" {
  region = var.aws_region
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  subscription_id            = var.azure_subscription_id
  client_id                  = var.azure_application_id
  client_secret              = var.azure_application_key
  tenant_id                  = var.azure_directory_id
}

provider "google" {
  credentials = var.gcp_credentials_path
  project     = var.gcp_project
  region      = var.gcp_region
}
