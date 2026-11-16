terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
        }
    }
}

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "linux-rg" {
    name     = "Unix-RG"
    location = "centralindia"
}

resource "azurerm_network_security_group" "linux-nsg" {
    name                = "Linux-NSG"
    resource_group_name = azurerm_resource_group.linux-rg.name
    location            = azurerm_resource_group.linux-rg.location
}

resource "azurerm_virtual_network" "vnet" {
    name                = "Linux-VNet"
    resource_group_name = azurerm_resource_group.linux-rg.name
    location            = azurerm_resource_group.linux-rg.location
    address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "default-subnet" {
    name                 = "default"
    virtual_network_name = azurerm_virtual_network.vnet.name
    resource_group_name  = azurerm_resource_group.linux-rg.name
    address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "nsg-link" {
    subnet_id                 = azurerm_subnet.default-subnet.id
    network_security_group_id = azurerm_network_security_group.linux-nsg.id
}

resource "azurerm_public_ip" "linux-pip" {
    name                = "Linux-PIP"
    resource_group_name = azurerm_resource_group.linux-rg.name
    location            = azurerm_resource_group.linux-rg.location
    allocation_method   = "Static"
}

resource "azurerm_network_interface" "linux-nic" {
    name                = "Linux-NIC"
    resource_group_name = azurerm_resource_group.linux-rg.name
    location            = azurerm_resource_group.linux-rg.location

    ip_configuration {
        name = "Linux-config"
        subnet_id = azurerm_subnet.default-subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.linux-pip.id
    }
}

resource "azurerm_linux_virtual_machine" "vm" {
    name                            = "Linux-VM"
    resource_group_name             = azurerm_resource_group.linux-rg.name
    location                        = azurerm_resource_group.linux-rg.location
    network_interface_ids           = [azurerm_network_interface.linux-nic.id]
    size                            = "Standard_D2ls_v6"

    computer_name                   = "Ubuntu-VM"
    admin_username                  = "admintech"
    admin_password                  = "admin@123456"
    disable_password_authentication = false

    source_image_reference {
        publisher = "Canonical"
        offer     = "ubuntu-24_04-lts"
        sku       = "server"
        version   = "latest"
    }

    os_disk {
        name                 = "linuxdisk01"
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    tags = {
        environment = "staging"
    }
}