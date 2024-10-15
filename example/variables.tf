variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "azure_region" {
  type        = string
  description = "Azure Region"
  default     = "Central US"
}

variable "gcp_region" {
  type        = string
  description = "GCP Region"
  default     = "us-west2"
}

# Required variables
variable "controller_password" {
  type        = string
  description = "Password for the Aviatrix Controller"
}

variable "controller_username" {
  type        = string
  description = "Username for the Aviatrix Controller"
}

variable "controller_address" {
  type        = string
  description = "URL or IP of the Aviatrix Controller"
}

variable "azure_subscription_id" {
  type        = string
  description = "Azure Subscription Id"
}

variable "azure_application_id" {
  type        = string
  description = "Azure Application Id"
}

variable "azure_application_key" {
  type        = string
  description = "Azure Application Key"
}

variable "azure_directory_id" {
  type        = string
  description = "Azure Directory Id"
}

variable "gcp_project" {
  type        = string
  description = "GCP Project"
}

variable "gcp_credentials_path" {
  type        = string
  description = "GCP Credentials Path"
}
