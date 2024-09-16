data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "365score-288250164018-terraform-state"
    key    = "example/eu-north-1/vpc/terraform.tfstate"
    region = "eu-north-1"
  }
}