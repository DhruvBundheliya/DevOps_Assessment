
variable "project" {
  description = "description"
  default     = ""
}

variable "environment" {
  description = "description"
  default     = "auto"
}

variable "region" {
  default = ""
}

variable "username" {
  default = ""
}

variable "password" {
  default = ""
}

variable "db_name" {
  default = ""
}

variable "engine" {
  description = "The database engine to use"
  default = "mysql"
}

variable "engine_version" {
  description = "The engine version to use"
  default = "8.0.32"
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  default = ""
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  default = ""
}

variable "max_allocated_storage" {
  description = "The max allocated storage in gigabytes"
  default = ""
}

variable "storage_encrypted" {
  description = "The type of storage to use"
  default = "true"
}

variable "storage_type" {
  description = "The type of storage to use"
  default = "gp3"
}

variable "performance_insights_enabled" {
  default = ""
}

variable "performance_insights_retention_period" {
  default = ""
}

variable "monitoring_interval" {
  default = ""
}

variable "port" {
  description = "The port on which the DB accepts connections"
  default = "3306"
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  default = ""
}

variable "maintenance_window" {
  description = "The window to perform maintenance in"
  default = "Mon:00:00-Mon:03:00"
}

variable "backup_window" {
  description = "The window to perform backups in"
  default = "03:00-06:00"
}

variable "backup_retention_period" {
  description = "The number of days to retain backups for"
  default = ""
}

variable "publicly_accessible" {
  description = "Whether the DB should have a public IP address"
  default = "false"
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to cloudwatch"
  default = []
}