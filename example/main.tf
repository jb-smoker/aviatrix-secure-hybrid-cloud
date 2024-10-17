data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

module "avx_hybrid_cloud" {
  source              = "github.com/jb-smoker/aviatrix-secure-hybrid-cloud"
  version             = "1.0.0"
  avx_aws_account     = "aws-account"
  avx_azure_account   = "azure-account"
  password            = var.controller_password
  gcp_project         = var.gcp_project
  gcp_region          = var.gcp_region
  aws_region          = var.aws_region
  azure_region        = var.azure_region
  my_ip               = "${chomp(data.http.myip.response_body)}/32"
  edge_image_filename = "${path.module}/avx-gateway-avx-g3-202405121500.qcow2"
}
