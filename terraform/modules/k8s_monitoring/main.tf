resource "helm_release" "prometheus" {
  name             = var.prometheus_release_name
  repository       = var.prometheus_repository
  chart            = var.prometheus_chart
  create_namespace = var.create_namespace
  namespace        = var.namespace
  set = [
    {
      name  = "prometheus.ingress.enabled"
      value = "true"
    },
    {
      name  = "prometheus.ingress.hosts[0]"
      value = "prometheus.example.com"
    }, 
    {
      name  = "service.type"
      value = "LoadBalancer" # optional
    }
  ]
}

resource "helm_release" "nginx_ingress" {
  name             = var.nginx_release_name
  repository       = var.nginx_repository
  chart            = var.nginx_chart
  namespace        = var.nginx_ingress_namespace
  create_namespace = true
}

resource "helm_release" "grafana" {
  name             = var.grafana_release_name
  repository       = var.grafana_repository
  chart            = var.grafana_chart
  create_namespace = var.create_namespace
  namespace        = var.namespace
  set = [
    {
      name  = "ingress.enabled"
      value = "true"
    },
    {
      name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
      value = "nginx"
    },
    {
      name  = "ingress.hosts[0]"
      value = "grafana.example.com"
    },
    {
      name  = "adminPassword"
      value = var.grafana_admin_password
    }
  ]
}
