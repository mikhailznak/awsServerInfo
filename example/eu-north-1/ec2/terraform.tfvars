#  Basic Vars #
environment = "example"
account_id  = 288250164018
region      = "eu-north-1"
tags        = {}

# EC2 #
ami           = "ami-02ffde950ebf433fd" # 22.04
instance_type = "t3.nano"

# SG #
sg_name_public        = "sg_public"
sg_description_public = "Public SG to test task"
sg_rules_cidr_blocks_ingress_public = [
  {
    to_port     = "22"
    protocol    = "tcp"
    from_port   = "22"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    to_port     = "80"
    protocol    = "tcp"
    from_port   = "80"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    to_port     = "443"
    protocol    = "tcp"
    from_port   = "443"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    to_port     = "0"
    protocol    = "-1"
    from_port   = "0"
    cidr_blocks = ["10.0.0.0/17"]
  },
]
sg_rules_cidr_blocks_egress_public = []

sg_name_private        = "sg_private"
sg_description_private = "Private SG to test task"
sg_rules_cidr_blocks_ingress_private = [

  {
    to_port     = "0"
    protocol    = "-1"
    from_port   = "0"
    cidr_blocks = ["10.0.128.0/17"]
  },
]
sg_rules_cidr_blocks_egress_private = [
  {
    to_port     = "0"
    protocol    = "-1"
    from_port   = "0"
    cidr_blocks = ["10.0.128.0/17"]
  },
]

# ELB #
elb_name    = "365score"
domain_name = "example.com"

# Route53 #
zone_domain = ""


