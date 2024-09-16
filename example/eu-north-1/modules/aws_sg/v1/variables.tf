# Basic #
variable "tags" {
  type    = map(string)
  default = {}
}

# SG #
variable "create_sg" {
  type    = bool
  default = false
}
variable "sg_name" {
  type = string
}
variable "sg_description" {
  type = string
}
variable "vpc_id" {
  type = string
}

# SG Rules #
variable "security_group_id" {
  type    = string
  default = null
}

variable "enabled_default_rules" {
  type    = bool
  default = true
}

variable "sg_rules_cidr_blocks_ingress" {
  type = set(object({
    to_port     = string
    protocol    = string
    from_port   = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "sg_rules_cidr_blocks_egress" {
  type = set(object({
    to_port     = string
    protocol    = string
    from_port   = string
    cidr_blocks = list(string)
  }))
  default = []
}
