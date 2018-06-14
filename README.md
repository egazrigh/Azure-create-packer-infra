# Azure-create-packer-infra

This is a simple Terraform code to deploy a Packer infra on Azure

Need to add a provider.tf file to configure theses variables or add it trough ENV variables

provider "azurerm" {
  subscription_id = "
  client_id       = "
  client_secret   = ""
  tenant_id       = ""
}
