terraform {
  backend "s3" {
    key = "rds/rds.tfstate"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  workspace = substr(terraform.workspace, 0, 4) == "prod" ? terraform.workspace : "dev-${var.region}"
  config = {
    bucket               = "bucket-tf-state"
    key                  = "vpc/vpc.tfstate"
    region               = ""
  }
}

locals {
  env_vpc_cidr            = data.terraform_remote_state.vpc.outputs.cidr_blocks
  env_vpc_id              = data.terraform_remote_state.vpc.outputs.vpc_id
  env_private_subnet_a_id = data.terraform_remote_state.vpc.outputs.private_subnets[0]
  env_private_subnet_b_id = data.terraform_remote_state.vpc.outputs.private_subnets[1]
}


data "aws_secretsmanager_secret" "mysql_db_secret" {
  name = "${var.environment}-db"
}

data "aws_secretsmanager_secret_version" "secrets_version" {
  secret_id = data.aws_secretsmanager_secret.mysql_db_secret.id
}

locals {
  secrets = jsondecode(
    data.aws_secretsmanager_secret_version.secrets_version.secret_string
  )
}

resource "aws_db_instance" "mysql_db" {
  username                              = local.secrets.username
  password                              = local.secrets.password
  instance_class                        = var.instance_class
  identifier                            = ${var.environment}-mysql-db"
  db_name                               = var.db_name
  storage_type                          = var.storage_type
  engine                                = var.engine
  engine_version                        = var.engine_version
  allocated_storage                     = var.allocated_storage
  max_allocated_storage                 = var.max_allocated_storage
  storage_encrypted                     = var.storage_encrypted
  port                                  = var.port
  multi_az                              = var.multi_az
  db_subnet_group_name                  = "cost-management-${local.environment}-mysql-db-subnet-group"
  vpc_security_group_ids                = [aws_security_group.mysql_db_sg.id]
  publicly_accessible                   = var.publicly_accessible
  maintenance_window                    = var.maintenance_window
  backup_window                         = var.backup_window
  backup_retention_period               = var.backup_retention_period
  enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_logs_exports
  deletion_protection                   = false
  monitoring_interval                   = var.monitoring_interval
  monitoring_role_arn                   = aws_iam_role.mysql_db_monitoring_role.arn
  skip_final_snapshot                   = true

    depends_on = [
    aws_db_subnet_group.mysql_db_subnet_group,
    aws_db_parameter_group.mysql_db_parameter_group
    ]
}