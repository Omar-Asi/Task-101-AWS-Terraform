variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "example-vpc"
}

variable "cidr_block" {
  description = "cidr_block"
  type        = string
  default     = null
}

variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
 
variable "private_subnet_cidrs1" {
 type        = list(string)
 description = "Private Subnet1 CIDR values"
 default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24",]
}

variable "private_subnet_cidrs2" {
 type        = list(string)
 description = "Private Subnet1 CIDR values"
 default     = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
}

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

