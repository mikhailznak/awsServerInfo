### VPC ###
variable "vpc_name" {
  type = string
}
variable "cidr_block" {
  type    = string
  default = null
}
variable "enable_dns_hostnames" {
  type    = bool
  default = false
}
variable "enable_dns_support" {
  type    = bool
  default = true
}

### Subnet ###
# TODO length(subnet_az) == length(subnet_public_cidrs) == length(subnet_private_cidrs)
# if no, have to refactor and make smth like length(public_subnet_az) == length(subnet_public_cidrs);
# length(private_subnet_az) == length(subnet_private_cidrs)
variable "subnet_az" {
  type    = list(string)
  default = []
}
variable "subnet_public_cidrs" {
  type    = list(string)
  default = []
}
variable "subnet_private_cidrs" {
  type    = list(string)
  default = []
}

### Route Tables ###
variable "default_route_table_routes" {
  type    = list(map(string))
  default = []
}

### NACLs ###
# Public #
variable "inbound_acl_rules_public" {
  type    = list(map(any))
  default = [{}]
}
variable "outbound_acl_rules_public" {
  type    = list(map(any))
  default = [{}]
}

# Private #
variable "inbound_acl_rules_private" {
  type    = list(map(string))
  default = [{}]
}
variable "outbound_acl_rules_private" {
  type    = list(map(string))
  default = [{}]
}

# Basic Vars #
variable "region" {
  type = string
}
variable "environment" {
  type = string
}
variable "account_id" {
  type = number
}
variable "tags" {
  type = map(string)
}