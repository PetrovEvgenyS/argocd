# Модуль для развертывания корневого приложения ArgoCD в Minikube

Этот модуль настраивает корневое приложение (`application`) ArgoCD, которое отслеживает и разворачивает приложения из Git-репозитория в Minikube.

### Пример использования:

```hcl
module "argocd_root" {
  source             = "./terraform_argocd_root_minikube"
  git_source_path    = "demo/AppOfApp/applications"
  git_source_repoURL = "git@github.com:PetrovEvgenyS/argocd.git"
}
```
