#main.tf
# Configure the Microsoft Azure Provider
provider "azurerm" {
	subscription_id = "${var.subscription_id}"
	client_id       = "${var.client_id}"
	client_secret   = "${var.client_secret}"
	tenant_id       = "${var.tenant_id}"
	}

# Create a Resouce Group
resource "azurerm_resource_group" "VnetModule" {
    name     = "${var.PreferredName}-RG"
    location = "${var.location}"
    tags     = "${var.tag}"
	}

# Create virtual network
resource "azurerm_virtual_network" "VnetModule" {
    name                = "${var.PreferredName}-Vnet"
    address_space       = "${var.vnetaddressspace}"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.VnetModule.name}"
    tags                = "${var.tag}"
	}

# Create subnet
resource "azurerm_subnet" "VnetModule" {
    name                 = "${azurerm_virtual_network.VnetModule.name}-Subnet01"
    resource_group_name  = "${azurerm_resource_group.VnetModule.name}"
    virtual_network_name = "${azurerm_virtual_network.VnetModule.name}"
    address_prefix       =  "${var.subnetaddressprefix}"
	}