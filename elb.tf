
#ELB Name, and the availability_zones 
resource "aws_elb" "wu-tang" {
  name               = "wu-tang"
  count = "1"
  subnets = [ "${aws_subnet.Prvate_Subnet_1.id}" ]

  #HTTP Port Listener, will check for HTTP requests going to the instances through Port 80
  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  #Health Check, wil perform checks on the instances to ensure they are working properly.
    health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }
  instances = "${aws_instance.EC2_Subnet1.*.id}"
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

    tags = {
    Name = "wu-tang"
  }
}


#Security Group allows HTTP
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow TLS inbound traffic"
  ingress {
 
    description = "HTTP Entry"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  
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



 # Assigns the target group for the ELB.
 # resource "aws_lb_target_group" "elb-test" {
 # name     = "elb-test"
 # port     = 80
 # protocol = "HTTP"
 # vpc_id   = "${aws_vpc.VPC_SenrDesign.id}"
 #  }



 


