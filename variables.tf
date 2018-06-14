variable "Azureregion" {
  description = "The location/region"
}

variable "projectname" {
  description = "Project name (used for resource group & others) only alphanumerical"
}

variable "billing" {
  description = "Billing code"
}

variable "owner" {
  description = "Owner"
}

variable "environment" {
  description = "environment"
}

variable "packer-vm-fqdn" {
  description = "First part of FQDN of the temporary VM created by packer during build. Must be unique and will be followed by .francecentral.cloudapp.azure.com"
}

locals {
  common_tags = {
    environment = "${var.environment}"
    billing     = "${var.billing}"
    project     = "${var.projectname}"
    owner       = "${var.owner}"
  }
}
