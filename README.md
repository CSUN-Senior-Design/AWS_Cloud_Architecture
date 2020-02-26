# AWS Cloud Architecture
CSUN CIT Senior Design Project (Spring 2020)

## Project Requirements
1. Construct an architecture solely using Terraform (& maybe Ansible) in order to launch a professional/working infrastructure within minutes.
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
    
5. Elastic Load Balancer (ELB)
    1. Attached to 2 Instances
    
6. SSH Bastion
    1. Host to sit on Public Subnet
    2. Give access to other Hosts within Private Subnets
    
7. Security Groups
    1. Include proper rules
    2. Do not allow SSH from Anywhere

8. Create 4 EC2 Instances in 4AZ
    1. Launch in the correct VPC, Subnets, and Security Group
    2. Name them differently & attach to an access key 

## Installation

### Install AWS CLI
```
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"

sudo installer -pkg AWSCLIV2.pkg -target /

aws configure

#Enter Access Key ID
#Enter Secret Access Key
#Enter Region (ex: us-west-2)
#Enter output format: json
```

### Install Terraform (on Mac)
```
Get Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install terraform
```

### Confirm Installations
```
Make a sample .tf file in a directory

Run terraform init (Initializes working directory)
-(Will also download & connect through aws as provider)

aws --version
terraform --version
```







## Team Members
Misak

Petra

Abdul

Andrew

Eric

Nury
