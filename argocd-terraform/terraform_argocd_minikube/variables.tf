# Определяем переменную для версии Helm-чарта
variable "chart_version" {
  description = "Версия Helm-чарта ArgoCD: https://github.com/argoproj/argo-helm/releases"  # Описание переменной.
  type        = string                                                                      # Тип данных — строка.
  default     = "9.4.10"                                                                    # Значение по умолчанию.
}