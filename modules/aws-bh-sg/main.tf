resource "aws_security_group" "BH-SG" {
  name                   = var.name
  description            = var.description
  vpc_id                 = var.vpc_id
# Inbound Rules

# SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
   Name = "High Available Website BH-SG"
 }
}