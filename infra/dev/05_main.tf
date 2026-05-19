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
