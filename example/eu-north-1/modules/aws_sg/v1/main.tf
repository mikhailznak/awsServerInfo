locals {
  sg_rules_cidr_blocks_ingress = { for rule in var.sg_rules_cidr_blocks_ingress : md5(jsonencode(rule)) => rule }
  sg_rules_cidr_blocks_egress  = { for rule in var.sg_rules_cidr_blocks_egress : md5(jsonencode(rule)) => rule }
}

# SG #
resource "aws_security_group" "this" {
  count       = var.create_sg ? 1 : 0
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id
  tags = merge(
    var.tags,
    {
      Name = var.sg_name
    }
  )
  lifecycle {
    ignore_changes = [name]
  }
}


# SG Rule #
resource "aws_security_group_rule" "default_egress" {
  count             = var.create_sg && var.enabled_default_rules ? 1 : 0
  type              = "egress"
  to_port           = "0"
  protocol          = "-1"
  from_port         = "0"
  security_group_id = aws_security_group.this[0].id
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "cidr_blocks_ingress" {
  for_each          = local.sg_rules_cidr_blocks_ingress
  type              = "ingress"
  to_port           = lookup(each.value, "to_port")
  protocol          = lookup(each.value, "protocol")
  from_port         = lookup(each.value, "from_port")
  security_group_id = var.create_sg ? aws_security_group.this[0].id : var.security_group_id
  cidr_blocks       = lookup(each.value, "cidr_blocks")
}
resource "aws_security_group_rule" "cidr_blocks_egress" {
  for_each          = local.sg_rules_cidr_blocks_egress
  type              = "egress"
  to_port           = lookup(each.value, "to_port")
  protocol          = lookup(each.value, "protocol")
  from_port         = lookup(each.value, "from_port")
  security_group_id = var.create_sg ? aws_security_group.this[0].id : var.security_group_id
  cidr_blocks       = lookup(each.value, "cidr_blocks")
}