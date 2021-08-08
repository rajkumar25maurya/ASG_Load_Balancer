resource "aws_launch_configuration" "worker" {
    name_prefix = "Autoscaled_TF"
    
    image_id                            = "${var.ami}"
    instance_type                       = "${var.instance_type}"
    security_groups                     = ["${aws_security_group.elb_security_group.id}"]
    associassociate_public_ip_address   = true
    key_name                            = "ipraxa"
    user_data = <<-EOF
        sudo apt-get update -y
        sudo apt-get install apache2
        sudo service apache2 start
        sudo chkconfig apache2 on
        echo "Hi Raj I am public EC2 launched from Autoscaling!!!!! : $(hostname -f)" > /var/www/html/index.html
        EOF
    
    lifecycle {
        create_before_destroy = true
    }

}


resource "aws_autoscaling_group" "bar" {
  name                   = "my_asg_tf_${aws_launch_configuration.worker.name}"
  desired_capacity       = 1
  max_size               = 3
  min_size               = 1
  launch_configuration   = "${aws_launch_configuration.worker.name}"
  vpc_zone_identifier    = "${aws_subnet.public_subnets.*.id}"
  health_check_type      =   "ELB"

  target_group_arns      = ["${aws_alb_target_group.alb_front_http.arn}"]
  default_cooldown       = 30
  health_check_grace_period = 30
  # Required to redeploy withoout an outage.
  lifecycle {
      create_before_destroy = true
  }  
  }