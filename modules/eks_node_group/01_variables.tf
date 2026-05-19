# variable.tf
variable "cluster_name" {
  description = "Name of the EKS cluster this node group attaches to"
  type        = string
}

variable "node_group_name" {
  description = "Name of the EKS managed node group"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs where worker nodes will be launched (typically private subnets)"
  type        = list(string)
}

variable "instance_types" {
  description = "EC2 instance types for the node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "capacity_type" {
  description = "Capacity type for the nodes (ON_DEMAND or SPOT)"
  type        = string
  default     = "ON_DEMAND"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.capacity_type)
    error_message = "capacity_type must be ON_DEMAND or SPOT."
  }
}

variable "ami_type" {
  description = "AMI type for the node group (e.g. AL2023_x86_64_STANDARD, AL2_x86_64, BOTTLEROCKET_x86_64)"
  type        = string
  default     = "BOTTLEROCKET_x86_64"
}

variable "disk_size" {
  description = "Disk size in GiB for worker nodes"
  type        = number
  default     = 20
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "labels" {
  description = "Kubernetes labels applied to the nodes"
  type        = map(string)
  default     = {}
}

variable "node_group_tags" {
  description = "Tags applied to the node group resources"
  type        = map(string)
  default     = {}
}
