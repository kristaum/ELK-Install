provider "azurerm" {
  version = ">= 1.1.0"
}

provider "random" {
  version = "~> 1.0"
}

resource "azurerm_resource_group" "vm-rg" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
  tags     = "${var.tags}"
}

resource "random_id" "vm-rdm" {
  keepers = {
    vm_hostname = "${var.vm_hostname}"
  }

  byte_length = 6
}

resource "azurerm_storage_account" "vm-sa" {
  count                    = "${var.boot_diagnostics == "true" ? 1 : 0}"
  name                     = "bootdiag${lower(random_id.vm-rdm.hex)}"
  resource_group_name      = "${azurerm_resource_group.vm-rg.name}"
  location                 = "${var.location}"
  account_tier             = "${element(split("_", var.boot_diagnostics_sa_type),0)}"
  account_replication_type = "${element(split("_", var.boot_diagnostics_sa_type),1)}"
  tags                     = "${var.tags}"
}

resource "azurerm_virtual_machine" "vm-linux-with-datadisk" {
  name                          = "${var.vm_hostname}"
  location                      = "${var.location}"
  resource_group_name           = "${azurerm_resource_group.vm-rg.name}"
  vm_size                       = "${var.vm_size}"
  network_interface_ids         = ["${azurerm_network_interface.vm-nic.id}"]
  delete_os_disk_on_termination = "${var.delete_os_disk_on_termination}"

  storage_image_reference {
    publisher = "${var.vm_os_publisher}"
    offer     = "${var.vm_os_offer}"
    sku       = "${var.vm_os_sku}"
    version   = "${var.vm_os_version}"
  }

  storage_os_disk {
    name              = "osdisk-${var.vm_hostname}-${count.index}"
    create_option     = "FromImage"
    caching           = "ReadWrite"
    managed_disk_type = "${var.storage_account_type}"
  }

  storage_data_disk {
    name              = "datadisk-${var.vm_hostname}-${count.index}"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "${var.data_disk_size_gb}"
    managed_disk_type = "${var.data_sa_type}"
  }

  os_profile {
    computer_name  = "${var.vm_hostname}${count.index}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = "${var.tags}"

  boot_diagnostics {
    enabled     = "${var.boot_diagnostics}"
    storage_uri = "${var.boot_diagnostics == "true" ? join(",", azurerm_storage_account.vm-sa.*.primary_blob_endpoint) : "" }"
  }
}

resource "azurerm_public_ip" "vm-pubip" {
  count = 0
}

resource "azurerm_network_interface" "vm-nic" {
  count                         = "${var.nb_instances}"
  name                          = "nic-${var.vm_hostname}-${count.index}"
  location                      = "${azurerm_resource_group.vm-rg.location}"
  resource_group_name           = "${azurerm_resource_group.vm-rg.name}"

  ip_configuration {
    name                          = "ipconfig${count.index}"
    subnet_id                     = "${var.vnet_subnet_id}"
    private_ip_address_allocation = "Dynamic"
  }

  tags = "${var.tags}"
}
