resource "kubernetes_namespace" "nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

# Install Nginx Ingress using Helm Chart
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
  # TODO: Separate nginx ingresses for public & private
  # https://vincentlauzon.com/2018/11/28/understanding-multiple-ingress-in-aks/
  #set {
  #  name = "kubernetes.io/ingress.class" = "public-nginx"
  #}
}