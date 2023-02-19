output "vpc_id" {
value = aws_vpc.HiAvWebsite.id
description = "vpc_id"
}

output "pub_sub1_id" {
value = aws_subnet.public_subnets[0].id
description = "pub_sub1_id"
}


output "vpc_zone_identifier" {
value = aws_subnet.private_subnets1.*.id
}

output "db_subnet_group_name" {
value = aws_db_subnet_group.dbsubg.name
description = "db_subnet_group_name"
}

output "elb_subnets" {
value = aws_subnet.public_subnets.*.id
}


