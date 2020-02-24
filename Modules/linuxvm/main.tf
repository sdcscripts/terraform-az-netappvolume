# Create public IP
resource "azurerm_public_ip" "myterraformpublicip" {
    name                         = "${var.vmname}-mypublicip"
    location                     = "${var.location}"
    resource_group_name          = "${var.rgname}"
    allocation_method            = "Dynamic"
    domain_name_label            = "${var.vmname}-${random_id.randomIdVM.hex}"

    tags = {
        environment = "Terraform Demo"
    }
}

# Create network interface
resource "azurerm_network_interface" "myterraformnic" {
    name                      = "${var.vmname}-mynic-${random_id.randomIdVM.hex}"
    location                  = "${var.location}"
    resource_group_name       = "${var.rgname}"

    ip_configuration {
        name                          = "mynicconfiguration"
        subnet_id                     = "${var.subnetid}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.myterraformpublicip.id}"
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# Generate random text for a unique storage account name and DNS label
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "${var.rgname}"
    }
    byte_length = 8
}
resource "random_id" "randomIdVM" {
    
        byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = "${var.rgname}"
    location                    = "${var.location}"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "Terraform Demo"
    }
}

# Create virtual machine
resource "azurerm_virtual_machine" "myterraformvm" {
    name                             = "${var.vmname}"
    location                         = "${var.location}"
    resource_group_name              = "${var.rgname}"
    network_interface_ids            = ["${azurerm_network_interface.myterraformnic.id}"]
    vm_size                          = "${var.vmsize}"
    delete_os_disk_on_termination    = true
    delete_data_disks_on_termination = true

    storage_os_disk {
        name              = "${var.vmname}-myOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "RedHat"
        offer     = "RHEL"
        sku       = "7.7"
        version   = "latest"
    }

    os_profile {
        computer_name  = "${var.vmname}"
        admin_username = "${var.adminusername}"
        admin_password = "${var.vmpassword}"
    }

    os_profile_linux_config {
        disable_password_authentication = false

          ssh_keys {
            path     = "/home/${var.adminusername}/.ssh/authorized_keys"
            key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAzifemevf1+b1uvZdIso4e2JFt6d7XCuWEMVcswHfJOEA8mlCRHy5S4tuaoC8OMUXk3PgugG8qc3RLl0LATCfDP2Qioaok6T06kEF8tnmUUewW18MGQq03Y46GjaqgGndqBaL99N5fSHWyqRHu38LWprO3bd2j9PdZYlCOrIxTAScC0C5enqD6QF9NUHp11ZEwoFVhX5ih38TAC45GFHM0B8FYRYuQx7EblRisRiNoCQQeVdRT+0Z8I7+w7+gr4iVx38GRSpiu9J7x5xjj4RAV4z8RnljztDL6nYbUmfSAMxz5p/j9b3gZ9XKythlAqAJtuKee5pdkqPbAI/mc4hS2w== rsa-key-20191008"
        }
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }

    tags = {
        environment = "Netapp Demo"
    }
}

# Uncomment for data disk addition
/*
 resource "azurerm_managed_disk" "datadisk" {
  name                 = "${azurerm_virtual_machine.myterraformvm.name}-disk1"
  location             = "${var.location}"
  resource_group_name  = "${var.rgname}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 1
} 

resource "azurerm_virtual_machine_data_disk_attachment" "datadisk" {
  managed_disk_id    = "${azurerm_managed_disk.datadisk.id}"
  virtual_machine_id = "${azurerm_virtual_machine.myterraformvm.id}"
  lun                = "10"
  caching            = "ReadWrite"
} 
*/