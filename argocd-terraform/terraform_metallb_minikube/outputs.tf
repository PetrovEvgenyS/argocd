# Версия установленного чарта MetalLB:
output "metallb_chart_version" {
  description = "Версия установленного Helm-чарта MetalLB."
  value       = helm_release.metallb.metadata.chart
}

# Статус Helm-релиза:
output "metallb_status" {
  description = "Статус Helm-релиза MetalLB."
  value       = helm_release.metallb.status
}

# Используемый диапазон IP-адресов:
output "metallb_ip_range" {
  description = "Диапазон IP-адресов пула MetalLB."
  value       = var.ip_range
}
