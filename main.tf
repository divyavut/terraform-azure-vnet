
# creates Virtual network(vnet)
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  location            = local.rg_location
  resource_group_name = local.rg_name
  address_space       = var.address_space
  dns_servers         = var.dns_servers

  tags =  merge(
   var.common_tags,
    {
        Name = local.resource_name #/ expense-dev
    }
  )
}
# creates public subnet
resource "azurerm_subnet" "public" {
  name                 = var.public_subnet_name
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.public_subnet_address_prefixes
  }

# creates private subnet
resource "azurerm_subnet" "private" {
  name                 = var.private_subnet_name
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.private_subnet_address_prefixes
}
# creates database subnet
resource "azurerm_subnet" "database" {
  name                 = var.database_subnet_name
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.database_subnet_address_prefixes
}
# creates public routetable with specific routes(destinaton(0.0.0.0/0),target(next_hop_type))
resource "azurerm_route_table" "public" {
  name                = var.public_rt_name
  location            = local.rg_location
  resource_group_name = local.rg_name

  route {
    name           = "public"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }
  tags = merge(
    var.common_tags,
    {
      Name = local.resource_name
    }
  )
}
# creates private routetable with specific routes(destinaton(0.0.0.0/0),target(nat gateway id))
resource "azurerm_route_table" "private" {
  name                = var.private_rt_name
  location            = local.rg_location
  resource_group_name = local.rg_name
  route {
    name           = "private"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_public_ip.main.ip_address
  }
  tags = merge(
    var.common_tags,
    {
      Name = local.resource_name
    }
  )
}
# creates database routetable with specific routes(destinaton(0.0.0.0/0),target(nat gateway id))
resource "azurerm_route_table" "database" {
  name                = var.database_rt_name
  location            = local.rg_location
  resource_group_name = local.rg_name
  route {
    name           = "database"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_public_ip.main.ip_address
  }
  tags = merge(
    var.common_tags,
    {
      Name = local.resource_name
    }
  )
}
# creates subnet and routetable association 
resource "azurerm_subnet_route_table_association" "public" {
  subnet_id      = azurerm_subnet.public.id
  route_table_id = azurerm_route_table.public.id
}

# creates subnet and routetable association 
resource "azurerm_subnet_route_table_association" "private" {
  subnet_id      = azurerm_subnet.private.id
  route_table_id = azurerm_route_table.private.id
}
# creates subnet and routetable association 
resource "azurerm_subnet_route_table_association" "database" {
  subnet_id      = azurerm_subnet.database.id
  route_table_id = azurerm_route_table.database.id
}
# creates static ip for nat
resource "azurerm_public_ip" "main" {
  name                = var.nat_public_ip_name
  location            = local.rg_location
  resource_group_name = local.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}
# creates nat gateway
resource "azurerm_nat_gateway" "main" {
  name                = var.nat_gateway_name
  location            = local.rg_location
  resource_group_name = local.rg_name
  sku_name            = "Standard" 
}
# creates nat gateway and public ip association
resource "azurerm_nat_gateway_public_ip_association" "nat_publicip" {
  nat_gateway_id       = azurerm_nat_gateway.main.id
  public_ip_address_id = azurerm_public_ip.main.id
}
# creates subnet and nat gateway association
resource "azurerm_subnet_nat_gateway_association" "nat_subnet" {
  subnet_id      = azurerm_subnet.public.id
  nat_gateway_id = azurerm_nat_gateway.main.id
}

