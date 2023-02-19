resource "aws_security_group" "DB-SG" {
  name                   = var.name
  description            = var.description
  vpc_id                 = var.vpc_id
# MySQL/Aurora access from Private Subnet 1
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.4.0/24"]
  }
# MySQL/Aurora access from Private Subnet 2
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.5.0/24"]
  }
# MySQL/Aurora access from Private Subnet 3
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.6.0/24"]
  }
# Outbound Rules
  # Internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

tags = {
   Name = "High Available Website DB-SG"
 }
}