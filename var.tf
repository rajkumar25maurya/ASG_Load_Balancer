variable "region" {
    default = "us-east-1"
    
    }

variable "vpc_cidr" {
    default = "10.0.0.0/16"
 

}

variable "instance_type" {
    default = "t2.nano"
}


variable "ami" {
    default = "ami-09e67e426f25ce0d7"
}

variable "public_subnet_cidr" {
    type = list(string)
    default = ["10.0.0.0/24","10.0.1.0/24"]

}

variable "private_subnet_cidr" {
    type = list(string)
    default = ["10.0.2.0/24","10.0.3.0/24"]

    
}

variable "availability_zone" {
    type = list(string)    
    default = [ "us-east-1a", "us-east-1b" ]
}

variable "public_subnet_names" {
    type = list(string)
    default = ["public_subnet_1","public_subnet_1b"]
  
}


variable "private_subnet_names" {
    type = list(string)
    default = ["private_subnet_1","private_subnet_1b"]
  
}