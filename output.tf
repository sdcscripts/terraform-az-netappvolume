output "server_public_dns_name" {
  value = "${module.linuxvm.public_ip_dns_name}"
}

output "vm_admin_username"{
    value = "${var.vm_admin_user}"
}

output "vm_admin_password"{
    value = "${var.vm_admin_pwd}"
}