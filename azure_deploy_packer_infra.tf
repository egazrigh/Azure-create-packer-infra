# Resource group contenant les artefacts necessaires pour le build d'une image par Packer
resource "azurerm_resource_group" "RG-Packer-Build" {
  name     = "Packer-artefacts"
  location = "${var.Azureregion}"
  tags     = "${local.common_tags}"
}

# Resource group ou seront créee les images buildees par Packer
resource "azurerm_resource_group" "RG-Packer-Images" {
  name     = "Packer-Builded-Images"
  location = "${var.Azureregion}"
  tags     = "${local.common_tags}"
}

resource "azurerm_virtual_network" "VNet-Packer" {
  name                = "VNet-Packer"
  resource_group_name = "${azurerm_resource_group.RG-Packer-Build.name}"
  address_space       = ["10.0.0.0/8"]
  location            = "${var.Azureregion}"
  dns_servers         = ["8.8.8.8", "10.0.0.5"]
  tags                = "${local.common_tags}"
}

resource "azurerm_network_security_group" "NSG-Packer" {
  name                = "NSG-Packer"
  location            = "${var.Azureregion}"
  resource_group_name = "${azurerm_resource_group.RG-Packer-Build.name}"
  tags                = "${local.common_tags}"
}

resource "azurerm_network_security_rule" "allow-ssh" {
  resource_group_name         = "${azurerm_resource_group.RG-Packer-Build.name}"
  network_security_group_name = "${azurerm_network_security_group.NSG-Packer.name}"
  name                        = "Allow-SSH-entrant"
  priority                    = 1200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "allow-rdp" {
  resource_group_name         = "${azurerm_resource_group.RG-Packer-Build.name}"
  network_security_group_name = "${azurerm_network_security_group.NSG-Packer.name}"
  name                        = "Allow-RDP-entrant"
  priority                    = 1300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "allow-http" {
  resource_group_name         = "${azurerm_resource_group.RG-Packer-Build.name}"
  network_security_group_name = "${azurerm_network_security_group.NSG-Packer.name}"
  name                        = "Allow-HTTP-entrant"
  priority                    = 1400
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_subnet" "Subnet-Packer" {
  name                      = "Subnet-Packer"
  resource_group_name       = "${azurerm_resource_group.RG-Packer-Build.name}"
  virtual_network_name      = "${azurerm_virtual_network.VNet-Packer.name}"
  address_prefix            = "10.0.0.0/16"
  network_security_group_id = "${azurerm_network_security_group.NSG-Packer.id}"
}

resource "azurerm_public_ip" "PublicIp-Packer" {
  name                         = "PublicIp-Packer"
  location                     = "${var.Azureregion}"
  resource_group_name          = "${azurerm_resource_group.RG-Packer-Build.name}"
  public_ip_address_allocation = "static"
  domain_name_label            = "${var.packer-vm-fqdn}"
  tags                         = "${local.common_tags}"
}

resource "azurerm_network_interface" "NIC-Packer" {
  name                = "NIC-Packer"
  location            = "${var.Azureregion}"
  resource_group_name = "${azurerm_resource_group.RG-Packer-Build.name}"
  tags                = "${local.common_tags}"

  ip_configuration {
    name                          = "configIPNIC-Packer"
    subnet_id                     = "${azurerm_subnet.Subnet-Packer.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.PublicIp-Packer.id}"
  }
}

# --------------------
# - Output
# --------------------

output "Packer VM public IP" {
  value = "${azurerm_public_ip.PublicIp-Packer.ip_address}"
}

output "Packer VM FQDN     " {
  value = "${azurerm_public_ip.PublicIp-Packer.fqdn}"
}

output "Packer VM NIC Id   " {
  value = "${azurerm_network_interface.NIC-Packer.id}"
}
