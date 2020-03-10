#VPC
resource "aws_vpc" "VPC_SenrDesign" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "VPC_SenrDesign"
  }
}

#####################
## SUBNET CREATION ##
#####################
#Public Subnet 1
resource "aws_subnet" "Public_Subnet_1" {
  vpc_id = "${aws_vpc.VPC_SenrDesign.id}"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = "true"
  cidr_block = "192.168.40.0/21"
  
  tags = {
    Name = "Public_Subnet_1"
  }
  
}

#Public Subnet 2
resource "aws_subnet" "Public_Subnet_2" {
  vpc_id = "${aws_vpc.VPC_SenrDesign.id}"
  availability_zone = "us-west-2b"
  map_public_ip_on_launch = "true"
  cidr_block = "192.168.48.0/21"
  
  tags = {
    Name = "Public_Subnet_2"
  }
  
}

#Private Subnet 1
resource "aws_subnet" "Private_Subnet_1" {
  vpc_id = "${aws_vpc.VPC_SenrDesign.id}"
  availability_zone = "us-west-2c"
  cidr_block = "192.168.0.0/20"

  tags = {
    Name = "Private_Subnet_1"
  }
}

#Private Subnet 2
resource "aws_subnet" "Private_Subnet_2" {
  vpc_id = "${aws_vpc.VPC_SenrDesign.id}"
  availability_zone = "us-west-2d"
  cidr_block = "192.168.16.0/20"

  tags = {
    Name = "Private_Subnet_1"
  }
}
####################
## END OF SUBNETS ##
####################

#Security Group 
#SSH from CSUN Network Only
resource "aws_security_group" "SG_Public" {
  name        = "SG_SenrDesign_Public"
  description = "Allow TCP inbound traffic"
  vpc_id      = "${aws_vpc.VPC_SenrDesign.id}"

  ingress {
    description = "SSH Inbound"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["130.166.0.0/16"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    
  }
  tags = {
    Name = "SSH Into Bastion On CSUN Network Only"
  }
}

#SSH Only From Private IPs
resource "aws_security_group" "SG_Private" {
  name        = "SG_SenrDesign_Private"
  description = "Allow TCP inbound traffic"
  vpc_id      = "${aws_vpc.VPC_SenrDesign.id}"

  ingress {
    description = "SSH Inbound"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.40.0/21"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    
  }
  tags = {
    Name = "SSH Allowed only internally (Private IPs)"
  }
}

#Create Internet Gateway
resource "aws_internet_gateway" "IGW" {
   vpc_id = "${aws_vpc.VPC_SenrDesign.id}"

   tags = {
     Name = "IGW"
  }	
}

#Create NAT Gateway
resource "aws_eip" "nat" {
}

resource "aws_nat_gateway" "NAT_GW" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.Private_Subnet_1.id}"

  tags = {
    Name = "NAT_GW"
  }
}

## Route Tables ##
#Route Table - Public Subnets
resource "aws_route_table" "Public_Subnet_RT" {
  vpc_id = "${aws_vpc.VPC_SenrDesign.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.IGW.id}"
  }

  tags = {
    Name = "Public_Subnets_RT"
  }
}

#Route Table - Private Subnets
resource "aws_route_table" "Private_Subnet_RT" {
  vpc_id = "${aws_vpc.VPC_SenrDesign.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.NAT_GW.id}"
  }

  tags = {
    Name = "Private_Subnets_RT"
  }
}

#Route Table Association
##Public Subnets
###
resource "aws_route_table_association" "Public_Assoc_1" {
  subnet_id = "${aws_subnet.Public_Subnet_1.id}"
  route_table_id = "${aws_route_table.Public_Subnet_RT.id}"
}

resource "aws_route_table_association" "Public_Assoc_2" {
  subnet_id = "${aws_subnet.Public_Subnet_2.id}"
  route_table_id = "${aws_route_table.Public_Subnet_RT.id}"
}

#Route Table Association
##Private Subnets
###
resource "aws_route_table_association" "Private_Assoc_1" {
  subnet_id = "${aws_subnet.Private_Subnet_1.id}"
  route_table_id = "${aws_route_table.Private_Subnet_RT.id}"
}

resource "aws_route_table_association" "Private_Assoc_2" {
  subnet_id = "${aws_subnet.Private_Subnet_2.id}"
  route_table_id = "${aws_route_table.Private_Subnet_RT.id}"
}
