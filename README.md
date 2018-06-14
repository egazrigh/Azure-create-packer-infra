# Azure-create-packer-infra

This is a simple Terraform code to deploy a Packer infra on Azure derived from the example provided by https://github.com/squasta/PackerAzureRM

# Pre-requisite
- See https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal
- or https://docs.microsoft.com/en-us/powershell/azure/create-azure-service-principal-azureps?view=azurermps-6.2.0&viewFallbackFrom=azurermps-4.2.0

# Usage
Need to add a provider.tf file to configure theses variables or add it trough ENV variables

```
provider "azurerm" {
  subscription_id = ""
  client_id       = ""
  client_secret   = ""
  tenant_id       = ""
}
```
Then run :
```
terraform plan
```
