terraform {
  backend "s3" {
    bucket = "raj-s3"
    key    = "terraform.tfstate"
    region = "us-east-1"
   }
}