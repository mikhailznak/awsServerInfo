# EC2 #
variable "ami" {
  type = string
}
variable "instance_type" {
  type = string
}

# SG #
variable "sg_name_public" {
  type = string
}
variable "sg_description_public" {
  type = string
}
variable "sg_rules_cidr_blocks_ingress_public" {
  type = set(object({
    to_port     = string
    protocol    = string
    from_port   = string
    cidr_blocks = list(string)
  }))
  default = []
}
variable "sg_rules_cidr_blocks_egress_public" {
  type = set(object({
    to_port     = string
    protocol    = string
    from_port   = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "sg_name_private" {
  type = string
}
variable "sg_description_private" {
  type = string
}
variable "sg_rules_cidr_blocks_ingress_private" {
  type = set(object({
    to_port     = string
    protocol    = string
    from_port   = string
    cidr_blocks = list(string)
  }))
  default = []
}
variable "sg_rules_cidr_blocks_egress_private" {
  type = set(object({
    to_port     = string
    protocol    = string
    from_port   = string
    cidr_blocks = list(string)
  }))
  default = []
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

# ELB #
variable "elb_name" {
  type = string
}
variable "internal" {
  type    = bool
  default = false
}
variable "load_balancer_type" {
  type    = string
  default = "application"
}
variable "elb_enable_deletion_protection" {
  type    = bool
  default = false
}
variable "elb_http_port" {
  type    = string
  default = "80"
}
variable "elb_https_port" {
  type    = string
  default = "443"
}
variable "domain_name" {
  type = string
}
variable "validation_method" {
  type    = string
  default = "DNS"
}

# Route53 #
variable "zone_domain" {
  type = string
}


