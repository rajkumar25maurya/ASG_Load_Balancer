resource "aws_security_group" "ec2_public_security_group" {
    name        = "ec2-public-scg"
    description = "Internet reaching access for public ec2s"
    vpc_id = "${aws_vpc.mainvpc.id}"

    ingress {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      security_groups = ["${aws_security_group.elb_security_group.id}"]
    }
  
    egress {
      cidr_blocks = [ "0.0.0.0/0" ]
      from_port = 0
      to_port = 0
      protocol = "-1" 

    }
    tags = {
      "Name" = "ec2_public_security_group"
    }
    depends_on = [ "aws_vpc.mainvpc", "aws_security_group.elb_security_group" ]
}

resource "aws_security_group" "ec2_private_security_group" {
    name = "EC2-private-scg"
    description = "Only allow public SG resource to access private instances"
    vpc_id = "${aws_vpc.mainvpc.id }"
  
    ingress {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      ## it rule will Allow all traffic which is comming from below security group
      security_groups = ["${aws_security_group.ec2_public_security_group.id}"]   
    }  
    
    egress {
      from_port     = 0
      to_port       = 0
      protocol      =  "-1"
      cidr_blocks   = ["0.0.0.0/0"]
    }

    tags = {
    name = "ec2_private_security_group"
    }

    depends_on = ["aws_vpc.mainvpc","aws_security_group.ec2_public_security_group"]
}

resource "aws_security_group" "elb_security_group" {
  name = "ELB-SG"
  description = "ELB security group"
  vpc_id = "${aws_vpc.mainvpc.id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow web traffic to load balancer"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "elb_security_group"
  }
}
