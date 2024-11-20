variable "environment" {
    type = string
}
variable "project_name" {
    type = string
}
variable "common_tags" {
    type = map 
    default = {}
}
variable "vnet_name" {
    type = string
}
variable "vnet_tags" {
    type = map 
    default = {}
}
variable "address_space" {
    type = list(string)
}
variable "dns_servers" {
    type = list(string)
}
variable "public_subnet_name" {
    type = string
}
variable "public_subnet_address_prefixes" {
    type = list(string)
}
variable "public_subnet_tags" {
    type = map 
    default = {}
}
variable "private_subnet_name" {
    type = string
}
variable "private_subnet_address_prefixes" {
    type = list(string)
}
variable "private_subnet_tags" {
    type = map 
    default = {}
}
variable "database_subnet_name" {
   type = string
}
variable "database_subnet_address_prefixes" {
   type = list(string)
}
variable "database_subnet_tags" {
    type = map 
    default = {}
}
variable "public_rt_name" {
  type = string
}
variable "private_rt_name" {
  type = string
}
variable "database_rt_name" {
  type = string
}
variable "nat_public_ip_name" {
  type = string
}
variable "nat_gateway_name" {
  type = string
}
