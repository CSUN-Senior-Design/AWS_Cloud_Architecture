
#ELB Name, and the availability_zones
resource "aws_lb" "alb" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  #this can be changed basically the SG we use for our base server
  security_groups    = ["${aws_security_group.web.id}"] #double check with web sg
  #availability_zones = ["us-east-1a", "us-east-1b"]
  subnets = [ "${aws_subnet.Public_Subnet_1.id}", "${aws_subnet.Public_Subnet_2.id}" ]

  enable_deletion_protection = false
}


resource "aws_lb_target_group" "targetGroup" {
  name = "targetGroup"
  port = 80
  protocol = "HTTP"
  vpc_id = "${aws_vpc.VPC_SenrDesign.id}"
  target_type = "instance"


}



resource "aws_lb_listener" "alb" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.targetGroup.arn}"
  }
}

resource "aws_ami_from_instance" "web_server_ami" {
  name               = "web_server_ami"
  source_instance_id = "${aws_instance.webserver.id}"
}

resource "aws_launch_configuration" "launchConfig" {
  image_id      = "${aws_ami_from_instance.web_server_ami.id}"
  instance_type = "t2.micro"
  name = "launchConfig"
  enable_monitoring = "true"
  security_groups = ["${aws_security_group.web.id}"]
  key_name = "tf_test"

}

resource "aws_autoscaling_group" "asg" {
  name = "asg"
  launch_configuration = "${aws_launch_configuration.launchConfig.id}"
  vpc_zone_identifier       = [ "${aws_subnet.Public_Subnet_1.id}", "${aws_subnet.Public_Subnet_2.id}" ]
  availability_zones = ["us-east-1a", "us-east-1b"]
  max_size           = 6
  min_size           = 1
  target_group_arns = ["${aws_lb_target_group.targetGroup.arn}"]
  health_check_type = "ELB"
  health_check_grace_period = 300




}

resource "aws_autoscaling_policy" "scalingPolicy" {
  name = "scalingPolicy"
  autoscaling_group_name = "${aws_autoscaling_group.asg.name}"
  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
  predefined_metric_specification {
    predefined_metric_type = "ASGAverageCPUUtilization"
  }

  target_value = 60.0
}

}
