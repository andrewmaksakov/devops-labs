# Troubleshooting — типовые проблемы с дисками и бэкапами

## 1. Нет места на диске

**Симптом:** ошибки "No space left on device"

**Диагностика:**
```bash
df -h              # какой диск заполнен
du -sh /* 2>/dev/null | sort -rh | head -10   # самые большие папки
```

**Решение:**
- Удалить старые логи: `sudo journalctl --vacuum-size=100M`
- Удалить неиспользуемые Docker образы: `docker system prune`
- Найти большие файлы: `find / -size +100M -type f 2>/dev/null`

---

## 2. Бэкап не создаётся — Permission denied

**Симптом:** `tar: Cannot open: Permission denied`

**Причина:** запускаешь без sudo, а бэкапишь системные файлы

**Решение:**
```bash
sudo bash scripts/backup.sh
```

---

## 3. Restore не работает — бэкап пустой или повреждён

**Диагностика:**
```bash
# Проверить что внутри
tar -tzf /var/backups/myapp/backup-*.tar.gz

# Проверить размер (0 = пустой)
ls -lh /var/backups/myapp/
```

**Решение:**
- Использовать предыдущий бэкап: `sudo bash restore.sh /путь/к/предыдущему.tar.gz`

---

## 4. После восстановления Nginx не стартует

**Диагностика:**
```bash
sudo nginx -t
```

**Причины:**
- Сертификат не восстановился → проверить `/etc/nginx/ssl/`
- Конфликт портов → `ss -tlnp | grep :80`

---

## 5. Диск заполнился бэкапами

**Симптом:** `/var/backups/myapp/` занимает много места

**Решение:** ротация уже встроена в `backup.sh` (хранит 7 последних). Но можно почистить вручную:
```bash
ls -lh /var/backups/myapp/
# Удалить конкретный
sudo rm /var/backups/myapp/backup-СТАРЫЙ.tar.gz
```
