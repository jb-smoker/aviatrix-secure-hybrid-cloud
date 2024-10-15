module "edge_sv" {
  source              = "terraform-aviatrix-modules/gcp-edge-demo/aviatrix"
  version             = "3.1.7"
  region              = var.gcp_region
  pov_prefix          = "sv-${var.gcp_project}-metro-equinix"
  host_vm_size        = var.instance_sizes["gcp"]
  host_vm_cidr        = "10.40.251.16/28"
  host_vm_asn         = 64900
  host_vm_count       = 1
  edge_vm_asn         = 64581
  edge_lan_cidr       = "10.40.251.0/29"
  edge_image_filename = var.edge_image_filename
  test_vm_internet_ingress_ports = [
    "80"
  ]
  test_vm_metadata_startup_script = templatefile("${path.module}/templates/gatus.tpl", {
    name     = var.edge_instance_name
    cloud    = "Edge"
    interval = var.gatus_interval
    inter    = "10.1.2.40,10.2.2.40"
    password = var.password
  })
  external_cidrs = ["10.0.0.0/8"]
  transit_gateways = [
    module.backbone.transit["aws"].transit_gateway.gw_name,
    module.backbone.transit["azure"].transit_gateway.gw_name,
  ]

  depends_on = [module.backbone]
}
