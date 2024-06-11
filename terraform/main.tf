provider "google" {
  project = var.project_id
  region  = var.region
  alias   = "gcp"
}

# provider "aws" {
#   # Configuration for AWS
#   alias = "aws"
# }

# provider "azurerm" {
#   # Configuration for Azure
#   alias = "azure"
# }

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

module "gke_cluster" {
  source = "./modules/gke"

# The configuration of module.gke_cluster has its own local configuration for google, and so it cannot accept an overridden configuration provided by the root module.

  # providers = {
  #   google  = google.gcp
  #   aws     = aws.aws
  #   azurerm = azurerm.azure
  # }

  project_id      = var.project_id
  region          = var.region
  cluster_name    = var.cluster_name
  node_count      = var.node_count
  machine_type    = var.machine_type
  enable_autopilot = var.enable_autopilot

  # Only create this module if cloud_provider is "gke"
#  count = var.cloud_provider == "gke" ? 1 : 0


}

# module "eks_cluster" {
#   source = "./modules/eks"

#   providers = {
#     aws = aws.aws
#   }

#   project_id      = var.project_id
#   region          = var.region
#   cluster_name    = var.cluster_name
#   node_count      = var.node_count
#   machine_type    = var.machine_type

#   # Only create this module if cloud_provider is "eks"
#   count = var.cloud_provider == "eks" ? 1 : 0
# }

# module "aks_cluster" {
#   source = "./modules/aks"

#   providers = {
#     azurerm = azurerm.azure
#   }

#   project_id      = var.project_id
#   region          = var.region
#   cluster_name    = var.cluster_name
#   node_count      = var.node_count
#   machine_type    = var.machine_type

#   # Only create this module if cloud_provider is "aks"
#   count = var.cloud_provider == "aks" ? 1 : 0
# }

module "nginx_ingress" {
  source             = "./modules/nginx-ingress"
  namespace          = var.namespace
  ingress_class_name = var.ingress_class_name

  # Pass the kubeconfig from the selected cluster module to the nginx ingress module
  kubeconfig = module.gke_cluster.kubeconfig
}
