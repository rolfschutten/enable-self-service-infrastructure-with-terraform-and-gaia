terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.49.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.19.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.9.0"
    }
  }
}
provider "azurerm" { 
  features {}
}
provider "kubernetes" {
}
provider "helm" {
}
