provider "aws" {
  region  = "us-east-1"
}
terraform {
  backend "s3" {
    bucket = "raj-s3"
    key    = "asg_alb/terraform.tfstate"
    region = "us-east-1"
   }
}

