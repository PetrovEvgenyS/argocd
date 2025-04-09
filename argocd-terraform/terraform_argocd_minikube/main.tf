# Создаем Helm-релиз для установки ArgoCD:
resource "helm_release" "argocd" {
  name             = "argocd"                               # Задаем имя релиза.
  repository       = "https://argoproj.github.io/argo-helm" # Указываем официальный репозиторий Helm-чартов ArgoCD.
  chart            = "argo-cd"                              # Указываем имя чарта (официальное название).
  namespace        = "argocd"                               # Указываем namespace для установки ArgoCD.
  version          = var.chart_version                      # Указываем версию чарта из переменной.
  create_namespace = true                                   # Автоматически создаем namespace, если он не существует.
  values           = [file("${path.module}/argocd.yaml")]   # Применяем настройки из файла argocd.yaml.
  timeout          = 600                                    # Увеличиваем тайм-аут до 600 секунд (10 минут).
}