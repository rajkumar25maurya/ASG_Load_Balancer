provider "aws" {
  region  = "us-east-1"
}


terraform {
  backend "s3" {
  bucket = "/raj-s3/asg_lb"
  key    = "tf.tfstate"
  region = "us-east-1"
   }
}