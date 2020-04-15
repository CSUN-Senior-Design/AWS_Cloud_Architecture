
#ELB Name, and the availability_zones 
resource "aws_elb" "elb-1" {
  name               = "elb-1"
  subnets = ["${aws_subnet.Private_Subnet_1.id}"]

  security_groups = ["${aws_security_group.elb.id}"]
  
  

  #HTTP Port Listener, will check for HTTP requests going to the instances through Port 80
  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  #Health Check, wil perform checks on the instances to ensure they are working properly.
    health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
  instances = "${aws_instance.EC2_Private_Subnet1.*.id}"
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

    tags = {
    Name = "elb-1"
  }
}


#Security Group allows HTTP
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_vpc.VPC_SenrDesign.id}"
 
  ingress { 
    description = "HTTP Entry"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/20"]
  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

resource "aws_security_group" "elb" {
  name        = "elb_sg"
  description = "Used in the terraform"

   vpc_id = "${aws_vpc.VPC_SenrDesign.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    # ensure the VPC has an Internet gateway or this step will fail
  depends_on = ["aws_internet_gateway.IGW"]
}


 # Assigns the target group for the ELB.
 # resource "aws_lb_target_group" "elb-test" {
 # name     = "elb-test"
 # port     = 80
 # protocol = "HTTP"
 # vpc_id   = "${aws_vpc.VPC_SenrDesign.id}"
 #  }



 


