resource "aws_db_subnet_group" "mysql_db_subnet_group" {
  name       = "${var.environment}-mysql-db-subnet-group"
  subnet_ids = [local.env_private_subnet_a_id,local.env_private_subnet_b_id,local]
}