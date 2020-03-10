# VPC Architecture

## VPC
192.168.0.0/16

## 4 Subnets in 4 Different Availability Zones 
1. Public - 192.168.40.0/21
    1. us-west-2a
2. Public - 192.168.48.0/21
    1. us-west-2b
3. Private - 192.168.0.0/20
    1. us-west-2c
4. Private - 192.168.16.0/20
    1. us-west-2d (Cant put instances in this AZ -- Will most likely change AZ)

## Security Groups
1. Only Allows SSH on CSUNs Network
    1. 130.166.0.0/16 --> Bastion Instance

2. Allows SSH from Bastion, to Instances in Private Subnets
    1. 192.168.40.0/21 (Only) --> 192.168.0.0/20, 192.168.16.0/20

## IGW For Public Subnets  
## NAT Gateway for Private Subnets
•Attached to EIP
