# Выводим версию приложения ArgoCD:
output "argocd_version" {
  description = "Получаем версию приложения из метаданных Helm-релиза"
  value = helm_release.argocd.metadata.app_version
}

# Выводим ревизию Helm-релиза:
output "helm_revision" {
  description = "Получаем номер ревизии из метаданных Helm-релиза"
  value = helm_release.argocd.metadata.revision
}

# Выводим версию чарта:
output "chart_version" {
  description = "Получаем версию чарта из метаданных Helm-релиза"
  value = helm_release.argocd.metadata.version
}