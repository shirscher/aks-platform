resource "local_file" "kubeconfig" {
  content = var.kubeconfig
  #filename = "${path.root}/kubeconfig"
  filename  = pathexpand("~/.kube/config")
}

resource "kubernetes_namespace" "nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  namespace  = kubernetes_namespace.nginx.metadata[0].name
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"

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
}