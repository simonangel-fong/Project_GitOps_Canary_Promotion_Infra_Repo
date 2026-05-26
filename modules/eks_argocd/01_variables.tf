# variable.tf

# ##############################
# ArgoCD chart
# ##############################
variable "chart_version" {
  description = "Version of the argo-cd Helm chart (https://artifacthub.io/packages/helm/argo/argo-cd)"
  type        = string
  default     = "9.5.14"
}

variable "values" {
  description = "Additional Helm values YAML for argo-cd, merged on top of the rendered values.tftpl"
  type        = string
  default     = ""
}

# ##############################
# ArgoCD AppProject
# ##############################
variable "project_name" {
  description = "Name of the ArgoCD AppProject created for the root app-of-apps tree. Scopes sourceRepos to var.gitops_repo_url and destinations to the in-cluster API."
  type        = string
}

# ##############################
# Root Application (app-of-apps)
# ##############################
variable "enable_root_app" {
  description = "Whether to create the root app-of-apps Application after ArgoCD is installed"
  type        = bool
  default     = true
}

variable "gitops_repo_url" {
  description = "Git URL of the GitOps config repo that ArgoCD will sync from"
  type        = string
}

variable "gitops_repo_revision" {
  description = "Git revision (branch, tag, or commit) ArgoCD tracks for the root application"
  type        = string
  default     = "HEAD"
}

variable "gitops_repo_path" {
  description = "Path inside the GitOps repo containing the root app-of-apps manifests"
  type        = string
  default     = "bootstrap"
}

# ##############################
# Notification
# ##############################
variable "enable_notifications" {
  description = "Enable the ArgoCD notifications controller."
  type        = bool
  default     = false
}
