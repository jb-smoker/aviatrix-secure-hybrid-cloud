module "spoke_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "spoke-aws"
  cidr = "10.1.2.0/24"

  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnets = [cidrsubnet("10.1.2.0/24", 4, 0), cidrsubnet("10.1.2.0/24", 4, 1)]
  public_subnets  = [cidrsubnet("10.1.2.0/24", 4, 2), cidrsubnet("10.1.2.0/24", 4, 3)]

  enable_nat_gateway = false
  enable_vpn_gateway = false

}

resource "aws_customer_gateway" "s2c" {
  bgp_asn    = local.backbone["aws"].transit_asn
  ip_address = module.backbone.transit["aws"].transit_gateway.eip
  type       = "ipsec.1"

  tags = {
    Name = "avx-transit-aws"
  }
}

resource "aws_vpn_gateway" "s2c" {
  vpc_id          = module.spoke_vpc.vpc_id
  amazon_side_asn = 65000

  tags = {
    Name = "aws-s2c"
  }
}

resource "aws_vpn_connection" "s2c" {
  vpn_gateway_id        = aws_vpn_gateway.s2c.id
  customer_gateway_id   = aws_customer_gateway.s2c.id
  type                  = "ipsec.1"
  static_routes_only    = false
  tunnel1_inside_cidr   = "169.254.100.0/30"
  tunnel1_preshared_key = "mapleleafs"
}

resource "aws_route" "s2c" {
  route_table_id         = module.spoke_vpc.public_route_table_ids[0]
  destination_cidr_block = "10.0.0.0/8"
  gateway_id             = aws_vpn_gateway.s2c.id
}

resource "aviatrix_transit_external_device_conn" "s2c" {
  vpc_id             = module.backbone.transit["aws"].vpc.vpc_id
  connection_name    = "site-to-cloud-aws"
  gw_name            = module.backbone.transit["aws"].transit_gateway.gw_name
  connection_type    = "bgp"
  bgp_local_as_num   = local.backbone["aws"].transit_asn
  bgp_remote_as_num  = 65000
  remote_gateway_ip  = aws_vpn_connection.s2c.tunnel1_address
  pre_shared_key     = "mapleleafs"
  local_tunnel_cidr  = "169.254.100.2/30,169.254.101.9/30"
  remote_tunnel_cidr = "169.254.100.1/30,169.254.101.10/30"
}

resource "aws_security_group" "this" {
  name        = "${var.aws_instance_name}-sg"
  description = "Instance security group"
  vpc_id      = module.spoke_vpc.vpc_id
}

resource "aws_security_group_rule" "this_rfc1918" {
  type              = "ingress"
  description       = "Allow all inbound from rfc1918"
  from_port         = -1
  to_port           = -1
  protocol          = -1
  cidr_blocks       = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "this_inbound_tcp" {
  for_each          = var.inbound_tcp
  type              = "ingress"
  description       = "Allow inbound access from cidrs"
  from_port         = strcontains(each.key, "-") ? split("-", each.key)[0] : each.key
  to_port           = strcontains(each.key, "-") ? split("-", each.key)[1] : each.key
  protocol          = each.key == "0" ? "-1" : "tcp"
  cidr_blocks       = each.value
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "this_egress" {
  type              = "egress"
  description       = "Allow all outbound"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_sizes["aws"]
  ebs_optimized               = false
  source_dest_check           = false
  monitoring                  = true
  subnet_id                   = module.spoke_vpc.public_subnets[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.this.id]
  private_ip                  = "10.1.2.40"

  user_data = templatefile("${path.module}/templates/gatus.tpl",
    {
      name     = var.aws_instance_name
      cloud    = "AWS"
      interval = var.gatus_interval
      inter    = "10.2.2.40,10.40.251.29"
      password = var.password
  })

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }
}
