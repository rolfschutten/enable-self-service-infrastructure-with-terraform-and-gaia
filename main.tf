resource "azurerm_resource_group" "gaia-app" {
  name     = "rg-${var.ServiceName}-${var.EnvironmentPrefix}-001"
  location = "${var.Location}"
}

resource "azurerm_container_registry" "gaia-app" {
  name                = "cr${var.ServiceNameAlphanumeric}${var.EnvironmentPrefix}001"
  resource_group_name = azurerm_resource_group.gaia-app.name
  location            = azurerm_resource_group.gaia-app.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_kubernetes_cluster" "gaia-app" {
  name                = "aks-${var.ServiceName}-${var.EnvironmentPrefix}-001"
  location            = azurerm_resource_group.gaia-app.location
  resource_group_name = azurerm_resource_group.gaia-app.name
  dns_prefix          = "gaiacluster"

  default_node_pool {
    name       = "default"
    node_count = "2"
    vm_size    = "standard_d2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "gaia-app" {
  principal_id                     = azurerm_kubernetes_cluster.gaia-app.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.gaia-app.id
  skip_service_principal_aad_check = true
}

data "azurerm_kubernetes_cluster" "gaia" {
  name                = azurerm_kubernetes_cluster.gaia-app.name
  resource_group_name = azurerm_resource_group.gaia-app.name
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.gaia-app.kube_config.0.host
  username               = azurerm_kubernetes_cluster.gaia-app.kube_config.0.username
  password               = azurerm_kubernetes_cluster.gaia-app.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.gaia-app.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.gaia-app.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.gaia-app.kube_config.0.cluster_ca_certificate)
}

resource "kubernetes_namespace" "gaia" {
  metadata {
    name = "gaia"
  }
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.gaia-app.kube_config.0.host
    username               = azurerm_kubernetes_cluster.gaia-app.kube_config.0.username
    password               = azurerm_kubernetes_cluster.gaia-app.kube_config.0.password
    client_certificate     = base64decode(azurerm_kubernetes_cluster.gaia-app.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.gaia-app.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.gaia-app.kube_config.0.cluster_ca_certificate)
  }
}

resource "helm_release" "gaia" {
  name      = "gaia"
  chart     = "https://github.com/gaia-app/chart/archive/refs/tags/v0.1.2.tar.gz"
  namespace = "gaia"
}
