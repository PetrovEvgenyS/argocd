# Явно указываем источник провайдера kubectl для модуля.
# Без этого Terraform ищет hashicorp/kubectl (не существует) вместо gavinbunney/kubectl:
terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
    time = {
      source = "hashicorp/time"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.19.0"
    }
  }
}

# Устанавливаем MetalLB через Helm:
resource "helm_release" "metallb" {
  name             = "metallb"                                     # Имя релиза.
  repository       = "https://metallb.github.io/metallb"          # Официальный Helm-репозиторий MetalLB.
  chart            = "metallb"                                     # Имя чарта.
  namespace        = "metallb-system"                              # Namespace для MetalLB.
  version          = var.chart_version                             # Версия чарта из переменной.
  create_namespace = true                                          # Создаем namespace автоматически.
  timeout          = 300                                           # Тайм-аут ожидания готовности (5 минут).
}

# Ждём, пока CRD MetalLB зарегистрируются в API-сервере после установки Helm-чарта:
resource "time_sleep" "wait_for_crds" {
  depends_on      = [helm_release.metallb]
  create_duration = var.crd_wait_seconds # Пауза перед созданием CRD-ресурсов.
}

# Создаём пул IP-адресов для LoadBalancer-сервисов.
# kubectl_manifest (gavinbunney/kubectl) не валидирует CRD при terraform plan,
# поэтому корректно работает даже до установки MetalLB:
resource "kubectl_manifest" "ip_address_pool" {
  depends_on = [time_sleep.wait_for_crds]

  yaml_body = <<-YAML
    apiVersion: metallb.io/v1beta1
    kind: IPAddressPool
    metadata:
      name: local-pool
      namespace: metallb-system
    spec:
      addresses:
      - ${var.ip_range}
  YAML
}

# Объявляем L2-анонс (ARP) для пула адресов:
resource "kubectl_manifest" "l2_advertisement" {
  depends_on = [kubectl_manifest.ip_address_pool]

  yaml_body = <<-YAML
    apiVersion: metallb.io/v1beta1
    kind: L2Advertisement
    metadata:
      name: local-advertisement
      namespace: metallb-system
    spec:
      ipAddressPools:
      - local-pool
  YAML
}
