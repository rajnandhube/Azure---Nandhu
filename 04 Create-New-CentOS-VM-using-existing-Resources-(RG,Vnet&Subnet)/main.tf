# Configure the Microsoft Azure Provider
provider "azurerm" {
	subscription_id = "${var.subscription_id}"
	client_id       = "${var.client_id}"
	client_secret   = "${var.client_secret}"
	tenant_id       = "${var.tenant_id}"
	}

#Call local value
locals {
	VM_Name = "${var.resource_name}-vm01"
	}
	
locals {
	VM_location = "${var.resource_location}"
	}
	
# Use Existing a resource group
data "azurerm_resource_group" "main" {
	name = "${var.Existing_RG_name}"
	}

# Use Existing Subnet
data "azurerm_subnet" "main" {
	name                 = "${var.Existing_Subnet_name}"
	virtual_network_name = "${var.Existing_Vnet_name}"
	resource_group_name  = "${var.Existing_VnetRG_name}"
}

# Create public IPs
resource "azurerm_public_ip" "main" {
	name 		         = "${local.VM_Name}-PIP"
	location         	 = "${local.VM_location}"
	resource_group_name	 = "${data.azurerm_resource_group.main.name}"
	allocation_method    = "Dynamic"
	}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "main" {
	name                = "${local.VM_Name}-nsg"
    location            = "${local.VM_location}"
    resource_group_name = "${data.azurerm_resource_group.main.name}"
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
		}
	
	security_rule {
        name                       = "RDP"
        priority                   = 1101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
		}
	}

# Create Network Interface
resource "azurerm_network_interface" "main" {
	name           		      = "${local.VM_Name}-nic"
	location      		      = "${local.VM_location}"
	resource_group_name		  = "${data.azurerm_resource_group.main.name}"
	network_security_group_id = "${azurerm_network_security_group.main.id}"

		ip_configuration {
		name                          = "${local.VM_Name}-ipconfig"
		subnet_id                     = "${data.azurerm_subnet.main.id}"
		private_ip_address_allocation = "Dynamic"
		public_ip_address_id          = "${azurerm_public_ip.main.id}"
		}
	}

#Create a Virtual Machine
resource "azurerm_virtual_machine" "main" {
	name                  = "${local.VM_Name}"
	location              = "${local.VM_location}"
	resource_group_name   = "${data.azurerm_resource_group.main.name}"
	network_interface_ids = ["${azurerm_network_interface.main.id}"]
	vm_size               = "Standard_A1_v2"

		storage_image_reference {
		publisher = "OpenLogic"
		offer     = "CentOS"
		sku       = "7.5"
		version   = "latest"
		}

		storage_os_disk {
		name              = "myosdisk${local.VM_Name}"
		caching           = "ReadWrite"
		create_option     = "FromImage"
		managed_disk_type = "Standard_LRS"	
		}

		os_profile {
		computer_name  = "${local.VM_Name}"
		admin_username = "nandhu"
		admin_password = "Marubhoomi@1"
		}

		os_profile_linux_config {
		disable_password_authentication = false
		}
	}

resource "azurerm_managed_disk" "main" {
	name                 = "${local.VM_Name}-datadisk1"
	location             = "${var.resource_location}"
	resource_group_name  = "${data.azurerm_resource_group.main.name}"
	storage_account_type = "Standard_LRS"
	create_option        = "Empty"
	disk_size_gb         = 10
	}

resource "azurerm_virtual_machine_data_disk_attachment" "main" {
	managed_disk_id    = "${azurerm_managed_disk.main.id}"
	virtual_machine_id = "${azurerm_virtual_machine.main.id}"
	lun                = "10"
	caching            = "ReadWrite"
	}