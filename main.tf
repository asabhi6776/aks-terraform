resource "azurerm_resource_group" "aks-rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  location            = var.location
  resource_group_name = azurerm_resource_group.aks-rg.name
  dns_prefix          = var.cluster_name

  default_node_pool {
    name                = "system"
    node_count          = var.system_node_count
    vm_size             = "Standard_D11"
    type                = "VirtualMachineScaleSets"
    #availability_zones  = [1, 2, 3]
    enable_auto_scaling = false
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    load_balancer_sku = "Standard"
    network_plugin    = "kubenet" 
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "aksspot" {
  name                  = "spot"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_D11"
  node_count            = 2
  enable_auto_scaling   = false
  priority              = "Spot"
  eviction_policy       = "Delete"
}
resource "azurerm_storage_account" "aks_storage" {
  name                = "aksstorageaccfordemo"
  resource_group_name = azurerm_resource_group.aks-rg.name

  location                 = azurerm_resource_group.aks-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}