#!/bin/bash
# Восстановление конфигов из бэкапа
# Использование:
#   sudo bash restore.sh                   # из последнего бэкапа
#   sudo bash restore.sh /путь/к/backup.tar.gz   # из конкретного

set -euo pipefail

BACKUP_DIR="/var/backups/myapp"

# Определяем какой бэкап использовать
if [[ $# -ge 1 ]]; then
    BACKUP_FILE="$1"
else
    # Берём последний бэкап
    BACKUP_FILE=$(ls -1t "$BACKUP_DIR"/backup-*.tar.gz 2>/dev/null | head -1)
fi

if [[ -z "$BACKUP_FILE" || ! -f "$BACKUP_FILE" ]]; then
    echo "Бэкап не найден!"
    echo "Доступные бэкапы:"
    ls -lh "$BACKUP_DIR"/backup-*.tar.gz 2>/dev/null || echo "  (нет бэкапов)"
    exit 1
fi

echo "Восстанавливаю из: $BACKUP_FILE"
echo "Содержимое:"
tar -tzf "$BACKUP_FILE"
echo ""

# Распаковываем в корень (пути в архиве абсолютные)
sudo tar -xzf "$BACKUP_FILE" -C /

# Восстанавливаем симлинк Nginx (tar не сохраняет симлинки из sites-enabled)
if [[ -f /etc/nginx/sites-available/myapp ]]; then
    sudo ln -sf /etc/nginx/sites-available/myapp /etc/nginx/sites-enabled/myapp
fi

# Перечитываем конфиги
sudo nginx -t && sudo systemctl reload nginx
echo "Nginx: конфиг проверен и перезагружен"

if [[ -f /etc/systemd/system/myapp.service ]]; then
    sudo systemctl daemon-reload
    echo "systemd: конфиги перечитаны"
fi

echo ""
echo "Восстановление завершено!"
