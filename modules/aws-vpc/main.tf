terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}



provider "aws" {
  region = "us-east-2"
}



resource "aws_vpc" "HiAvWebsite" {
  cidr_block = var.cidr_block
  tags = {
    Name = "High Available Website VPC"
}
  }



resource "aws_internet_gateway" "igw" {
 vpc_id = aws_vpc.HiAvWebsite.id
 
 tags = {
   Name = "High Available Website IG"
 }
}



# Public Subnets 

resource "aws_subnet" "public_subnets" {
 count      = length(var.public_subnet_cidrs)
 vpc_id     = aws_vpc.HiAvWebsite.id
 cidr_block = element(var.public_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 
 tags = {
   Name = "High Available Website Public Subnet ${count.index + 1}"
 }
}
 



# Private Subnets for Web Servers Layer

resource "aws_subnet" "private_subnets1" {
 count      = length(var.private_subnet_cidrs1)
 cidr_block = element(var.private_subnet_cidrs1, count.index)
 vpc_id     = aws_vpc.HiAvWebsite.id
 availability_zone = element(var.azs, count.index)
 
 tags = {
   Name = "High Available Website Private Subnet (1) ${count.index + 1}"
 }
}




# Private Subnets for Database Layer

resource "aws_subnet" "private_subnets2" {
 count      = length(var.private_subnet_cidrs2)
 vpc_id     = aws_vpc.HiAvWebsite.id
 cidr_block = element(var.private_subnet_cidrs2, count.index)
 availability_zone = element(var.azs, count.index)
 
 tags = {
   Name = "High Available Website Private Subnet (2) ${count.index + 1}"
 }
}





# Public Route Table

resource "aws_route_table" "public_rt" {
 vpc_id = aws_vpc.HiAvWebsite.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.igw.id
 }
 
 tags = {
   Name = "High Available Website Public Route Table"
 }
}




# Public Subnets To Public Route Table Association 

resource "aws_route_table_association" "public_subnet_asso" {
 count = length(var.public_subnet_cidrs)
 subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.public_rt.id
}






# Elastic IP Addresses

resource "aws_eip" "natip" {
  count      = length(var.public_subnet_cidrs)
  vpc = true
  tags = {
   Name = "High Available Website NAT IP ${count.index + 1}"
 }
}





# NAT Gateways

resource "aws_nat_gateway" "nat" {
   count      = length(var.public_subnet_cidrs)
  allocation_id = element(aws_eip.natip[*].id, count.index)
  
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)

  tags = {
    Name = "High Available Website NAT gw ${count.index + 1}"
  }
}





# Private Route Table for Web Servers Layer
 
resource "aws_route_table" "private_rt" {
 vpc_id = aws_vpc.HiAvWebsite.id
 count = length(var.public_subnet_cidrs)
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = element(aws_nat_gateway.nat[*].id, count.index)
 }
 
 tags = {
   Name = "High Available Website Private Route Table (1) ${count.index + 1}"
 }
}




# Association Between Web Servers' Subnets and Their Private Route Table

resource "aws_route_table_association" "private_subnet_asso" {
 count = length(var.public_subnet_cidrs)
 subnet_id      = element(aws_subnet.private_subnets1[*].id, count.index)
 route_table_id = element(aws_route_table.private_rt[*].id, count.index)
}




resource "aws_db_subnet_group" "dbsubg" {
  name       = "dbsubg"
  subnet_ids = [aws_subnet.private_subnets2[0].id , aws_subnet.private_subnets2[2].id , aws_subnet.private_subnets2[2].id]

  tags = {
    Name = "hvwDB subnet group"
  }
}