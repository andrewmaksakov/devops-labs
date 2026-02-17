# DevOps Labs

16-недельный курс обучения DevOps — 8 спринтов по 2 недели.

## Структура репозитория

```
devops-labs/
├── Sprint 01/   # Терминал, SSH, Git, базовый Bash
├── Sprint 02/   # Процессы, сигналы, systemd, логи
├── Sprint 03/   # Сеть: порты, DNS, HTTP, TLS
├── Sprint 04/   # Диски, файловые системы, бэкапы
├── Sprint 05/   # Автоматизация: Bash + Python + Ansible
├── Sprint 06/   # Docker: образы, контейнеры, Compose
├── Sprint 07/   # CI/CD: сборка, деплой, rollback
└── Sprint 08/   # Kubernetes + наблюдаемость
```

## Definition of Done (DoD)

Каждый спринт считается завершённым, когда:
1. Можно поднять всё по README с нуля
2. Сломать специально → починить → записать шаги в `troubleshooting.md`
3. Коротко объяснить *почему* так

---

## План обучения

### Sprint 01 — Терминал, SSH, Git, базовый Bash
**Цель:** комфортно работать в Linux и не бояться консоли

**Практика:**
- Ubuntu Server (VM или WSL)
- SSH по ключам
- Bash: пайпы, редиректы, exit code, `grep`, `cut`, `sort`, `uniq`, `awk`
- Git: commit, branch, merge

**Артефакты:**
- `scripts/collect_sysinfo.sh` — вывод CPU/RAM/disk/network
- `scripts/log_grep.sh` — фильтр логов по шаблону
- `README.md` — как подключиться и запустить

**Статус:** ✅ Завершён

---

### Sprint 02 — Процессы, сигналы, systemd, логи
**Цель:** уметь запускать сервис как "на сервере"

**Практика:**
- Процессы: `ps`, `top/htop`, `nice/renice`, `kill`, SIGTERM vs SIGKILL
- Логи: `journalctl`, фильтрация по юниту
- systemd: unit-файл, автозапуск, рестарт политики

**Артефакты:**
- Простой сервис (Python http.server или скрипт с логами)
- `myapp.service` и `myapp.timer`
- `troubleshooting.md` — 3 типовых причины "не стартует"

**Статус:** ✅ Завершён

---

### Sprint 03 — Сеть: порты, DNS, HTTP, TLS, диагностика
**Цель:** чинить "не открывается сайт / не ходит запрос"

**Практика:**
- Инструменты: `ip`, `ss`, `curl`, `dig`, `traceroute`, `tcpdump`
- DNS: A/AAAA/CNAME, TTL
- HTTP: коды, заголовки, редиректы
- TLS: сертификаты

**Артефакты:**
- Nginx как reverse proxy
- HTTPS на self-signed сертификате
- `network-cheatsheet.md` — 10 команд "проверить сеть"

**Статус:** ✅ Завершён

---

### Sprint 04 — Диски, файловые системы, бэкапы
**Цель:** защитить данные и уметь восстановиться

**Практика:**
- `lsblk`, `df -h`, `du -sh`, `mount`, `fstab`
- Page cache (на бытовом уровне)

**Артефакты:**
- `backup.sh` — архивирование + ротация (7 последних)
- `restore.sh` — восстановление
- Учение: удалить конфиги → восстановить

**Статус:** ⬜ Не начат

---

### Sprint 05 — Автоматизация: Bash + Python CLI + Ansible
**Цель:** "одной командой развернуть сервер"

**Практика:**
- Python CLI: аргументы, чтение файлов, парсинг логов
- Ansible: inventory, playbook, idempotency

**Артефакты:**
- `tools/log_parser.py` — топ ошибок по паттернам
- Ansible playbook: Nginx + конфиг + systemd unit + запуск

**Статус:** ⬜ Не начат

---

### Sprint 06 — Docker: образ, контейнер, volumes, сети + Compose
**Цель:** уметь контейнеризировать и поднимать окружение

**Практика:**
- Dockerfile: слои, ENV, healthcheck
- Compose: несколько сервисов, сеть, volume

**Артефакты:**
- `Dockerfile` для сервиса
- `compose.yml` — сервис + Nginx (+ опционально Postgres)
- `README.md` — одна команда для старта

**Статус:** ⬜ Не начат

---

### Sprint 07 — CI/CD: сборка образа + деплой на VM + rollback
**Цель:** "коммит → работает на сервере"

**Практика:**
- GitHub Actions: build → test → docker build → push
- Деплой на VM: pull образа → restart

**Артефакты:**
- `.github/workflows/ci.yml`
- `deploy.sh` или ansible deploy playbook
- Rollback: теги версий и откат

**Статус:** ⬜ Не начат

---

### Sprint 08 — Kubernetes база + наблюдаемость
**Цель:** понять k8s и уметь "посмотреть что происходит"

**Практика:**
- kind/minikube
- Deployment/Service/Ingress, ConfigMap/Secret
- readiness/liveness probes, limits/requests

**Артефакты:**
- `k8s/` — манифесты
- `runbook.md` — "если сервис недоступен — что проверять"
- Метрики/логи на базовом уровне

**Статус:** ⬜ Не начат

---

## Инструменты

- **ОС:** Ubuntu 24.04 (WSL2 на Windows)
- **Контейнеры:** Docker
- **Оркестрация:** Kubernetes (kubectl, helm)
- **IaC:** Terraform, Ansible
- **CI/CD:** GitHub Actions
