# Create a Key Pair and Save it Locally with main.tf in the same folder with .pem extension

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "omarkey" {
  content  = tls_private_key.pk.private_key_pem
  filename = "MyKey.pem"
}

resource "aws_key_pair" "kp" {
  key_name   = var.key_name       # Create a "Key" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh
}