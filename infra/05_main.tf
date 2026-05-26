# main.tf
# ##############################
# VPC
# ##############################
module "vpc" {
  source = "../modules/vpc"

  vpc_name = local.vpc_name
  vpc_cidr = local.vpc_cidr
  vpc_tags = local.tags
}

# ##############################
# EKS
# ##############################
module "eks" {
  source = "../modules/eks"

  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version
  subnet_ids      = module.vpc.private_subnet_ids
  cluster_tags    = local.tags

  node_security_group_tags = {
    "karpenter.sh/discovery" = local.cluster_name
  }
}

# ##############################
# EKS Node Group: Bootstrap
# ##############################
module "eks_node_group" {
  source = "../modules/eks_node_group"

  cluster_name = module.eks.cluster_name
  subnet_ids   = module.vpc.private_subnet_ids

  # node group
  node_group_name = local.node_group_name
  instance_types  = local.node_instance_types
  min_size        = local.node_min_size
  max_size        = local.node_max_size
  desired_size    = local.node_desired_size
  node_group_tags = local.tags
}

# ##############################
# Karpenter(Auth model: Pod Identity)
# ##############################
module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "~> 20.0"

  cluster_name = module.eks.cluster_name

  node_iam_role_use_name_prefix   = false
  node_iam_role_name              = module.eks.cluster_name
  create_pod_identity_association = true

  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = local.tags

  depends_on = [module.eks]
}

# ##############################
# ArgoCD
# ##############################
module "eks_argocd" {
  source = "../modules/eks_argocd"

  chart_version = "9.5.14"

  # ArgoCD AppProject
  project_name = local.project_name

  # Root app-of-apps
  enable_root_app      = true
  gitops_repo_url      = "https://github.com/simonangel-fong/Project_GitOps_Platform_Repo.git"
  gitops_repo_revision = var.env
  gitops_repo_path     = "bootstrap"

  # Turn on the notifications controller
  enable_notifications = var.slack_bot_token != ""

  depends_on = [
    module.eks_node_group,
    module.karpenter
  ]
}
