output "kubeconfig" {
  description = "Instructions to get the Kubeconfig for the GKE cluster"
  value       = "Use 'gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region ${var.region} --project ${var.project_id}' to get the kubeconfig."
}