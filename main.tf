terraform {
  required_version = "~> 0.12.0"
}

provider "azurerm" {
  version = "~> 1.42.0"
}

resource "azurerm_resource_group" "netappcompute" {
   name = "${var.computerg}"
   location = "${var.computerglocation}"
}

resource "azurerm_resource_group" "netappnetwork" {
   name = "${var.networkrg}"
   location = "${var.networkrglocation}"
}
resource "azurerm_resource_group" "netappstorage" {
   name = "${var.storagerg}"
   location = "${var.storagerglocation}"
}

 module "linuxvm" {
  source        = "./modules/linuxvm"
  rgname        = "${azurerm_resource_group.netappcompute.name}"
  location      = "${azurerm_resource_group.netappcompute.location}"
  subnetid      = "${module.network.vnet_subnets[0]}"
  vmname        = "${var.vm_hostname}"
  vmpassword    = "${var.vm_admin_pwd}"
  adminusername = "${var.vm_admin_user}"
  vmsize        = "${var.vm_size}"
   }

/*
module "linuxvm2" {
  source   = "./modules/linuxvm"
  rgname   = "${azurerm_resource_group.netappcompute.name}"
  location = "${azurerm_resource_group.netappcompute.location}"
  subnetid = "${module.vNet.subnet1id}"
  vmname   = "mylinuxvm2"
} */