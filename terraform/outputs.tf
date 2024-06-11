output "kubeconfig" {
  description = "Kubeconfig for the Kubernetes cluster"
  value       = module.gke_cluster.kubeconfig
}

output "nginx_ingress_ip" {
  description = "Instructions to get the Nginx Ingress controller's IP"
  value       = "Use 'kubectl get services' to get the Nginx Ingress controller's IP."
}
