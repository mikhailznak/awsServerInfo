#  Basic Vars #
environment = "example"
account_id  = 288250164018
region      = "eu-north-1"
tags        = {}

### VPC Vars ###
vpc_name             = "365score"
cidr_block           = "10.0.0.0/16"
enable_dns_hostnames = true
enable_dns_support   = true

### Subnet ###
subnet_az            = ["eu-north-1a", "eu-north-1b"]
subnet_public_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
subnet_private_cidrs = ["10.0.128.0/24", "10.0.129.0/24"]

### Route Tables ###
default_route_table_routes = []

### NACLs ###
inbound_acl_rules_public = [
  {
    rule_number = 100
    rule_action = "allow"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_block  = "0.0.0.0/0"
  }
]
outbound_acl_rules_public = [
  {
    rule_number = 100
    rule_action = "allow"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_block  = "0.0.0.0/0"
  }
]

inbound_acl_rules_private = [
  {
    rule_number = 100
    rule_action = "allow"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_block  = "10.0.128.0/17"
  }
]
outbound_acl_rules_private = [
  {
    rule_number = 100
    rule_action = "allow"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_block  = "10.0.128.0/17"
  }
]
