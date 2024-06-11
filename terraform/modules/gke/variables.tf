variable "machine_type" {
  description = "The machine type for the GKE cluster nodes"
  type        = string
  default     = "e2-medium"
}

variable "enable_autopilot" {
  description = "Enable Autopilot mode for the GKE cluster"
  type        = bool
  default     = true
}

variable "project_id" {
  description = "The project ID to deploy the cluster"
  type        = string
}

variable "region" {
  description = "The region to deploy the cluster"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = "my-gke-cluster"
}

variable "node_count" {
  description = "The number of nodes in the cluster"
  type        = number
  default     = 3
}