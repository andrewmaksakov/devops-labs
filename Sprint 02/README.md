# Sprint 02 — Процессы, сигналы, systemd, логи

**Цель:** уметь запускать сервис как "на сервере"

**Длительность:** 2 недели

---

## Теория

### Процессы

| Команда | Описание |
|---------|----------|
| `ps aux` | Список всех процессов |
| `ps -ef` | Список процессов (другой формат) |
| `top` / `htop` | Интерактивный мониторинг процессов |
| `pgrep <name>` | Найти PID по имени |
| `kill <PID>` | Отправить сигнал процессу |
| `kill -9 <PID>` | Принудительно убить процесс |
| `nice -n 10 <cmd>` | Запустить с пониженным приоритетом |
| `renice -n 5 -p <PID>` | Изменить приоритет работающего процесса |

### Сигналы

| Сигнал | Номер | Описание |
|--------|-------|----------|
| `SIGTERM` | 15 | Корректное завершение (можно обработать) |
| `SIGKILL` | 9 | Принудительное убийство (нельзя обработать) |
| `SIGHUP` | 1 | Перечитать конфиг (для демонов) |
| `SIGINT` | 2 | Прерывание (Ctrl+C) |
| `SIGSTOP` | 19 | Приостановить процесс |
| `SIGCONT` | 18 | Продолжить процесс |

**Важно:** Всегда сначала `SIGTERM`, потом `SIGKILL`. Даём процессу шанс корректно завершиться.

### systemd

systemd — система инициализации и менеджер сервисов в современных Linux.

**Основные команды:**
```bash
systemctl start <service>      # Запустить
systemctl stop <service>       # Остановить
systemctl restart <service>    # Перезапустить
systemctl status <service>     # Статус
systemctl enable <service>     # Автозапуск при загрузке
systemctl disable <service>    # Отключить автозапуск
systemctl daemon-reload        # Перечитать unit-файлы
```

**Unit-файл (.service):**
```ini
[Unit]
Description=My Application
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 /path/to/app.py
Restart=on-failure
RestartSec=5
User=myuser

[Install]
WantedBy=multi-user.target
```

**Timer-файл (.timer):** — замена cron
```ini
[Unit]
Description=Run myapp every 5 minutes

[Timer]
OnBootSec=1min
OnUnitActiveSec=5min

[Install]
WantedBy=timers.target
```

### Логи (journalctl)

```bash
journalctl                          # Все логи
journalctl -u <service>             # Логи конкретного сервиса
journalctl -u <service> -f          # Follow (как tail -f)
journalctl -u <service> --since "1 hour ago"
journalctl -u <service> -n 50       # Последние 50 строк
journalctl -p err                   # Только ошибки
journalctl -b                       # Логи с текущей загрузки
```

---

## Практические задания

### 1. Создать простой сервис

Скрипт `scripts/myapp.py` — простое приложение, которое:
- Пишет логи каждые 10 секунд
- Корректно обрабатывает SIGTERM
- Работает как демон

### 2. Создать systemd unit-файл

`systemd/myapp.service` — unit-файл для запуска сервиса:
- Автозапуск после загрузки
- Рестарт при падении
- Запуск от непривилегированного пользователя

### 3. Создать systemd timer

`systemd/myapp.timer` — таймер вместо cron:
- Запуск задачи по расписанию

### 4. Документировать типичные проблемы

`troubleshooting.md` — 3 типовых причины "сервис не стартует" и как их решать

---

## Структура папки

```
Sprint 02/
├── README.md
├── scripts/
│   └── myapp.py
├── systemd/
│   ├── myapp.service
│   └── myapp.timer
└── troubleshooting.md
```

---

## Как развернуть

```bash
# 1. Скопировать скрипт
sudo mkdir -p /opt/myapp
sudo cp scripts/myapp.py /opt/myapp/myapp.py
sudo chmod +x /opt/myapp/myapp.py

# 2. Скопировать unit-файлы
sudo cp systemd/myapp.service /etc/systemd/system/
sudo cp systemd/myapp.timer /etc/systemd/system/

# 3. Перечитать конфиги systemd
sudo systemctl daemon-reload

# 4. Запустить и включить автозапуск
sudo systemctl enable --now myapp.service

# 5. Проверить статус
systemctl status myapp.service
journalctl -u myapp.service -f
```

---

## Экзамен (самопроверка)

- [x] `systemctl status myapp` показывает "active (running)"
- [x] `journalctl -u myapp` показывает логи приложения
- [x] После `sudo systemctl stop myapp` — процесс корректно завершается (SIGTERM)
- [x] После `sudo kill -9 <PID>` — процесс убит принудительно
- [x] Могу объяснить разницу между SIGTERM и SIGKILL
- [x] Сервис автоматически перезапускается после падения
