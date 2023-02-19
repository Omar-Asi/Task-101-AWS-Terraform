resource "aws_autoscaling_group" "OmarAsi-ASG" {
  
  #availability_zones = [var.azs[0], var.azs[1], var.azs[2]]
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size
  
  vpc_zone_identifier  = var.vpc_zone_identifier
  
  load_balancers = var.load_balancers

  launch_template  = var.lt_name
    launch_template_version = "$Latest"
  

  
}
