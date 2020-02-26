#Create and Set Security Group Info
resource "aws_security_group" "allow_ssh" {
        name = "allow_ssh"
        description = "Allow ssh (port 22) inbound traffic"
        vpc_id = "aws_vpc.VPC-Test.id"

        ingress {
                from_port = 22
                to_port = 22
                protocol = "TCP"
                cidr_blocks = ["130.166.0.0/16"]
        }

        egress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
        }

        tags = {
                Name = "Allow SSH only on CSUN Network"
        }
}
