terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_subnet" "test" {
  name                 = "subnet3"
  resource_group_name  = "Academy"
  virtual_network_name = "academy-vnet"
  address_prefixes     = ["10.1.3.0/24"]

}

resource "azurerm_network_interface" "test-ani" {
  name                = "azurik-ni"
  location            = "West Europe"
  resource_group_name = "Academy"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "/subscriptions/b63121dc-16e7-4b98-93e2-a7f9c6c8bd90/resourceGroups/Academy/providers/Microsoft.Network/virtualNetworks/academy-vnet/subnets/subnet3"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "test-vm" {
    name                  = "myVM-test"
    location              = "West Europe"
    resource_group_name   = "Academy"
    network_interface_ids = ["${azurerm_network_interface.test-ani.id}"]
    vm_size               = "Standard_B1s"
    delete_os_disk_on_termination = true
    delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
   storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
   os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
   os_profile_linux_config {
    disable_password_authentication = false
  }

}