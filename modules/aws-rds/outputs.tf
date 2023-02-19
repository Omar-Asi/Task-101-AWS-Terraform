output "DatabaseName" {
value = aws_db_instance.rds-db.db_name
description = "The Database Name!"
}
output "DatabaseUserName" {
value = aws_db_instance.rds-db.username
description = "The Database Name!"
}
output "DBConnectionString" {
value = aws_db_instance.rds-db.endpoint
description = "The Database connection String!"
}