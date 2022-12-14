output "cluster_id" {
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  value       = module.eks.cluster_security_group_id
}

output "kubectl_config" {
  value       = module.eks.kubeconfig
}

output "config_map_aws_auth" {
  value       = module.eks.config_map_aws_auth
}

output "region" {
  value       = var.region
}

output "cluster_name" {
  value       = local.cluster_name
}

#data "kubernetes_ingress_v1" "nginx_ingress" {
#  metadata {
#    name = "nginx-ingress"
#    namespace = "ingress-nginx"
#  }
#}

#output "load_balancer_hostname" {
#  value = data.kubernetes_ingress_v1.nginx_ingress.status
#}

#output "load_balancer_ip" {
#  value = data.kubernetes_ingress_v1.nginx_ingress.status
#}