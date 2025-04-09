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
4. Доступ к Git-репозиторию с манифестами приложений.

## Использование
1. Запустите кластер Kubernetes в Minikube:
    - `minikube start --driver=hyperv --nodes=3 --cpus=4 --memory=4g`.
2. Инициализируйте Terraform: `terraform init`.
3. Примените конфигурацию: `terraform apply`.
4. Сгенерировать ключи `ssh-keygen -t ed25519`.
    - Public key в GitHub.
    - Privat key в ArgoCD.


Проброс до ArgoCD, доступный по `127.0.0.1:8002`:
```bash
kubectl port-forward svc/argocd-server -n argocd 8002:443
```

Получение пароля от пользователя `admin` ArgoCD:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Удаление ArgoCD:
```bash
helm uninstall argocd -n argocd
kubectl delete namespace argocd
```