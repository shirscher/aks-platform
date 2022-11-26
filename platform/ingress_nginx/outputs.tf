# This doesn't work, it appears the new helm implementation doesn't wait for the ip: https://github.com/helm/helm/pull/7530

# To grab the load balancer IP address we need to get the IP assigned to the nginx ingress service
# data "kubernetes_service" "service_ingress" {
#   metadata {
#     name      = "nginx-ingress-controller"
#     namespace = "nginx-ingress"
#   }

#   depends_on = [helm_release.ingress_nginx]
# }

# output "load_balancer_ip" {
#   value = try(data.kubernetes_service.service_ingress.status.0.load_balancer.0.ingress.0.ip, "")
# }

data "external" "loadbalancer_service_ip" {
  program = ["sh", "${path.module}/get-service-ip.sh" ]
  depends_on = [helm_release.ingress_nginx]
}

output "load_balancer_ip" {
  value = data.external.loadbalancer_service_ip.result.ip
}