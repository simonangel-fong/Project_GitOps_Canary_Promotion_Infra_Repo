# ##############################
# VPC
# ##############################
module "vpc" {
  source = "../../modules/vpc"

  vpc_name = local.vpc_name
  vpc_cidr = local.vpc_cidr
  vpc_tags = local.tags
}

# ##############################
# EKS
# ##############################
module "eks" {
  source = "../../modules/eks"

  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version
  subnet_ids      = module.vpc.private_subnet_ids
  cluster_tags    = local.tags
}

# ##############################
# EKS Node Group
# ##############################
module "node_group" {
  source = "../../modules/node_group"

  cluster_name    = module.eks.cluster_name
  node_group_name = "default"
  subnet_ids      = module.vpc.private_subnet_ids

  instance_types = ["t3.medium"]
  desired_size   = 1
  min_size       = 1
  max_size       = 3

  node_group_tags = local.tags
}
