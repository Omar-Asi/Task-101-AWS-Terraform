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


module "vpc" {
  source  = "./modules/aws-vpc"

  cidr_block = "10.0.0.0/16"

}


module "elb-sg" {
  source  = "./modules/aws-elb-sg"

  name        = "Load Balancer Security Group"
  description = "Load Balancer Security Group"
  vpc_id  = module.vpc.vpc_id
}



module "bh-sg" {
  source  = "./modules/aws-bh-sg"

  name        = "Bastion Host Security Group"
  description = "Bastion Host Security Group"
  vpc_id  = module.vpc.vpc_id
}


module "asg-sg" {
  source  = "./modules/aws-asg-sg"

  name        = "ASG Security Group"
  description = "ASG Security Group"
  vpc_id  = module.vpc.vpc_id
}


module "db-sg" {
  source  = "./modules/aws-db-sg"

  name        = "Database Security Group"
  description = "Database Security Group"
  vpc_id  = module.vpc.vpc_id
}


module "key-pair" {
  source  = "./modules/aws-key-pair"

  key_name = "MyKey"
}




module "LT" {
  source  = "./modules/aws-lt"

  
depends_on = [
    module.key-pair ,
    module.rds-db
  ]

}

module "rds-db"{
  source  = "./modules/aws-rds"
  vpc_security_group_ids = ["${module.db-sg.sg_id}"]
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "mydb"
  username             = "user1"
  password             = "password"
  parameter_group_name = "default.mysql5.7"
  identifier           = "wordpress"
   skip_final_snapshot = true
   db_subnet_group_name = module.vpc.db_subnet_group_name

   depends_on = [
    module.vpc ,
    module.db-sg
   ]
}



module "Bastion-Host"{
  source  = "./modules/aws-ec2-instance"
  ami         = "ami-05bfbece1ed5beb54"
  instance_type = "t2.micro"
  key_name = module.key-pair.key_name
   
   subnet_id = module.vpc.pub_sub1_id
   vpc_security_group_ids = [module.bh-sg.sg_id]
   associate_public_ip_address = true
  
  depends_on = [
    module.key-pair
  ]

  tags = {
    Name = "Bastion Host"
  }
}



module "aws-elb"{
    source = "./modules/aws-elb"
    name     = "WebsiteELB"
  internal = false

  security_groups = ["${module.elb-sg.sg_id}"]

  subnets = "${module.vpc.elb_subnets}"

}

module "aws-asg"{
    source = "./modules/aws-asg"
    desired_capacity   = 3
  max_size           = 4
  min_size           = 2
  
  vpc_zone_identifier  = module.vpc.vpc_zone_identifier
  depends_on = [
  module.aws-elb,
  module.LT
  ]
  load_balancers = [
    "${module.aws-elb.elb_id}"
  ]

  launch_template = "${module.aws-lt.lt_name}"
  

}