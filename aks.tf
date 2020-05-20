# Resource group to hold Azure resources
resource "azurerm_resource_group" "rg" {
  name     = "sgu-aks-rg"
  location = "eastus"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "sgu-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    type       = "VirtualMachineScaleSets"

  }

  service_principal {
    client_id     = "98ad0741-5979-4b65-8368-ec11c9256c88"
    client_secret = ""
  }

  identity {
    type = "SystemAssigned"
  }
}


/*
resource "azurerm_kubernetes_cluster" "k8s" {
  name               = "${var.aks_name}-cluster"
  location           = var.location
  dns_prefix         = var.env
  kubernetes_version = var.aks_kubernetes_version
  resource_group_name = azurerm_resource_group.aks_rg.name
  api_server_authorized_ip_ranges = var.api_auth_ips
  linux_profile {
    admin_username = var.vm_user_name

    ssh_key {
      key_data = tls_private_key.ssh_key.public_key_openssh
    }
  }
 
  linux_profile {
    admin_username = var.vm_user_name

    ssh_key {
      key_data = tls_private_key.ssh_key.public_key_openssh
    }
  }

  addon_profile {
    http_application_routing {
      enabled = false
    }
  }

  default_node_pool {
    name                = substr(var.default_node_pool.name, 0, 12)
    node_count          = var.default_node_pool.node_count
    vm_size             = var.default_node_pool.vm_size
    type                = "VirtualMachineScaleSets"
    max_pods            = 110
    os_disk_size_gb     = 128
    vnet_subnet_id      = azurerm_subnet.k8subnet.id
    enable_auto_scaling = var.default_node_pool.cluster_auto_scaling
    min_count           = var.default_node_pool.cluster_auto_scaling_min_count
    max_count           = var.default_node_pool.cluster_auto_scaling_max_count
  }

  service_principal {
    client_id     = azuread_service_principal.spn.application_id
    client_secret = azuread_service_principal_password.spn.value
  }

  network_profile {
    load_balancer_sku  = "standard"
    network_plugin     = "azure"
    network_policy     = "calico"
    dns_service_ip     = "10.0.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    service_cidr       = "10.0.0.0/16"
  }

  tags = {
    Environment = var.env
  }
}
*/