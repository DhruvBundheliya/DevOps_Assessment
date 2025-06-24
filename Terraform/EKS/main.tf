terraform {
  backend "s3" {
    key = "eks/eks.tfstate"
  }
}

data "aws_iam_policy" "Amazon_EKS_CNI_Policy" {
  name = "AmazonEKS_CNI_Policy" # Replace with the name of the AWS managed policy you want to read
}

data "aws_iam_policy" "Amazon_EBS_CSI_Driver_Policy" {
  name = "AmazonEBSCSIDriverPolicy" # Replace with the name of the AWS managed policy you want to read
}

data "aws_iam_policy" "Amazon_EFS_CSI_Driver_Policy" {
  name = "AmazonEFSCSIDriverPolicy" # Replace with the name of the AWS managed policy you want to read
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.17.4"

  cluster_name    = "${var.project}-${var.environment}-eks"
  cluster_version = var.aws_eks_cluster_version

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-efs-csi-driver = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  cluster_endpoint_public_access  = false
  cluster_endpoint_private_access = true
  create_node_security_group      = false
  node_security_group_id          = aws_security_group.nodegroup_sg.id

  kms_key_administrators = concat([data.aws_iam_session_context.current.issuer_arn], ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"])
  kms_key_users          = concat([module.kms_iam_assumable_role.iam_role_arn], [data.aws_iam_session_context.current.issuer_arn])

  vpc_id                                = local.env_vpc_id
  cluster_additional_security_group_ids = [aws_security_group.eks_cluster_sg.id]
  subnet_ids                            = [local.env_private_subnet_a_id, local.env_private_subnet_b_id]
  control_plane_subnet_ids              = [local.env_private_subnet_a_id, local.env_private_subnet_b_id]

  eks_managed_node_group_defaults = {
    instance_types = var.instance_types
    key_name       = var.ssh_key_name
    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = 50
          volume_type           = "gp3"
          iops                  = 3000
          throughput            = 150
          delete_on_termination = true
        }
      }
    }
    iam_role_additional_policies = {
      AmazonEC2FullAccess = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
    }

  }
  eks_managed_node_groups = {
    lms_node = {
      min_size       = var.min_size
      max_size       = var.max_size
      desired_size   = var.desired_size
      instance_types = var.instance_types
      capacity_type  = var.capacity_type
      disk_size      = var.disk_size
      # disk_size      = 30
    }
  }

  manage_aws_auth_configmap = true

  aws_auth_accounts = var.account_ids
  aws_auth_users = var.map_users

  aws_auth_roles = concat([{
    rolearn  = aws_iam_role.eks.arn
    username = aws_iam_role.eks.name
    groups   = ["system:masters"]
  }], var.map_roles)

  tags = merge(local.default_tags, {
    Name = "${var.project}-${var.environment}-eks-cluster"
  })
}

resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.project}-${var.environment}-eks-cluster"
  description = "Allow HTTP inbound traffic from within VPC"
  vpc_id      = local.env_vpc_id
  tags        = local.default_tags
}
resource "aws_security_group_rule" "allow_all_within_vpc" {
  type              = "ingress"
  description       = "allow all traffic from within VPC"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.cidr_blocks
  security_group_id = aws_security_group.eks_cluster_sg.id
}

resource "aws_security_group_rule" "allow_outbound_eks_cluster" {
  type              = "egress"
  description       = "outbound to internet"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks_cluster_sg.id
}

resource "aws_security_group" "nodegroup_sg" {
  name_prefix = "${var.project}-${var.environment}-nodegroup-sg"
  vpc_id      = local.env_vpc_id
  tags        = local.default_tags
}

resource "aws_security_group_rule" "allow_all_nodegroup" {
  type        = "ingress"
  description = "allow HTTPS"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks       = [local.env_vpc_cidr]
  security_group_id = aws_security_group.nodegroup_sg.id
}

resource "aws_security_group_rule" "allow_outbound_nodegroup" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nodegroup_sg.id
}