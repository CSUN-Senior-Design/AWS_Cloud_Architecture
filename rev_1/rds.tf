#SG for RDS
resource "aws_security_group" "mydb" {
  name = "mydb"

  description = "RDS mysql servers (terraform-managed)"
  vpc_id = "${aws_vpc.VPC_SenrDesign.id}"

  # Only postgres in
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = ["${aws_security_group.SG_Private.id}"]
  }
}

#Create DB subnet group so we can host db in both private subnets
resource "aws_db_subnet_group" "db-subnet" {
  name       = "db-subnet"
  subnet_ids = ["${aws_subnet.Private_Subnet_1.id}", "${aws_subnet.Private_Subnet_2.id}"]

  tags = {
    Name = "My DB subnet group"
  }
}

#create RDS instance
resource "aws_db_instance" "mydb1" {
  allocated_storage        = 20 # gigabytes
  db_subnet_group_name     = "${aws_db_subnet_group.db-subnet.name}"
  engine                   = "mysql"
  engine_version           = "5.7.22"
  identifier               = "lab-db"
  instance_class           = "db.t2.micro"
  name                     = "mydb1"
  username                 = "master" # I emptied it before I push this code
  password                 = "lab-password" # I emptied it before I push this code
  port                     = 3306
  publicly_accessible      = false
  storage_type             = "gp2"
  vpc_security_group_ids   = ["${aws_security_group.mydb.id}"]
  backup_retention_period  = 0
  monitoring_interval      = 0
}
