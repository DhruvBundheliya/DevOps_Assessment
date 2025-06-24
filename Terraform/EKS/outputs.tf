output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}

output "aws_auth_configmap_yaml" {
  description = "A kubernetes configuration to authenticate to this EKS cluster."
  value       = module.eks.aws_auth_configmap_yaml
}

output "region" {
  description = "AWS region."
  value       = var.region
}

output "cloudwatch_log_group_arn" {
  description = "EKS cloudwatch log group arn"
  value       = module.eks.cloudwatch_log_group_arn
}

output "cloudwatch_log_group_name" {
  description = "EKS cloudwatch log group name"
  value       = module.eks.cloudwatch_log_group_name
}

output "cluster_addons" {
  description = "EKS Cluster addons list"
  value       = module.eks.cluster_addons
}

output "cluster_arn" {
  description = "EKS cluster arn"
  value       = module.eks.cluster_arn
}

output "cluster_certificate_authority_data" {
  description = "EKS cluster certificate authority data"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_iam_role_arn" {
  description = "EKS Cluster attached iam role arn"
  value       = module.eks.cluster_iam_role_arn
}

output "cluster_iam_role_name" {
  description = "EKS Cluster attached iam role name"
  value       = module.eks.cluster_iam_role_name
}

output "cluster_iam_role_unique_id" {
  description = "EKS Cluster attached iam role unique id"
  value       = module.eks.cluster_iam_role_unique_id
}

output "cluster_id" {
  description = "EKS Cluster ID"
  value       = module.eks.cluster_id
}

output "cluster_identity_providers" {
  description = "EKS Cluster Identity Provider"
  value       = module.eks.cluster_identity_providers
}

output "cluster_name" {
  description = "EKS Cluster name"
  value       = module.eks.cluster_name
}

output "cluster_oidc_issuer_url" {
  description = "EKS Cluster oidc issuer url"
  value       = module.eks.cluster_oidc_issuer_url
}

output "cluster_platform_version" {
  description = "EKS Cluster platform version"
  value       = module.eks.cluster_platform_version
}

output "cluster_version" {
  description = "EKS Cluster kubernetes version"
  value       = module.eks.cluster_version
}

output "oidc_provider" {
  description = "EKS Cluster oidc provider"
  value       = module.eks.oidc_provider
}

output "kms_key_arn" {
  description = "EKS Cluster KMS key arn"
  value       = module.eks.kms_key_arn
}

output "eks_managed_node_groups" {
  description = "EKS Cluster managed node groups"
  value       = module.eks.eks_managed_node_groups
}

output "eks_managed_node_groups_autoscaling_group_names" {
  description = "EKS Cluster managed node groups autoscalling group"
  value       = module.eks.eks_managed_node_groups_autoscaling_group_names
}

output "node_security_group_id" {
  description = "EKS Cluster node groups security group"
  value       = module.eks.node_security_group_id
}