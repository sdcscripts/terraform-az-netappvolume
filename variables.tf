variable "computerg" {
  description = "Resource Group to deploy compute infrastructure"
}

variable "computerglocation" {
  description = "Resource Group location"
}

variable "networkrg" {
  description = "Resource Group to deploy compute infrastructure"
}

variable "networkrglocation" {
  description = "Resource Group location"
}

variable "storagerg" {
  description = "Resource Group to deploy compute infrastructure"
}

variable "storagerglocation" {
  description = "Resource Group location"
}

variable "vm_hostname" {
 type = "string"
 description = "the hostname for the vm to be used to connect to netapp share" 
}
variable "vm_admin_user" {
 type = "string"
 description = "the username to use for the vm admin account"
 }
 
 variable "vm_admin_pwd" {
 type = "string"
 description = "the password to use for the vm admin account - should meet complexity requirements"
 }
 variable "vm_size" {
 type = "string"
 description = "the vm size to use during vm creation"
 }
 variable "net_sub_cidr" {
 type = "list"
 description = "a comma seperated list of subnets cidr values. two required minimum"
 }

variable "vnet_name" {
 type = "string"
 description = "the name of the vnet"
 }
 variable "net_sub_name" {
 type = "list"
 description = "a comma seperated list of subnet names. two required minimum and same number as there are net_sub_cidr entries"
 }

variable "netappmountname" {
  description = "path of netapp share to use for mount operation"
}
variable "netappservicelevel" {
  description = "Service level to use for the netapp pool and volume"
}

variable "netappvolumequota_in_gb" {
  description = "The quota to set on the netapp volume in GB"
}

variable "netapppoolsize_in_tb" {
  description = "The netapp pool size in TB"
}
