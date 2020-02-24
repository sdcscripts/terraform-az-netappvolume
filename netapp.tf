resource "azurerm_netapp_account" "mynetappaccount" {
  name                = "mynetappaccount"
  location            = "${azurerm_resource_group.netappstorage.location}"
  resource_group_name = "${azurerm_resource_group.netappstorage.name}"
}

resource "azurerm_netapp_pool" "mynetapppool" {
  name                = "mynetapppool"
  account_name        = "${azurerm_netapp_account.mynetappaccount.name}"
  location            = "${azurerm_resource_group.netappstorage.location}"
  resource_group_name = "${azurerm_resource_group.netappstorage.name}"
  service_level       = "${var.netappservicelevel}"
  size_in_tb          = "${var.netapppoolsize_in_tb}"
}

resource "azurerm_netapp_volume" "mynetappvolume" {
  name                = "mynetappvolume"
  location            = "${azurerm_resource_group.netappstorage.location}"
  resource_group_name = "${azurerm_resource_group.netappstorage.name}"
  account_name        = "${azurerm_netapp_account.mynetappaccount.name}"
  pool_name           = "${azurerm_netapp_pool.mynetapppool.name}"
  volume_path         = "${var.netappmountname}"
  service_level       = "${var.netappservicelevel}"
  subnet_id           = "${azurerm_subnet.netappsubnet.id}"
  storage_quota_in_gb = "${var.netappvolumequota_in_gb}"

  export_policy_rule   {
    rule_index      = 1
    allowed_clients = ["${module.linuxvm.vmnicip}"]
    cifs_enabled    = "false"
    nfsv3_enabled   = "true"
    nfsv4_enabled   = "false"
    unix_read_write = "true"
  }
}