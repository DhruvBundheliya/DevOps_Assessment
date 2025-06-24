resource "aws_iam_role" "mysql_db_monitoring_role" {
  name = "${var.environment}-mysql-db-monitoring-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}
