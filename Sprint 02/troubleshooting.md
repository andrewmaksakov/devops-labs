# Troubleshooting — типичные проблемы с сервисами

## 1. Сервис не стартует: "Failed to start"

**Симптом:**
```
systemctl status myapp
● myapp.service - My Application
   Active: failed (Result: exit-code)
```

**Причины и решения:**

- **Неверный путь в ExecStart** — проверь что файл существует и путь абсолютный:
  ```bash
  cat /etc/systemd/system/myapp.service | grep ExecStart
  ls -la /путь/к/скрипту
  ```
- **Нет прав на запуск** — сделай файл исполняемым:
  ```bash
  sudo chmod +x /opt/myapp/myapp.py
  ```
- **Ошибка в самом скрипте** — запусти вручную и посмотри вывод:
  ```bash
  python3 /opt/myapp/myapp.py
  ```

---

## 2. Сервис запускается и сразу падает (restart loop)

**Симптом:**
```
systemctl status myapp
● myapp.service
   Active: activating (auto-restart)
```

**Причины и решения:**

- **Ошибка в коде** — смотри логи:
  ```bash
  journalctl -u myapp -n 50 --no-pager
  ```
- **Не хватает зависимостей** (модули Python, пакеты):
  ```bash
  journalctl -u myapp | grep "ModuleNotFoundError"
  pip3 install <нужный_модуль>
  ```
- **Порт уже занят** (если сервис слушает порт):
  ```bash
  ss -tlnp | grep <порт>
  ```

---

## 3. Изменил unit-файл, но ничего не изменилось

**Симптом:** Отредактировал `.service` файл, перезапустил сервис — старое поведение.

**Причина:** systemd кэширует unit-файлы. После любого изменения нужно:
```bash
sudo systemctl daemon-reload
sudo systemctl restart myapp
```

**Проверка** что systemd видит актуальную версию:
```bash
systemctl cat myapp.service
```
