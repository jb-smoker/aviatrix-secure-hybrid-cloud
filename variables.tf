variable "avx_aws_account" {
  type        = string
  description = "AWS Transit Account"
}

variable "avx_azure_account" {
  type        = string
  description = "Azure Transit Account"
}

variable "password" {
  type        = string
  description = "Password used for Azure instances"
}

variable "gcp_project" {
  type        = string
  description = "GCP Project"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "azure_region" {
  type        = string
  description = "Azure Region"
}

variable "gcp_region" {
  type        = string
  description = "GCP Region"
}

variable "instance_sizes" {
  type        = map(string)
  description = "Instance Sizes for each cloud provider"
  default = {
    aws   = "t3.micro"
    gcp   = "n1-standard-1"
    azure = "Standard_B1ms"
    edge  = "n1-standard-2"
  }
}

variable "gatus_private_ips" {
  type        = map(string)
  description = "Private ips for the gatus instances"
  default = {
    aws   = "10.1.2.40"
    edge  = "10.40.251.29"
    azure = "10.2.2.40"

  }
}

variable "edge_instance_name" {
  type        = string
  description = "Name of the Edge Instance"
  default     = "edge-instance"
}

variable "aws_instance_name" {
  type        = string
  description = "Name of the AWS Instance"
  default     = "aws-instance"
}

variable "azure_instance_name" {
  type        = string
  description = "Name of the Azure Instance"
  default     = "azure-instance"
}

variable "gatus_interval" {
  type        = string
  description = "Interval for Gatus (in seconds)"
  default     = "5"
}

variable "inbound_tcp" {
  type        = map(list(string))
  description = "Inbound TCP Ports"
  default = {
    80 = ["0.0.0.0/0"]
  }
}

variable "quagga_asn" {
  type        = number
  description = "Quagga ASN"
  default     = 65516
}

variable "my_ip" {
  type        = string
  description = "Source IP for the deploying user"
}

variable "edge_image_filename" {
  type        = string
  description = "Full file path to the edge qcow"
}
