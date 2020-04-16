#Launch Amazon Linux AMI 2018.03.0 ec2 instance - t2 micro
## Instance in AZ us-east-1c
resource "aws_instance" "EC2_Private_Subnet1" {
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
		Name = "EC2_Private_1"
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
        vpc_security_group_ids = ["${aws_security_group.SG_Public.id}"]

				user_data = <<-EOF
					#! /bin/bash
			    sudo yum update -y
					sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
					sudo yum install -y httpd mariadb-server
					sudo systemctl start httpd
					sudo systemctl enable httpd
					EOF


					tags = {
						Name = "EC2_Public_2"
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

#Main web server EC2 to be used as the baseline server
resource "aws_instance" "webserver" {
  ami = "ami-0a887e401f7654935"
  availability_zone = "us-east-1b"
  instance_type = "t2.micro"
  key_name = "tf_test"
  vpc_security_group_ids = ["${aws_security_group.SG_Public.id}"]
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
