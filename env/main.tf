terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.80.0"
    }
  }
  backend "azurerm" {
    resource_group_name   = "NextOps"
    storage_account_name   = "nextopstfsa01"
    container_name         = "terraform"
    key                    = "DEV/dev.tfstate"
    access_key             = "SuDLpDTyryllePyyazARUJqAYgyg320ernpjv/3wJglfCK8yrp36LV8L5L7tR8tCmTLC86x3BmuQ+AStJARcRg=="
  }
}


provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "East US"
}

resource "azurerm_service_plan" "example" {
  name                = "nextopsasp11"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  os_type = "Linux"
  sku_name = "S1"
}

resource "azurerm_linux_web_app" "example" {
  name                = "nextopswa11"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  service_plan_id     = azurerm_service_plan.example.id
  site_config {
  }

  app_settings = {
    "WEBSITE_JAVA_CONTAINER"    = "TOMCAT"
    "WEBSITE_JAVA_CONTAINER_VERSION" = "8.5"
  }
}

resource "azurerm_mysql_server" "example" {
  name                = "nextopsmysql11"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku_name            = "GP_Gen5_2"
  version = "5.7"
  ssl_enforcement_enabled = true
  administrator_login          = "petclinic"
  administrator_login_password = "Admin@12345678"
}

resource "azurerm_mysql_database" "example" {
  name                = "petclinic"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_mysql_server.example.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
  
}

