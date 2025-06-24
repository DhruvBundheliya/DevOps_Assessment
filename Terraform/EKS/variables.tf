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

variable "capacity_type" {
  description = "description"
  default     = ""
}

variable "disk_size" {
  description = "description"
  default     = "30"
}

variable "alb_name" {
  description = "name of the alb"
  default     = ""
  type        = string
}

variable "aws_eks_cluster_version" {
  description = "Kubernetes version supported by EKS"
  type        = string
  default     = "1.29"
}

variable "instance_types" {
  description = " update here Instnace types"
  default     = ""
}

variable "ssh_key_name" {
  description = "add here ssh key name (pem key name) for instance"
  type        = string
  default     = "eks"
}

variable "desired_size" {
  description = "Add here desired number of nodes"
  # type        = string
  default = ""
}
variable "max_size" {
  description = "Add here max number of nodes"
  # type        = string
  default = ""
}
variable "min_size" {
  description = "Add here minimum number of nodes"
  # type        = string
  default = ""
}

variable "aws_auth_additional_labels" {
  description = "Additional kubernetes labels applied on aws-auth ConfigMap"
  type        = map(string)
  default     = {}
}

variable "account_ids" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth ConfigMap"
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth ConfigMap"
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
}

variable "cidr_blocks" {
  type = list(string)
}