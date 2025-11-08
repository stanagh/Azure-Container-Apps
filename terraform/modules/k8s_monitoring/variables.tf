variable "prometheus_release_name" {
  description = "The name of the Prometheus Helm release"
  type        = string

}

variable "prometheus_repository" {
  description = "The Helm repository URL for Prometheus"
  type        = string
  default     = "https://prometheus-community.github.io/helm-charts"
}

variable "prometheus_chart" {
  description = "The name of the Prometheus Helm chart to deploy"
  type        = string
  default     = "kube-prometheus-stack"

}

variable "create_namespace" {
  description = "Whether to create the Kubernetes namespace for the monitoring stack"
  type        = bool
  default     = true
}

variable "grafana_repository" {
  description = "The Helm repository URL for Grafana"
  type        = string
  default     = "https://grafana.github.io/helm-charts"
}

variable "grafana_chart" {
  description = "The name of the Grafana Helm chart to deploy"
  type        = string
  default     = "grafana"

}

variable "grafana_release_name" {
  description = "The name of the Grafana Helm release"
  type        = string

}
variable "grafana_admin_password" {
  description = "The admin password for Grafana"
  type        = string
  sensitive   = true
}

variable "namespace" {
  description = "The Kubernetes namespace to deploy the monitoring stack"
  type        = string

}

variable "nginx_release_name" {
  description = "The name of the NGINX Ingress Helm release"
  type        = string
  default     = "nginx-ingress"
}

variable "nginx_repository" {
  description = "The Helm repository URL for NGINX Ingress"
  type        = string
  default     = "https://kubernetes.github.io/ingress-nginx"
}

variable "nginx_chart" {
  description = "The name of the NGINX Ingress Helm chart to deploy"
  type        = string
  default     = "ingress-nginx"
}

variable "nginx_ingress_namespace" {
  description = "The Kubernetes namespace for the NGINX Ingress controller"
  type        = string
  default     = "ingress"
}