# Версия Helm-чарта MetalLB:
variable "chart_version" {
  description = "Версия Helm-чарта MetalLB: https://github.com/metallb/metallb/releases"
  type        = string
  default     = "0.15.3"
}

# Диапазон IP-адресов для пула LoadBalancer:
variable "ip_range" {
  description = "Диапазон IP-адресов для MetalLB IPAddressPool (например, 192.168.100.200-192.168.100.250)."
  type        = string
  default     = "192.168.100.200-192.168.100.250"
}

# Пауза ожидания регистрации CRD после установки Helm-чарта:
variable "crd_wait_seconds" {
  description = "Время ожидания регистрации CRD MetalLB после установки Helm-чарта (например, '30s')."
  type        = string
  default     = "30s"
}
