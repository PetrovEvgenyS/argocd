# Покажет переменные с манифестами:
```bash
helm install --debug --dry-run my-app ./my-app/
```

# Покажет манифесты:
```bash
helm template my-app ./my-app
```

# Используй для запуска:
```bash
helm install my-app ./my-app
```

# Обновление chart:
```bash
helm upgrade my-app ./my-app
```

# Удалить helm:
```bash
helm uninstall my-app ./my-app
```