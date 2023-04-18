resource "azurerm_resource_group" "ftalk-rg" {
  name     = var.resource_group_name
  location = var.location

}
# Data block to retrieve network interfaces that will added to backend pool/ If created with Terraform then call it from that module
data "azurerm_network_interface" "network_interfaces" {
  for_each = toset(var.nic_names)

  name                = each.value
  resource_group_name = ""
}

data "azurerm_virtual_network" "vnet" {
  name                = "ftalk01-p-noe-01-nort-vnt" # Update here with name of Factory-Talk server's vnet
  resource_group_name = ""
}

data "azurerm_subnet" "subnet" {
  name                 = "ftalk01-snt" # Update the name of the name of the subnet you want to place the LB
  resource_group_name  = ""
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

# Create Load Balancer
resource "azurerm_lb" "ftalk_privat_lb" {
  name                = var.load_balancer_name
  location            = azurerm_resource_group.ftalk-rg.location
  resource_group_name = azurerm_resource_group.ftalk-rg.name
  sku                 = "Standard"
  sku_tier            = "Regional"

  frontend_ip_configuration {
    name                          = var.frontend_ip_name
    private_ip_address            = var.frontend_ip_address
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    zones                         = ["1", "2", "3"]
    private_ip_address_version    = "IPv4"
  }
}

# Create Backend Address Pool
resource "azurerm_lb_backend_address_pool" "ftalk" {
  loadbalancer_id = azurerm_lb.ftalk_privat_lb.id
  name            = var.backend_pool_name
}

# Create Probes
resource "azurerm_lb_probe" "lb_probe" {
  for_each = var.lb_details

  name                = each.value.probename
  loadbalancer_id     = azurerm_lb.ftalk_privat_lb.id
  interval_in_seconds = 5
  number_of_probes    = 2
  port                = each.value.be_port
  protocol            = each.value.proto
}

# Create Loadbalancing Rules
resource "azurerm_lb_rule" "lb_rule" {

  for_each = var.lb_details

  name                           = each.value.name
  loadbalancer_id                = azurerm_lb.ftalk_privat_lb.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ftalk.id]
  frontend_ip_configuration_name = var.frontend_ip_name
  protocol                       = each.value.proto
  frontend_port                  = each.value.fe_port
  backend_port                   = each.value.be_port
  probe_id                       = azurerm_lb_probe.lb_probe[each.key].id
  load_distribution              = lookup(each.value, "load_distribution", null)
}

# Automated Backend Pool Addition > Gem Configuration to add the network interfaces of the VMs to the backend pool.
resource "azurerm_network_interface_backend_address_pool_association" "ftalk" {
  count                   = length(var.nic_names)
  network_interface_id    = data.azurerm_network_interface.network_interfaces[var.nic_names[count.index]].id
  ip_configuration_name   = data.azurerm_network_interface.network_interfaces[var.nic_names[count.index]].ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.ftalk.id
}
