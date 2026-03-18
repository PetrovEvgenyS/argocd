# Модуль для развертывания ArgoCD через Helm-чарт в Minikube

Этот модуль устанавливает ArgoCD в локальный кластер Minikube с использованием Helm-чарта.

### Пример использования:

```hcl
module "argocd" {
  source        = "./terraform_argocd_minikube"
  chart_version = "9.4.10"
}