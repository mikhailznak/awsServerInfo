output "sg_id" {
  value = var.create_sg ? aws_security_group.this[0].id : var.security_group_id
}
output "sg_name" {
  value = var.create_sg ? aws_security_group.this[0].name : ""
}
output "sg_arn" {
  value = var.create_sg ? aws_security_group.this[0].arn : ""
}