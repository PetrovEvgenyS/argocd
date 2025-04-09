# Настраиваем провайдер Helm для работы с Minikube:
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"  # Путь к конфигурационному файлу Minikube.
  }
}

# Настраиваем провайдер Kubernetes для работы с Minikube:
provider "kubernetes" {
  config_path = "~/.kube/config"  # Путь к конфигурационному файлу Minikube.
}

# Модуль для развертывания ArgoCD в Minikube для окружения dev:
module "argocd_dev" {
  source        = "./terraform_argocd_minikube"  # Указываем путь к модулю.
  chart_version = "7.8.20"                       # Версия Helm-чарта ArgoCD.
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