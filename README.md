# AWS_Cloud_Architecture
CSUN CIT Senior Design Project (Spring 2020)

## Project Requirements
1. Construct an architecture solely using Terraform (& maybe Ansible) in order to launch a professional/working infrastructure within minutes
2. Make sure all services are connected to one another, have proper security permissions, and are working properly.
3. Confirm that all instances/services are in the correct subnets and have the appropriate ingress/egress rules.

## Project Goals
1. Create VPC (/16) 
    1. 2 Public Subnets (/21) and 2 Private Subnets (/20)
    2. 4 Availability Zones (For 4 different EC2 Instances)
    3. NAT Instance/Gateway (Private Subnets)
    4. Internet Gateway (Public Subnets)

2. S3 Bucket
    1. Remote (Terraform) State

3. RDS Instance
    1. MySQL

4. Lambda & Cloudwatch
    1. Trigger based on event (Time Based [Mo-Fri])
    2. Call and Invoke Lamda Function to start or stop EC2 Instances
    3. Apply same concepts for other services such as RDS
    
5. 
