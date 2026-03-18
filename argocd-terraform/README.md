# Развертывание ArgoCD в Minikube с помощью Terraform

Этот проект позволяет развернуть ArgoCD в локальном кластере Minikube с использованием Terraform. Он включает:
- Установку ArgoCD через Helm-чарт.
- Настройку корневого приложения в ArgoCD.

## Структура проекта
- `deploy_argocd.tf` — основной файл для развертывания ArgoCD и корневого приложения.
- `terraform_argocd_minikube` — модуль для установки ArgoCD в Minikube.
- `terraform_argocd_root_minikube` — модуль для настройки корневого приложения.

## Требования
1. Установленный [Minikube v1.35.0](https://github.com/kubernetes/minikube/releases/tag/v1.35.0).
2. Установленный [Terraform](https://developer.hashicorp.com/terraform/install).
3. Установленный [Kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl).
4. Установленный [helm v3.17.2](https://github.com/helm/helm/releases/tag/v3.17.2).
4. Доступ к Git-репозиторию с манифестами приложений.

## Настройка зеркала провайдеров (Yandex Cloud)
Terraform читает CLI-конфиг из `~/.terraformrc` (домашняя директория пользователя).

1. Создайте файл `~/.terraformrc`:
```hcl
provider_installation {
  network_mirror {
    url     = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```

2. Проверка:
```bash
cat ~/.terraformrc
```

## Использование
1. Проверьте доступные контексты Minikube:
```bash
kubectl config get-contexts
```

2. Инициализируйте Terraform:
```bash
rm -rf .terraform .terraform.lock.hcl
terraform init
```

3. План и деплой в `dev-cluster`:
```bash
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
```

4. План и деплой в `prod-cluster`:
```bash
terraform plan -var-file=prod.tfvars
terraform apply -var-file=prod.tfvars
```

5. (Опционально) Сгенерируйте SSH-ключ:
```bash
ssh-keygen -t ed25519
```
- Публичный ключ добавьте в GitHub.
- Приватный ключ используйте в ArgoCD.


Проброс до ArgoCD, доступный по `127.0.0.1:8002`:
```bash
kubectl port-forward svc/argocd-server -n argocd 8002:443
```

Получение пароля от пользователя `admin` ArgoCD:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Удаление ArgoCD через Terraform (`dev-cluster`):
```bash
terraform destroy -var-file=dev.tfvars
```

Удаление ArgoCD через Terraform (`prod-cluster`):
```bash
terraform destroy -var-file=prod.tfvars
```

Проверка после удаления:
```bash
kubectl get ns argocd
helm list -A | grep argocd
```

Ручная очистка (если ресурсы остались):
```bash
helm uninstall argocd -n argocd
kubectl delete namespace argocd
```