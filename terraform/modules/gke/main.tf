provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  # Autopilot configuration
  lifecycle {
    ignore_changes = [
      enable_autopilot
    ]
  }
  enable_autopilot = var.enable_autopilot

  # If Autopilot is not enabled, we include node configuration
  dynamic "node_config" {
    for_each = var.enable_autopilot ? [] : [1]
    content {
      machine_type = var.machine_type
    }
  }

  initial_node_count = var.node_count
}

resource "null_resource" "kubeconfig" {
  depends_on = [google_container_cluster.primary]
  
  provisioner "local-exec" {
    command = <<EOT
      gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region ${var.region} --project ${var.project_id}
    EOT
  }
}
