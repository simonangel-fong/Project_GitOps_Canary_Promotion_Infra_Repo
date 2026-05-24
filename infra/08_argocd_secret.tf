# argocd_secret.tf
# ##############################################################
# Argocd: cluster secret
# ##############################################################

resource "kubectl_manifest" "argocd_secret" {
  yaml_body = yamlencode({
    apiVersion = "v1"
    kind       = "Secret"
    metadata = {
      name      = "argocd-secret"
      namespace = "argocd"
      labels = {
        "argocd.argoproj.io/secret-type" = "cluster"
      }
      annotations = {
        "project"                = local.project_name
        "env"                    = var.env
        "aws-region"             = var.aws_region
        "hostname"               = "${local.project_name}-${var.env}.${local.domain}"
        "vpc.vpc-id"             = module.vpc.vpc_id
        "eks.cluster-name"       = module.eks.cluster_name
        "eks.cluster-endpoint"   = module.eks.cluster_endpoint
        "eks.interruption-queue" = module.karpenter.queue_name
        "eso.cloudflare"         = local.eso_param_cloudflare
        "eso.slack"              = local.eso_param_slack
        "eso.role-arn"           = aws_iam_role.eso.arn
        "albc.role-arn"          = aws_iam_role.albc.arn
        "gateway.tls-cert-arn"   = var.tls_cert_arn
        "gateway.alb-name"       = module.eks.cluster_name
      }
    }
    type = "Opaque"
    stringData = {
      name   = "in-cluster"
      server = "https://kubernetes.default.svc"
      config = jsonencode({
        tlsClientConfig = {
          insecure = false
        }
      })
    }
  })

  depends_on = [
    module.eks_argocd,
  ]
}
