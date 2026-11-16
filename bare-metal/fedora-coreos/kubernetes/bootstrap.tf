# Kubernetes assets (kubeconfig, manifests)
module "bootstrap" {
  source = "git::https://github.com/alxbl/terraform-render-bootstrap.git?ref=f92b8d6c84ba9d839049e733836df3bb8bbe9254"

  cluster_name              = var.cluster_name
  api_servers               = [var.k8s_domain_name]
  service_account_issuer    = var.service_account_issuer
  etcd_servers              = var.controllers.*.domain
  networking                = var.networking
  pod_cidr                  = var.pod_cidr
  service_cidr              = var.service_cidr
  components                = var.components
  container_image_overrides = var.container_image_overrides
}


