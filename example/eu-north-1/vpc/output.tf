# VPC #
output "vpc_id" {
  value = aws_vpc.main.id
}
output "vpc_arn" {
  value = aws_vpc.main.arn
}
output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
}

# IG #
output "ig_id" {
  value = aws_internet_gateway.main.id
}
output "ig_arn" {
  value = aws_internet_gateway.main.arn
}

# Public Subnet #
output "subnet_public_id" {
  value = [for k in aws_subnet.public : k.id]
}
output "subnet_public_cidrs" {
  value = [for k in aws_subnet.public : k.cidr_block]
}

# Private Subnets #
output "subnet_private_id" {
  value = [for k in aws_subnet.private : k.id]
}
output "subnet_private_cidrs" {
  value = [for k in aws_subnet.private : k.cidr_block]
}

# Other #
output "subnet_az" {
  value = var.subnet_az
}
