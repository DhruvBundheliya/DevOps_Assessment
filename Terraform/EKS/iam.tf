data "aws_iam_policy_document" "deployers" {
  statement {
    sid = "1"
    actions = [
      "sts:AssumeRole",
    ]
    resources = [
      aws_iam_role.eks.arn,
      aws_iam_role.ecr.arn
    ]
  }
}

data "aws_iam_policy_document" "eks" {
  statement {
    sid = "1"
    actions = [
      "eks:*"
    ]
    resources = [
      module.eks.cluster_arn
    ]
  }
}

data "aws_iam_policy_document" "assumptions" {
  statement {
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
    actions = [
      "sts:AssumeRole"
    ]

  }
}

resource "aws_iam_role" "eks" {
  name               = "${var.environment}-${var.project}-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.assumptions.json
}

resource "aws_iam_policy" "eks" {
  description = "Just enough access to get EKS credentials"

  policy = data.aws_iam_policy_document.eks.json
}

resource "aws_iam_role_policy_attachment" "eks" {
  role       = aws_iam_role.eks.name
  policy_arn = aws_iam_policy.eks.arn
}

resource "aws_iam_policy" "deployers" {
  name = "${var.environment}-${var.project}-deployers-policy"

  policy = data.aws_iam_policy_document.deployers.json
}

resource "aws_iam_role" "ecr" {
  name               = "${var.environment}-${var.project}-ecr"
  assume_role_policy = data.aws_iam_policy_document.assumptions.json
}

resource "aws_iam_role_policy_attachment" "ecr_policy_attachment" {
  role = aws_iam_role.ecr.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}


data "aws_iam_policy_document" "deployer_ec2_policy" {
  statement {
    sid = "1"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "deployer" {
  name               = "${var.environment}-${var.project}-deployer"
  assume_role_policy = data.aws_iam_policy_document.deployer_ec2_policy.json
}

resource "aws_iam_policy" "deployer" {
  name   = "${var.environment}-${var.project}-deployer-policy"
  policy = data.aws_iam_policy_document.deployers.json
}

resource "aws_iam_role_policy_attachment" "deployer" {
  role       = aws_iam_role.deployer.name
  policy_arn = aws_iam_policy.deployer.arn
}

module "kms_iam_assumable_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  trusted_role_services = ["ec2.amazonaws.com"]
  trusted_role_actions  = ["sts:AssumeRole"]
  create_role           = true

  role_name         = "${var.environment}-KMS-ADMIN-${var.project}"
  role_requires_mfa = false

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  ]
  number_of_custom_role_policy_arns = 2
}

data "aws_iam_policy_document" "kms_use" {
  statement {
    sid    = "1"
    effect = "Allow"
    actions = [
      "kms:*",
    ]
    resources = [
      "*"
    ]
  }
}
resource "aws_iam_policy" "kms_use" {
  name        = "${var.environment}-KMS-ADMIN-${var.project}"
  description = "Policy to allow use of KMS Key"
  policy      = data.aws_iam_policy_document.kms_use.json
}

resource "aws_iam_role_policy_attachment" "temp" {
  role       = "${var.environment}-KMS-ADMIN-${var.project}"
  policy_arn = aws_iam_policy.kms_use.arn

  depends_on = [module.kms_iam_assumable_role]
}