#Variables File

#Service Prinicipal Values
	variable "subscription_id" {}
	variable "client_id" {}
	variable "client_secret" {}
	variable "tenant_id" {}
	
	variable "location" {}
	variable "PreferredName" {}
	variable "vnetaddressspace" {}
	variable "subnetaddressprefix" {}

variable "tag" {
    type = "map"
    default = {
        Dept = "IT"
		Environment = "Prod"
		}
	}