terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "prefix" {
  type        = string
  description = "Base name used to create Azure resources."
  default     = "azure"
}

variable "location" {
  type        = string
  description = "Azure region."
  default     = "eastus"
}

locals {
  resource_group_name = "rg-${var.prefix}-app"
  acr_name            = replace(lower("${var.prefix}appacr"), "/[^a-z0-9]/", "")
  env_name            = "aca-${var.prefix}-env"
  law_name            = "law-${var.prefix}-app"
}

resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = var.location
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = local.law_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  daily_quota_gb      = 0.5
}

resource "azurerm_container_registry" "this" {
  name                = local.acr_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_container_app_environment" "this" {
  name                       = local.env_name
  location                   = azurerm_resource_group.this.location
  resource_group_name        = azurerm_resource_group.this.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
}

output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "container_registry_login_server" {
  value = azurerm_container_registry.this.login_server
}
