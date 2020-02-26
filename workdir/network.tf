resource "aws_internet_gateway" "IGW-Test" {
	vpc_id = "aws_vpc.VPC-Test.id"

	tags = {
		Name = "IGW-Test"
	}
}

resource "aws_route_table" "Test-Public-CRT" {
	vpc_id = "aws_vpc.default.id"
	
	route {
		cidr_block = "0.0.0.0/0"
	
		gateway_id = "aws_internet_gateway.IGW-Test.id"
	}

	tags = {
		Name = "Test-Public-CRT"
	}
}

resource "aws_route_table_association" "Test-CRTA-Public-1" {
	subnet_id = "aws_subnet.Test-Public-1"
	route_table_id = "aws_route_table.Test-Public-CRT.id"
}

