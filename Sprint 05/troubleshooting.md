# Troubleshooting — типовые проблемы с Python CLI и Ansible

## 1. log_parser.py — файл не найден

**Симптом:** `Ошибка: файл '/var/log/nginx/error.log' не найден`

**Причины:**
- Неверный путь к файлу
- Файл называется `error.log.1` (ротированный лог)

**Решение:**
```bash
ls /var/log/nginx/       # посмотреть какие файлы есть
python3 tools/log_parser.py --file /var/log/nginx/error.log.1
```

---

## 2. log_parser.py — Permission denied

**Симптом:** `Ошибка: нет прав на чтение '/var/log/nginx/error.log'`

**Причина:** лог-файл принадлежит root

**Решение:**
```bash
sudo python3 tools/log_parser.py --file /var/log/nginx/error.log
```

---

## 3. Ansible — команда не найдена

**Симптом:** `ansible-playbook: command not found`

**Решение:**
```bash
sudo apt install -y ansible
ansible --version   # проверить установку
```

---

## 4. Ansible — задача упала с ошибкой

**Симптом:** `failed=1` в PLAY RECAP

**Диагностика:**
```bash
# Запустить с подробным выводом
ansible-playbook -i inventory.ini playbook.yml --ask-become-pass -v
```

**Типовые причины:**
- Файл из `files/` не найден → проверить что `ansible/files/myapp-proxy.conf` существует
- Нет прав sudo → убедиться что передал `--ask-become-pass` и ввёл правильный пароль

---

## 5. Nginx не стартует после playbook

**Симптом:** задача `Start and enable Nginx` упала

**Диагностика:**
```bash
sudo nginx -t                        # проверить конфиг
sudo systemctl status nginx          # смотреть ошибку
```

**Типовая причина:** SSL-сертификат не существует (`/etc/nginx/ssl/selfsigned.crt`)

**Решение:** сначала сгенерировать сертификат:
```bash
sudo bash "../Sprint 03/scripts/gen-cert.sh"
```

---

## 6. Idempotency нарушена — changed > 0 при повторном запуске

**Симптом:** второй запуск playbook показывает `changed=1` или больше

**Причина:** что-то изменилось снаружи (файл отредактировали вручную, сервис остановили)

**Диагностика:**
```bash
# Посмотреть что именно изменилось в прошлом запуске
ansible-playbook -i inventory.ini playbook.yml --ask-become-pass -v
# Строки с "changed" покажут что именно Ansible исправил
```
