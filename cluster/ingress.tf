resource "kubernetes_service_v1" "nginx_service" {
  metadata {
    name = "nginx-service"
  }
  spec {
    selector = {
      app = kubernetes_pod_v1.example.metadata.0.labels.app
    }  
    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }
    type = "NodePort"
  }
}

resource "kubernetes_pod_v1" "example" {
  metadata {
    name = "nginx-default"
    labels = {
      app = "nginx-default"
    }
  }

  spec {
    container {
      image = "nginx:1.21.6"
      name  = "example"

      port {
        container_port = 80
      }
    }
  }
}

resource "kubernetes_namespace" "ingress-nginx" {
  metadata {
    labels = {
      app = "ingress-nginx"
    }
    name = "ingress-nginx"
  }
}

resource "kubernetes_ingress_v1" "nginx_ingress" {
  metadata {
    name = "nginx-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "nginx.ingress.kubernetes.io/ssl-passthrough" = "true"
    }
  }
  
  spec {
    ingress_class_name = "nginx"
    tls {
      secret_name = "timeoff-tls"
    }
    rule {
      http {
        path {
          path = "/nginx"
          backend {
            service {
              name = kubernetes_service_v1.nginx_service.metadata.0.name
              port {
                number = 80
              }
            }
          }
        }
        path {
          path = "/"
          backend {
            service {
              name = "timeoff"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

