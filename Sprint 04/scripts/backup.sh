#!/bin/bash
# Бэкап конфигов: Nginx + systemd unit + данные сервиса
# Хранит 7 последних бэкапов (ротация)

set -euo pipefail

BACKUP_DIR="/var/backups/myapp"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup-$TIMESTAMP.tar.gz"
MAX_BACKUPS=7

# Что бэкапим
BACKUP_PATHS=(
    "/etc/nginx/sites-available"
    "/etc/nginx/ssl"
)

# Добавляем systemd unit если существует
[[ -f /etc/systemd/system/myapp.service ]] && BACKUP_PATHS+=("/etc/systemd/system/myapp.service")
[[ -f /etc/systemd/system/myapp.timer ]] && BACKUP_PATHS+=("/etc/systemd/system/myapp.timer")

# Создаём директорию для бэкапов
sudo mkdir -p "$BACKUP_DIR"

# Проверяем что пути существуют
EXISTING_PATHS=()
for path in "${BACKUP_PATHS[@]}"; do
    if [[ -e "$path" ]]; then
        EXISTING_PATHS+=("$path")
    else
        echo "Пропускаю (не существует): $path"
    fi
done

if [[ ${#EXISTING_PATHS[@]} -eq 0 ]]; then
    echo "Нечего бэкапить — ни один путь не существует"
    exit 1
fi

# Создаём архив
sudo tar -czf "$BACKUP_FILE" "${EXISTING_PATHS[@]}"
echo "Бэкап создан: $BACKUP_FILE"
echo "Размер: $(du -h "$BACKUP_FILE" | cut -f1)"
echo "Содержимое:"
tar -tzf "$BACKUP_FILE"

# Ротация: удаляем старые бэкапы, оставляем MAX_BACKUPS последних
BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/backup-*.tar.gz 2>/dev/null | wc -l)
if [[ $BACKUP_COUNT -gt $MAX_BACKUPS ]]; then
    REMOVE_COUNT=$((BACKUP_COUNT - MAX_BACKUPS))
    ls -1t "$BACKUP_DIR"/backup-*.tar.gz | tail -n "$REMOVE_COUNT" | while read -r old; do
        sudo rm -f "$old"
        echo "Удалён старый бэкап: $old"
    done
fi

echo ""
echo "Всего бэкапов: $(ls -1 "$BACKUP_DIR"/backup-*.tar.gz | wc -l) (макс: $MAX_BACKUPS)"
