# Data for Launch Template User Data

data "template_file" "launch" {
  template = <<-EOF
      #!/bin/bash
      sudo yum update -y
      sudo yum install httpd php php-mysql -y -q
      sudo cd /var/www/html
      echo "Welcome" > hi.html
      sudo wget https://wordpress.org/wordpress-5.1.1.tar.gz
      sudo tar -xzf wordpress-5.1.1.tar.gz
      sudo cp -r wordpress/* /var/www/html/
      sudo rm -rf wordpress
      sudo rm -rf wordpress-5.1.1.tar.gz
      sudo chmod -R 755 wp-content
      sudo chown -R apache:apache wp-content
      sudo wget https://s3.amazonaws.com/bucketforwordpresslab-donotdelete/htaccess.txt
      sudo mv htaccess.txt .htaccess
      sudo systemctl start httpd
      sudo systemctl enable httpd 
   EOF
}

locals {
  instance_types = {
    dev   = "t2.micro"
    uat = "t2.small"
    prod  = "m4.large"
  }
}


# Launch Template 

resource "aws_launch_template" "launch" {
  name_prefix   = "launch"
  image_id      = "ami-05bfbece1ed5beb54"
  instance_type = local.instance_types[terraform.workspace]
  key_name = var.key_name
  vpc_security_group_ids = var.vpc_zone_identifier
  user_data = "${base64encode(data.template_file.launch.rendered)}"

  

  
  tags = {
    Name = "High Available Website LT"
  }
}