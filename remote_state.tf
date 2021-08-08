terraform {
  backend "s3" {
    bucket = "raj-s3"
    key    = "asg_lb/terraform.tfstate"
    region = "us-east-1"
   }
}