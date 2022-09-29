provider "azurerm" {
  tenant_id       = "${var.tenant_id}"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  features {}
}
terraform {
  backend "azurerm" {
    storage_account_name = "tstate15364"
    container_name       = "tstate"
    key                  = "terraform.tstate"
    access_key           = "SSjTtR3pO6m4Xt501FhrTRgxHRNDxueWuTpkHnr90z5r45Iha+QGEZhqDd06eS6rtIHqoD7UTDtM+AStxfhyRA=="
  }
}

data "azurerm_resource_group" "proj3" {
  name = "new-terraform-rg"
}

module "network" {
  source               = "../../modules/network"
  address_space        = "${var.address_space}"
  location             = "${var.location}"
  virtual_network_name = "${var.virtual_network_name}"
  application_type     = "${var.application_type}"
  resource_type        = "NET"
  resource_group       = "${data.azurerm_resource_group.proj3.name}"
  address_prefix_test  = "${var.address_prefix_test}"
}

module "nsg-test" {
  source           = "../../modules/networksecuritygroup"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "NSG"
  resource_group   = "${data.azurerm_resource_group.proj3.name}"
  subnet_id        = "${module.network.subnet_id_test}"
  address_prefix_test = "${var.address_prefix_test}"
}
module "appservice" {
  source           = "../../modules/appservice"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "AppService"
  resource_group   = "${data.azurerm_resource_group.proj3.name}"
}
module "publicip" {
  source           = "../../modules/publicip"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "publicip"
  resource_group   = "${data.azurerm_resource_group.proj3.name}"
}
module "vm" {
  source               = "../../modules/vm"
  location             = "${var.location}"
  resource_group       = data.azurerm_resource_group.proj3.name  
  application_type     = "${var.application_type}"
  resource_type        = "VM"
  subnet_id            = "${module.network.subnet_id_test}"
  public_ip            = "${module.publicip.public_ip_address_id}"
}
