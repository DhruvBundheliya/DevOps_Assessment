variable "project" {
  type        = string
  default     = ""
  description = "Project name is used to identify resources"
}

variable "environment" {
  description = "used to compute environment value"
  default     = "auto"
}

variable "bucket_name" {
  description = "used to compute environment value"
  default     = ""
}