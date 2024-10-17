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
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}
