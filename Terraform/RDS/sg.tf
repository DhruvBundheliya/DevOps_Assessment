resource "aws_security_group" "mysql_db_sg" {
  name        = "cost-management-${var.environment}-mysql-db-sg"
  description = "Allow HTTP inbound traffic from within VPC"
  vpc_id = local.env_vpc_id

 ingress {
    description = "TLS from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [local.env_vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "outbound to internet"
  }
    tags = local.default_tags
}