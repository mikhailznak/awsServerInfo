locals {
  subnet_public_map = zipmap(data.terraform_remote_state.vpc.outputs.subnet_az,
  data.terraform_remote_state.vpc.outputs.subnet_public_id)
  subnet_private_map = zipmap(data.terraform_remote_state.vpc.outputs.subnet_az,
  data.terraform_remote_state.vpc.outputs.subnet_private_id)
}
# SG #
# chosen a flow where sg near resource it uses
module "sg_public" {
  source                       = "../modules/aws_sg/v1"
  create_sg                    = true
  sg_name                      = var.sg_name_public
  sg_description               = var.sg_description_public
  vpc_id                       = data.terraform_remote_state.vpc.outputs.vpc_id
  enabled_default_rules        = true
  sg_rules_cidr_blocks_ingress = var.sg_rules_cidr_blocks_ingress_public
  sg_rules_cidr_blocks_egress  = var.sg_rules_cidr_blocks_egress_public
}
module "sg_private" {
  source                       = "../modules/aws_sg/v1"
  create_sg                    = true
  sg_name                      = var.sg_name_private
  sg_description               = var.sg_description_private
  vpc_id                       = data.terraform_remote_state.vpc.outputs.vpc_id
  enabled_default_rules        = false
  sg_rules_cidr_blocks_ingress = var.sg_rules_cidr_blocks_ingress_private
  sg_rules_cidr_blocks_egress  = var.sg_rules_cidr_blocks_egress_private
}

# EC2 #
resource "aws_instance" "public" {
  for_each                    = local.subnet_public_map
  ami                         = var.ami
  instance_type               = var.instance_type
  availability_zone           = each.key
  associate_public_ip_address = true
  subnet_id                   = each.value
  key_name                    = aws_key_pair.main.key_name

  vpc_security_group_ids = [module.sg_public.sg_id]
  tags = {
    Name = "${each.key}-public"
  }
}
resource "aws_instance" "private" {
  for_each                    = local.subnet_private_map
  ami                         = var.ami
  instance_type               = var.instance_type
  availability_zone           = each.key
  associate_public_ip_address = false
  subnet_id                   = each.value
  key_name                    = aws_key_pair.main.key_name

  vpc_security_group_ids = [module.sg_private.sg_id]
  tags = {
    Name = "${each.key}-private"
  }
}

# Key Pair
resource "aws_key_pair" "main" {
  key_name   = "mixed_access"
  public_key = file("~/.ssh/id_rsa.pub")
}
