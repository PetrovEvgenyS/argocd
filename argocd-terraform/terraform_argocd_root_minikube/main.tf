# Создаем манифест Kubernetes для корневого приложения ArgoCD:
resource "kubernetes_manifest" "argocd_root" {
  manifest = yamldecode(templatefile("${path.module}/root.yaml", {  # Декодируем YAML-файл с подстановкой переменных.
    repoURL        = var.git_source_repoURL                         # Передаем URL Git-репозитория.
    path           = var.git_source_path                            # Путь в репозиторий до нужного каталога с манифестами.
    targetRevision = var.git_source_targetRevision                  # Ветка, тег или коммит, из которого брать манифесты.
  }))
}