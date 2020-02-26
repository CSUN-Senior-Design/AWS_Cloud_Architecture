resource "aws_vpc" "VPC-Test" {
        cidr_block = "192.168.0.0/16"
        enable_dns_support = "true"
	enable_dns_hostnames = "true"
	enable_classiclink = "false"
	instance_tenancy = "default"

        tags = {
		Name = "VPC-Test"
  	}
}

resource "aws_subnet" "Test-Public-1" {
	vpc_id = "aws_vpc.VPC-Test.id"
	cidr_block = "192.168.40.0/21"
	map_public_ip_on_launch = "true"
	availability_zone = "us-west-1"

	tags = {
		Name = "Test-Public-1"
	}
}

resource "aws_subnet" "Test-Public-2"{
	vpc_id = "aws_vpc.VPC-Test.id"
        cidr_block = "192.168.48.0/21"
        map_public_ip_on_launch = "true"
        availability_zone = "us-west-2"
	
	tags = {
		Name ="Test-Public-2"
	}
}
