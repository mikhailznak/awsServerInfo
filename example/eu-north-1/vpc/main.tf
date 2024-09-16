locals {
  subnet_public_ids  = [for k in aws_subnet.public : k.id]
  subnet_private_ids = [for k in aws_subnet.private : k.id]
}
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = merge(
    var.tags,
    {
      Name = var.vpc_name
    }
  )
}

### Internet Gateway ###
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = var.vpc_name
    }
  )
}

### Subnets ###
resource "aws_subnet" "public" {
  for_each          = zipmap(var.subnet_az, var.subnet_public_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-${each.key}-public"
    }
  )
}
resource "aws_subnet" "private" {
  for_each          = zipmap(var.subnet_az, var.subnet_private_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-${each.key}-private"
    }
  )
}

### Route Tables ###
# Default #
resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id
  dynamic "route" {
    for_each = var.default_route_table_routes
    content {
      cidr_block = route.value.cidr_block
      gateway_id = lookup(route.value, "gateway_id", null) == "self" ? aws_internet_gateway.main.id : lookup(route.value, "gateway_id", null)
    }
  }
  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-rt-default"
    }
  )
}

# Public #
resource "aws_route_table" "public" {
  for_each = toset(var.subnet_az)
  vpc_id   = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-${each.key}-rt-public"
    }
  )
}
resource "aws_route" "public_internet_gateway" {
  for_each               = toset(var.subnet_az)
  route_table_id         = aws_route_table.public[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id

  timeouts {
    create = "5m"
  }
}
resource "aws_route_table_association" "public" {
  for_each       = toset(var.subnet_az)
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}

# Private #
resource "aws_route_table" "private" {
  for_each = toset(var.subnet_az)
  vpc_id   = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-${each.key}-rt-private"
    }
  )
}
resource "aws_route_table_association" "private" {
  for_each       = toset(var.subnet_az)
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

### NACLs ###
# Public #
resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = local.subnet_public_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-nacl-public"
    }
  )
}

resource "aws_network_acl_rule" "inbound_public" {
  count = length(var.inbound_acl_rules_public)

  egress         = false
  network_acl_id = aws_network_acl.public.id
  rule_number    = var.inbound_acl_rules_public[count.index]["rule_number"]
  rule_action    = var.inbound_acl_rules_public[count.index]["rule_action"]
  from_port      = lookup(var.inbound_acl_rules_public[count.index], "from_port", null)
  to_port        = lookup(var.inbound_acl_rules_public[count.index], "to_port", null)
  protocol       = var.inbound_acl_rules_public[count.index]["protocol"]
  cidr_block     = var.inbound_acl_rules_public[count.index]["cidr_block"]
}
resource "aws_network_acl_rule" "outbound_public" {
  count = length(var.outbound_acl_rules_public)

  egress         = true
  network_acl_id = aws_network_acl.public.id
  rule_number    = var.outbound_acl_rules_public[count.index]["rule_number"]
  rule_action    = var.outbound_acl_rules_public[count.index]["rule_action"]
  from_port      = lookup(var.outbound_acl_rules_public[count.index], "from_port", null)
  to_port        = lookup(var.outbound_acl_rules_public[count.index], "to_port", null)
  protocol       = var.outbound_acl_rules_public[count.index]["protocol"]
  cidr_block     = var.outbound_acl_rules_public[count.index]["cidr_block"]
}

# Private #
resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = local.subnet_private_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-nacl-private"
    }
  )
}

resource "aws_network_acl_rule" "inbound_private" {
  count = length(var.inbound_acl_rules_private)

  egress         = false
  network_acl_id = aws_network_acl.private.id
  rule_number    = var.outbound_acl_rules_private[count.index]["rule_number"]
  rule_action    = var.outbound_acl_rules_private[count.index]["rule_action"]
  from_port      = lookup(var.outbound_acl_rules_private[count.index], "from_port", null)
  to_port        = lookup(var.outbound_acl_rules_private[count.index], "to_port", null)
  protocol       = var.outbound_acl_rules_private[count.index]["protocol"]
  cidr_block     = var.outbound_acl_rules_private[count.index]["cidr_block"]
}
resource "aws_network_acl_rule" "outbound_private" {
  count = length(var.outbound_acl_rules_private)

  egress         = true
  network_acl_id = aws_network_acl.private.id
  rule_number    = var.outbound_acl_rules_private[count.index]["rule_number"]
  rule_action    = var.outbound_acl_rules_private[count.index]["rule_action"]
  from_port      = lookup(var.outbound_acl_rules_private[count.index], "from_port", null)
  to_port        = lookup(var.outbound_acl_rules_private[count.index], "to_port", null)
  protocol       = var.outbound_acl_rules_private[count.index]["protocol"]
  cidr_block     = var.outbound_acl_rules_private[count.index]["cidr_block"]
}

