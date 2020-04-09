Azure Netapp Files (ANF) Simple Deployment
=============================================

This code will quickly (usually within 5-6 mins) build a simple deployment of a Linux (RHEL 7.7) VM instance into a vnet with a netapp account, pool and volume injected into the vnet for use. 

Three resource groups are deployed, one for the compute resources, another for the networking components (including subnet delegation for the netapp resource type) and a third for the netapp resources.

## Requirements

* terraform core 0.12.n
* tested with terraform AzureRM provider `1.42.0`
* an authenticated connection to an azure subscription (or add service principal info to the azurerm provider block)
* you will need to add the subscription to be whitelisted before you are able to use ANF. (follow https://docs.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-register)


> Deploying this module will incur cost in your subscription!


The key points and features are:

- **Easy Run**: There is a `terraform.tfvars.example` file which you should rename to `terraform.tfvars` and you will then need to set the password for the vmadmin account. All other variable entries can be used or you can optionally set them to new values if you wish. Afterwards, simply run Terraform init, Terraform apply and it will deploy all resources into East US.  

- **Network Security Group Rules**: This deployment will automatically attach an NSG rule to the VM that is created which means port 22 (SSH) will be open publicly. Be aware of this, you may wish to disallow this and set up alternative methods to remote to the VM such as Azure Bastion, VPN or Expressroute.

- **Mounting NFS volume**: Once terraform apply has finished you will be able to log in , download the NFS tools and mount the NFS volume. See the Mount Instructions from the Netapp resource in the portal for more information. (https://docs.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-mount-unmount-volumes-for-virtual-machines)

Terraform Getting Started & Documentation
-----------------------------------------

If you're new to Terraform and want to get started creating infrastructure, please checkout our [Getting Started](https://www.terraform.io/intro/getting-started/install.html) guide, available on the [Terraform website](http://www.terraform.io).

All documentation is available on the [Terraform website](http://www.terraform.io):

  - [Intro](https://www.terraform.io/intro/index.html)
  - [Docs](https://www.terraform.io/docs/index.html)