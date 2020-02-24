module "network" {
  source              = "Azure/network/azurerm"
  sg_name             = "defaultnsg"
  version             = "~> 1.1.1"
  location            = "${azurerm_resource_group.netappnetwork.location}"
  allow_ssh_traffic   = "true"
  resource_group_name = "${azurerm_resource_group.netappnetwork.name}"
  address_space       = "172.16.0.0/16"
  subnet_prefixes     = "${var.net_sub_cidr}"
  subnet_names        = "${var.net_sub_name}"
  vnet_name           = "${var.vnet_name}"
}

resource "azurerm_subnet" "netappsubnet" {
  name                 = "netappsubnet"
  resource_group_name  = "${azurerm_resource_group.netappnetwork.name}"
  virtual_network_name = "${module.network.vnet_name}"
  address_prefix       = "172.16.10.0/24"
  delegation {
    name = "netapp"

    service_delegation {
      name    = "Microsoft.Netapp/volumes"
      actions = ["Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_network_security_rule" "netapprule1" {
  depends_on                  = ["module.network"] // name of NSG not output by child module so need to add dependancy to stop this running before nsg resource is built
  name                        = "netapprule1"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "2049"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.netappnetwork.name}"
  network_security_group_name = "defaultnsg"
}

resource "azurerm_network_security_rule" "netapprule2" {
  depends_on                  = ["module.network"] // name of NSG not output by child module so need to add dependancy to stop this running before nsg resource is built
  name                        = "netapprule2"
  priority                    = 111
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "111"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.netappnetwork.name}"
  network_security_group_name = "defaultnsg"
}