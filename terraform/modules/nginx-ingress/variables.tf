variable "ingress_class_name" {
  description = "The class name of the ingress controller"
  type        = string
  default     = "nginx"
}

variable "namespace" {
  description = "The namespace to deploy resources"
  type        = string
  default     = "default"
}

variable "kubeconfig" {
  description = "Kubeconfig for the Kubernetes cluster"
  type        = string
}