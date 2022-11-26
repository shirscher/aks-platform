#
# Nginx Ingress 
#
resource "kubernetes_namespace" "nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

# To use an internal load balancer the AKS cluster identity requires the 'Network Contributor' role on the subnet.
# https://learn.microsoft.com/en-us/azure/aks/configure-kubenet#prerequisites
resource "azurerm_role_assignment" "cluster_subnet_contrib" {
  principal_id         = var.aks_cluster_identity_principal_id
  role_definition_name = "Network Contributor"
  scope                = var.node_pool_subnet_id
}

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  namespace  = kubernetes_namespace.nginx.metadata[0].name
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  set {
    name  = "controller.replicaCount"
    value = "3"
  }
  set {
    name  = "controller.nodeSelector.kubernetes\\.io/os"
    value = "linux"
  }
  set {
    name  = "controller.admissionWebhooks.patch.nodeSelector.kubernetes\\.io/os"
    value = "linux"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
    value = "/healthz"
  }
  set {
    name  = "defaultBackend.nodeSelector.kubernetes\\.io/os"
    value = "linux"
  }
  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }

  # Use an internal load balancer IP instead of public
  # https://learn.microsoft.com/en-us/azure/aks/ingress-basic?tabs=azure-cli#use-an-internal-ip-address
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-internal"
    value = "true"
  }

  # TODO: Separate nginx ingresses for public & private
  # https://vincentlauzon.com/2018/11/28/understanding-multiple-ingress-in-aks/
  #set {
  #  name = "kubernetes.io/ingress.class" = "public-nginx"
  #}
}
