terraform {
  required_version = ">= 1.14.5"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 3.1.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 3.0.1"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
  }
}

variable "kubeconfig_path" {
  description = "Путь к kubeconfig."
  type        = string
  default     = "~/.kube/config"
}

variable "kube_context" {
  description = "Имя kube-context (например dev-cluster или prod-cluster)."
  type        = string
}

# Настраиваем провайдер Helm для работы с Minikube:
provider "helm" {
  kubernetes = {
    config_path    = var.kubeconfig_path # Путь к конфигурационному файлу Minikube.
    config_context = var.kube_context    # Явно выбираем кластер по context.
  }
}

# Настраиваем провайдер Kubernetes для работы с Minikube:
provider "kubernetes" {
  config_path    = var.kubeconfig_path # Путь к конфигурационному файлу Minikube.
  config_context = var.kube_context    # Явно выбираем кластер по context.
}

# Настраиваем провайдер kubectl для применения CRD-ресурсов MetalLB:
provider "kubectl" {
  config_path    = var.kubeconfig_path # Путь к конфигурационному файлу Minikube.
  config_context = var.kube_context    # Явно выбираем кластер по context.
}

# Модуль для развертывания ArgoCD в Minikube для окружения dev:
module "argocd_dev" {
  source        = "./terraform_argocd_minikube"  # Указываем путь к модулю.
  chart_version = "9.4.14"                       # Версия Helm-чарта ArgoCD.
}

# Модуль для развертывания MetalLB в локальном кластере:
module "metallb" {
  source           = "./terraform_metallb_minikube"    # Путь к модулю.
  chart_version    = "0.15.3"                          # Версия Helm-чарта MetalLB.
  ip_range         = "192.168.100.200-192.168.100.250" # Пул адресов для LoadBalancer.
  crd_wait_seconds = "30s"                             # Пауза ожидания регистрации CRD.
}

# # Модуль для развертывания ArgoCD в Minikube для окружения prod:
# module "argocd_prod" {
#   source        = "./terraform_argocd_minikube"  # Указываем путь к модулю.
#   chart_version = "7.8.10"                       # Версия Helm-чарта ArgoCD.
# }

# Модуль для корневого приложения ArgoCD в окружении dev:
module "argocd_dev_root" {
  source             = "./terraform_argocd_root_minikube"        # Путь к модулю.
  git_source_path    = "demo/AppOfApp/applications"              # Путь в Git-репозитории.
  git_source_repoURL = "git@github.com:PetrovEvgenyS/argocd.git" # URL Git-репозитория.
  depends_on         = [module.argocd_dev]                       # Зависимость от модуля argocd_dev.
}

# # Модуль для корневого приложения ArgoCD в окружении prod:
# module "argocd_prod_root" {
#   source             = "./terraform_argocd_root_minikube"        # Путь к модулю.
#   git_source_path    = "demo/AppOfApp/applications"              # Путь в Git-репозитории.
#   git_source_repoURL = "git@github.com:PetrovEvgenyS/argocd.git" # URL Git-репозитория.
#   depends_on         = [module.argocd_prod]                      # Зависимость от модуля argocd_prod.
# }