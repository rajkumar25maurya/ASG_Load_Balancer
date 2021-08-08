resource "aws_vpc" "mainvpc" {
    cidr_block = "${var.vpc_cidr}"
    instance_tenancy = "default"
    enable_dns_hostnames = true

    tags = {
        Name = "VPC-TF"
    }
}

resource "aws_internet_gateway" "IGF_TF" {
    vpc_id = "${aws_vpc.mainvpc.id}"
    tags = {
      "Name" = "IGF_TF"
    }  
}

resource "aws_eip" "EIP" {
    vpc = true
    tags = {
      "Name" = "EIP"
    }
}

resource "aws_nat_gateway" "NATGW" {
    allocation_id = "${aws_eip.EIP.id}"
    subnet_id = "${aws_subnet.public_subnets[0].id}"
  tags = {
      "Name" = "NATGW"
    }
  depends_on = [ "aws_eip.EIP","aws_subnet.public_subnets" ]

}