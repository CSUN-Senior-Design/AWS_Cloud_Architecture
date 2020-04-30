#Launch Amazon Linux AMI 2018.03.0 ec2 instance - t2 micro
## Instance in AZ us-east-1c
resource "aws_instance" "EC2_Private_Subnet1_" {
	count = "2"
	ami = "ami-0e2ff28bfb72a4e45"
	instance_type = "t2.micro"

	#Add pre-existing key pair to be able to ssh in
	key_name = "tf_test"

	#VPC - Subnet
	subnet_id = "${aws_subnet.Private_Subnet_1.id}"

	#Specify Security Groups
	vpc_security_group_ids = ["${aws_security_group.SG_Private.id}"]

	user_data = <<-EOF
		#! /bin/bash
    sudo yum update -y
		sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
		sudo yum install -y httpd mariadb-server
		sudo systemctl start httpd
		sudo systemctl enable httpd
		EOF

	tags = {
		Name = "EC2_Private_Sub1_${count.index + 1}"
	}
}

## Instance in AZ us-east-1b
resource "aws_instance" "EC2_Public_Subnet2" {
        count = "1"
        ami = "ami-0e2ff28bfb72a4e45"
        instance_type = "t2.micro"

        #Add pre-existing key pair to be able to ssh in
        key_name = "tf_test"

        #VPC - Subnet
        subnet_id = "${aws_subnet.Public_Subnet_2.id}"

        #Specify Security Groups
        vpc_security_group_ids = ["${aws_security_group.SG_Private.id}"]

				user_data = <<-EOF
					#! /bin/bash
			    sudo yum update -y
					sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
					sudo yum install -y httpd mariadb-server
					sudo systemctl start httpd
					sudo systemctl enable httpd
					EOF


					tags = {
						Name = "EC2_Public_Sub2_${count.index + 1}"
					}
					
}


## Instance in AZ us-east-1a
resource "aws_instance" "bastion" {
	ami = "ami-0e2ff28bfb72a4e45"
	instance_type = "t2.micro"
	key_name = "tf_test"
	#vpc_security_group_ids = ["${aws_security_group.SG_Private.id}"]
	vpc_security_group_ids = ["${aws_security_group.SG_Public.id}"]
	subnet_id = "${aws_subnet.Public_Subnet_1.id}"

	tags = {
		Name = "Bastion"
	}
}

## Put instance in AZ us-east-1d ##
##

resource "aws_instance" "EC2_Private_Subnet2" {
        count = "1"
        ami = "ami-0e2ff28bfb72a4e45"
        instance_type = "t2.micro"

        #Add pre-existing key pair to be able to ssh in
        key_name = "tf_test"

        #VPC - Subnet
        subnet_id = "${aws_subnet.Private_Subnet_2.id}"

        #Specify Security Groups
	vpc_security_group_ids = ["${aws_security_group.SG_Private.id}"]

        tags = {
                Name = "EC2_Private_Sub2_${count.index + 1}"
        }
}


resource "aws_security_group" "web" {
	name = "vpc_web"
	description = "Allow incoming HTTP connections"

	ingress {
    description = "SSH into Private IPs from Public Subnet 1"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.40.0/21"]
  }

  ingress {
    description = "SSH into Private IPs from Public Subnet 2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.48.0/21"]
  }

  ingress {
    description = "SSH into Private IPs from Private Subnet 1"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/20"]
  }

  ingress {
    description = "SSH into Private IPs from Private Subnet 2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.16.0/20"]
  }

  ingress {
    description = "Allow MySQL traffic inbound"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/20", "192.168.16.0/20"]
  }

  ingress {
    description = "Allow http traffic inbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow https traffic inbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow http traffic outbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow https traffic outbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]

  }

  vpc_id = "${aws_vpc.VPC_SenrDesign.id}"


	tags= {
		Name = "Web Server SG"
	}
}


#Main web server EC2 to be used as the baseline server
resource "aws_instance" "webserver" {
  ami = "ami-0a887e401f7654935"
  availability_zone = "us-east-1b"
  instance_type = "t2.micro"
  key_name = "tf_test"
  vpc_security_group_ids = ["${aws_security_group.web.id}"]
  subnet_id = "${aws_subnet.Public_Subnet_2.id}"
  associate_public_ip_address = true
  source_dest_check = false

	user_data = <<-EOF
		#! /bin/bash
    sudo yum update -y
		sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
		sudo yum install -y httpd mariadb-server
		sudo systemctl start httpd
		sudo systemctl enable httpd
		EOF

  tags= {
    Name = "Web Server 1"
  }
}
