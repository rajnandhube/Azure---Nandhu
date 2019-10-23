# Configure the Microsoft Azure Provider
provider "azurerm" {
	subscription_id = "${var.subscription_id}"
	client_id       = "${var.client_id}"
	client_secret   = "${var.client_secret}"
	tenant_id       = "${var.tenant_id}"
	}



data "azurerm_resource_group" "test" {
	name = "${var.Existing_RG_name}"
	}

data "azurerm_virtual_network" "test" {
	name                = "${var.Existing_Vnet_name}"
	resource_group_name  = "${var.Existing_VnetRG_name}"
	}

# Create subnet
resource "azurerm_subnet" "VnetModule" {
    name                 = "nansubnet5"
    resource_group_name  =  "${data.azurerm_virtual_network.test.name}"
    virtual_network_name = "Nandhu-Vnet"
    address_prefix       = "${var.subnet_address_prefix}""10.14.0.0/16"
	}