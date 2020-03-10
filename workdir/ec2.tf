#Launch Amazon Linux AMI 2018.03.0 ec2 instance - t2 micro
resource "aws_instance" "EC2_Subnet1" {
	count = "2"
	ami = "ami-079f731edfe27c29c"
	instance_type = "t2.micro"
	
	#Add pre-existing key pair to be able to ssh in  
	key_name = "tf_test"
	
	#VPC - Subnet
	subnet_id = "${aws_subnet.Private_Subnet_1.id}"

	#Specify Security Groups
	vpc_security_group_ids = ["${aws_security_group.SG_Private.id}"]
	
	tags = {
		Name = "EC2_Sub1_${count.index + 1}"
	}
}

resource "aws_instance" "bastion" {
	ami = "ami-079f731edfe27c29c"
	instance_type = "t2.micro"
	key_name = "tf_test"
	#vpc_security_group_ids = ["${aws_security_group.SG_Private.id}"]
	vpc_security_group_ids = ["${aws_security_group.SG_Public.id}"]
	subnet_id = "${aws_subnet.Public_Subnet_1.id}"
	
	tags = {
		Name = "Bastion"
	}
}

## Cannot Put instance in AZ us-west-2d ##
/*
resource "aws_instance" "EC2_Subnet2" {
        count = "2"
        ami = "ami-079f731edfe27c29c"
        instance_type = "t2.micro"

        #Add pre-existing key pair to be able to ssh in
        key_name = "tf_test"

        #VPC - Subnet
        subnet_id = "${aws_subnet.Private_Subnet_2.id}"

        #Specify Security Groups
        #vpc_security_groups_ids = ["${aws_security_group.SG_SenrDesign}"]

        tags = {
                Name = "EC2_Sub2_${count.index + 1}"
        }
}
*/


