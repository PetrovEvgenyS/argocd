# Определяем переменную для URL Git-репозитория:
variable "git_source_repoURL" {
  description = "URL Git-репозитория"
  type        = string                    # Тип данных — строка.
}

# Определяем переменную для пути в Git-репозитории:
variable "git_source_path" {
  description = "Путь каталога в Git-репозитории"
  type        = string                    # Тип данных — строка.
  default     = ""                        # Значение по умолчанию — пустая строка.
}

# Определяем переменную для целевой ревизии в Git:
variable "git_source_targetRevision" {
  description = "HEAD или ветка в Git"
  type        = string                    # Тип данных — строка.
  default     = "HEAD"                    # Значение по умолчанию — HEAD.
}