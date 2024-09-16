# TODO my bad. creating module takes a lot of time and i decided to finish with direct implementation
resource "aws_lb" "main" {
  name                       = var.elb_name
  internal                   = var.internal
  load_balancer_type         = var.load_balancer_type
  security_groups            = [module.sg_public.sg_id]
  subnets                    = [for k, v in local.subnet_public_map : v]
  enable_deletion_protection = var.elb_enable_deletion_protection
  tags                       = var.tags
}

# Listeners #
resource "aws_lb_listener" "main_http_public" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.elb_http_port
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
# resource "aws_lb_listener" "main_https_public" {
#   load_balancer_arn = aws_lb.main.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = module.aws_elb_cert.certificate_arn
#
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.main.arn
#   }
# }

# Target groups #
resource "aws_lb_target_group" "main" {
  name        = "${var.elb_name}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
}
resource "aws_lb_target_group_attachment" "main" {
  for_each         = local.subnet_public_map
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.public[each.key].id
  port             = 80
}

# Certificates #
# module "aws_elb_cert" {
#   source            = "../modules/aws_elb_cert/v1"
#   domain_name       = var.domain_name
#   validation_method = var.validation_method
#   tags = merge(
#     var.tags,
#     {
#       Name = var.domain_name
#   })
#   zone_id = aws_lb.main.zone_id
#   ttl     = 60
# }

# Route53 #
# resource "aws_route53_zone" "main" {
#   name = var.zone_domain
# }
# resource "aws_route53_record" "main" {
#   zone_id = aws_route53_record.main.zone_id
#   name    = var.domain_name
#   type    = "CNAME"
#   ttl     = 300
#   records = [aws_lb.main.dns_name]
# }

# Output #
output "dns_name" {
  value = aws_lb.main.dns_name
}
output "zone_id" {
  value = aws_lb.main.zone_id
}

