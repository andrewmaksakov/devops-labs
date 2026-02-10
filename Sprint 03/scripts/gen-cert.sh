#!/bin/bash
# Генерация self-signed TLS сертификата для localhost
# Сертификат будет валиден 365 дней

set -euo pipefail

CERT_DIR="/etc/nginx/ssl"
CERT_FILE="$CERT_DIR/selfsigned.crt"
KEY_FILE="$CERT_DIR/selfsigned.key"

# Создаём директорию если нет
sudo mkdir -p "$CERT_DIR"

# Генерируем ключ + сертификат одной командой
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout "$KEY_FILE" \
  -out "$CERT_FILE" \
  -subj "/C=RU/ST=Moscow/L=Moscow/O=DevOps-Lab/CN=localhost"

# Выставляем права (ключ — только root)
sudo chmod 600 "$KEY_FILE"
sudo chmod 644 "$CERT_FILE"

echo "Сертификат: $CERT_FILE"
echo "Ключ:       $KEY_FILE"
echo "Срок:       365 дней"
