variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created"
  default     = ""
}

variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
  default     = ""
}

variable "vnet_subnet_name" {
  description = "The subnet id of the virtual network where the virtual machines will reside."
  default     = ""
}

variable "vnet_subnet_id" {
  description = "The subnet id of the virtual network where the virtual machines will reside."
  default     = ""
}

variable "admin_password" {
  description = "The admin password to be used on the VMSS that will be deployed. The password must meet the complexity requirements of Azure"
  default     = ""
}

variable "admin_username" {
  description = "The admin username of the VM that will be deployed"
  default     = ""
}

variable "storage_account_type" {
  description = "Defines the type of storage account to be created. Valid options are Standard_LRS, Standard_ZRS, Standard_GRS, Standard_RAGRS, Premium_LRS."
  default     = ""
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = ""
}

variable "nb_instances" {
  description = "Specify the number of vm instances"
  default     = ""
}

variable "vm_hostname" {
  description = "local name of the VM"
  default     = ""
}

variable "is_windows_image" {
  description = "Boolean flag to notify when the custom image is windows based. Only used in conjunction with vm_os_id"
  default     = "false"
}

variable "vm_os_publisher" {
  description = "The name of the publisher of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  default     = "OpenLogic"
}

variable "vm_os_offer" {
  description = "The name of the offer of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  default     = "CentOS"
}

variable "vm_os_sku" {
  description = "The sku of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  default     = "7.5"
}

variable "vm_os_version" {
  description = "The version of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  default     = "latest"
}

variable "tags" {
  type        = "map"
  description = "A map of the tags to use on the resources that are deployed with this module."

  default = {
    source = ""
  }
}

variable "delete_os_disk_on_termination" {
  description = "Delete datadisk when machine is terminated"
  default     = "false"
}

variable "data_sa_type" {
  description = "Data Disk Storage Account type"
  default     = ""
}

variable "data_disk_size_gb" {
  description = "Storage data disk size size"
  default     = ""
}

variable "data_disk" {
  type        = "string"
  description = "Set to true to add a datadisk."
  default     = "false"
}

variable "boot_diagnostics" {
  description = "(Optional) Enable or Disable boot diagnostics"
  default     = "false"
}

variable "boot_diagnostics_sa_type" {
  description = "(Optional) Storage account type for boot diagnostics"
  default     = ""
}

variable "enable_accelerated_networking" {
  type        = "string"
  description = "(Optional) Enable accelerated networking on Network interface"
  default     = "false"
}
