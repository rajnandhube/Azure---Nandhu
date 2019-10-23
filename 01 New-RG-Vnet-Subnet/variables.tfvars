#variables.tfvars
#terraform apply -auto-approve -var-file="variables.tfvars" 

#Service Prinicipal Values
	subscription_id = "4f33a353-ca4b-4ab6-a7cd-8692d47f2a56"
	client_id       = "987e4f8b-d253-4adb-a8a4-82205fd3903d"
	client_secret   = "rEUH:bvCXcm7fKnsccAZtwd8oph/.1-3"
	tenant_id       = "0efb4830-3657-4baa-a91e-d081f07b6e29"
	
	location ="East US"
	PreferredName = "Ansible"
	vnetaddressspace = ["10.0.0.0/8"]
	subnetaddressprefix = "10.0.0.0/16"

