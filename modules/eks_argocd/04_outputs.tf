# outputs.tf
output "namespace" { value = helm_release.argocd.namespace }
output "release_name" { value = helm_release.argocd.name }
output "chart_version" { value = helm_release.argocd.version }
output "root_app_name" {
  value = var.enable_root_app ? var.root_app_name : null
}
