resource "azurerm_public_ip" "this" {
  count               = 1
  name                = "${var.azure_instance_name}-pub-ip"
  location            = module.vnet_germany_west_central.vnet_location
  resource_group_name = azurerm_resource_group.vnet_germany_west_central.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "this" {
  name                = var.azure_instance_name
  location            = module.vnet_germany_west_central.vnet_location
  resource_group_name = azurerm_resource_group.vnet_germany_west_central.name
  ip_configuration {
    name                          = var.azure_instance_name
    subnet_id                     = lookup(module.vnet_germany_west_central.vnet_subnets_name_id, "public-subnet1")
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.2.2.40"
    public_ip_address_id          = azurerm_public_ip.this[0].id
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  name                            = var.azure_instance_name
  location                        = module.vnet_germany_west_central.vnet_location
  resource_group_name             = azurerm_resource_group.vnet_germany_west_central.name
  network_interface_ids           = [azurerm_network_interface.this.id]
  admin_username                  = "ubuntu"
  admin_password                  = var.password
  computer_name                   = var.azure_instance_name
  size                            = var.instance_sizes["azure"]
  source_image_id                 = null
  disable_password_authentication = false

  custom_data = base64encode(templatefile("${path.module}/templates/gatus.tpl",
    {
      name     = var.azure_instance_name
      cloud    = "Azure"
      interval = var.gatus_interval
      inter    = "10.1.2.40,10.40.251.29"
      password = var.password
  }))

  dynamic "source_image_reference" {
    for_each = ["ubuntu"]

    content {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts-gen2"
      version   = "latest"
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_network_security_group" "this" {
  name                = var.azure_instance_name
  resource_group_name = azurerm_resource_group.vnet_germany_west_central.name
  location            = module.vnet_germany_west_central.vnet_location
}

resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_network_security_rule" "this_rfc_1918" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "rfc-1918"
  priority                    = 100
  protocol                    = "*"
  source_port_range           = "*"
  source_address_prefixes     = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  destination_port_range      = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vnet_germany_west_central.name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "this_inbound_tcp" {
  for_each                    = var.inbound_tcp
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "inbound_tcp_${each.key}"
  priority                    = (index(keys(var.inbound_tcp), each.key) + 101)
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefixes     = each.value
  destination_port_range      = each.key
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vnet_germany_west_central.name
  network_security_group_name = azurerm_network_security_group.this.name
}
