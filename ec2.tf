#Use US-West-2, Oregon
provider "aws" {
	region = "us-west-2"
}

#Launch Amazon Linux AMI 2018.03.0 ec2 instance - t2 micro
resource "aws_instance" "test-ec2" {
	count = "1"
	ami = "ami-079f731edfe27c29c"
	instance_type = "t2.micro"
	
	#Add pre-existing key pair to be able to ssh in  
	key_name = "tf_test"
	
	#VPC
	subnet_id = "aws_subnet.Test-Public-1.id"

	#Specify Security Groups
	#security_groups = ["${aws_security_group.allow_ssh}"]
	
	tags = {
		Name = "terraform_testing-${count.index + 1}"
	}
}
