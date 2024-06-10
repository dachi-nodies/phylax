# Define the provider
provider "kubernetes" {
  config_context_cluster   = "YOUR_CLUSTER_NAME"
}

# Create a namespace
resource "kubernetes_namespace" "example" {
  metadata {
    name = "example"
  }
}

# Create a service account
resource "kubernetes_service_account" "nginx_ingress_serviceaccount" {
  metadata {
    name      = "nginx-ingress-serviceaccount"
    namespace = kubernetes_namespace.example.metadata[0].name
  }
}

# Create a deployment
resource "kubernetes_deployment" "nginx_ingress_controller" {
  metadata {
    name      = "nginx-ingress-controller"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx-ingress-lb"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx-ingress-lb"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.nginx_ingress_serviceaccount.metadata[0].name

        container {
          name  = "nginx-ingress-controller"
          image = "nginx/nginx-ingress:latest"

          args = [
            "/nginx-ingress-controller",
            "--configmap=$(POD_NAMESPACE)/nginx-configuration",
            "--tcp-services-configmap=$(POD_NAMESPACE)/tcp-services",
            "--udp-services-configmap=$(POD_NAMESPACE)/udp-services",
            "--annotations-prefix=nginx.ingress.kubernetes.io"
          ]

          env {
            name  = "POD_NAME"
            value = metadata.name
          }

          env {
            name  = "POD_NAMESPACE"
            value = metadata.namespace
          }

          volume_mount {
            name       = "nginx-html"
            mount_path = "/usr/share/nginx/html"
            read_only  = true
          }
        }
      }
    }
  }
}

# Create a service
resource "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "nginx-ingress"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    selector = {
      app = "nginx-ingress-lb"
    }

    port {
      name       = "http"
      port       = 80
      target_port = 80
    }

    port {
      name       = "https"
      port       = 443
      target_port = 443
    }
  }
}

# Create a config map
resource "kubernetes_config_map" "nginx_config" {
  metadata {
    name      = "nginx-config"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  data = {
    "index.html" = <<-EOT
      <!DOCTYPE html>
      <html>
      <head>
      <title>Welcome to Nginx</title>
      </head>
      <body>
      <h1>Hello, Tommy Ho <> Phylax</h1>
      </body>
      </html>
    EOT
  }
}

# Create an ingress controller
resource "kubernetes_ingress" "nginx_ingress" {
  metadata {
    name      = "nginx-ingress"
    namespace = kubernetes_namespace.example.metadata[0].name

    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    rule {
      host = "example.com"

      http {
        path {
          path = "/"
          backend {
            service_name = kubernetes_service.nginx_ingress.metadata[0].name
            service_port = kubernetes_service.nginx_ingress.spec[0].port[0].port
          }
        }
      }
    }
  }
}

