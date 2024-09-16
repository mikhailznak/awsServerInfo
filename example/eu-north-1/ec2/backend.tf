terraform {
  required_providers {
    aws = {
      version = "~> 5.0"
    }
  }
  backend "s3" {
    encrypt  = true
    bucket   = "365score-288250164018-terraform-state"
    key      = "example/eu-north-1/ec2/terraform.tfstate"
    region   = "eu-north-1"
    role_arn = "arn:aws:iam::288250164018:role/terraform-assume-role"
  }
}