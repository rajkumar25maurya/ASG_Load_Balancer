resource "aws_key_pair" "ipraxa" {
    key_name = "ipraxa"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDeS3i+Gw67UHbZwWRSPkBcqLodJbG/DCrXbbsj0poxtN8IHazza5H9VmnDOd544+2EtIDYd0eHdt4nVZkWDgGs3Wt+hrK866amtCBNxL4Sxx81SrxQTgX4N+A6X77DalHb5J0pXe+12Y6A2XogsaaBjVkhH4liHCMtqlQaXsHJtMz+xylZpXegpgF8gjIEIDlTwsm6LrvPumuRXFhkTIGEYfpc5GDCUp30I6jQ6XVDV7LVtwDgif5mVQsk7DwDXGmt44wyBu2HQjmWw3Vsu6WBSBvnzzC7O7vu+FANBj2z2zwncWhkY2oDDTDdohv1YzrMQ2vpyfkr+iyV3xKlCa7v ansible@workstation.example.com"
  
}

resource "aws_instance" "PublicEC2" {
    count = "${length(var.public_subnet_cidr)}"
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    vpc_security_group_ids = [ "${aws_security_group.ec2_public_security_group.id}" ]
    subnet_id = "${aws_subnet.public_subnets[count.index].id}"
    key_name = "ipraxa"
    tags = {
      "Name" = "${format("PublicEC2.%d", count.index+1)}" 
   }
user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get install -y apache2
    sudo service apache2 start
    echo "Hi this is Public EC2 $(hostname -f) !!!" > /var/www/html/index.html
    EOF

   
    depends_on = [ "aws_vpc.mainvpc","aws_subnet.public_subnets", "aws_security_group.ec2_public_security_group" ]

    }

resource "aws_instance" "PrivateEC2" {
    count = "${length(var.private_subnet_cidr)}"
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    vpc_security_group_ids = ["${aws_security_group.ec2_private_security_group.id}"]
    subnet_id = "${aws_subnet.private_subnets[count.index].id}"
    key_name = "ipraxa"
    tags = {
        "Name" = "${format("PrivateEC2.%d", count.index+1)}"
    }
user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get install -y apache2
    sudo service apache2 start
    echo "Hi this is Private EC2 !!! $(hostname -f)" > /var/www/html/index.html
    EOF

  
    depends_on = ["aws_vpc.mainvpc","aws_subnet.private_subnets", "aws_security_group.ec2_private_security_group"]

    }