# Troubleshooting — типовые сетевые проблемы

## 1. curl: (7) Failed to connect — Connection refused

**Симптом:** `curl http://localhost` → Connection refused

**Причина:** на этом порту никто не слушает.

**Диагностика:**
```bash
ss -tlnp | grep 80
```

**Решение:**
- Сервис не запущен → `sudo systemctl start nginx`
- Сервис слушает другой порт → проверь конфиг
- Сервис слушает на 127.0.0.1 а ты стучишь по внешнему IP → поменяй `listen` на `0.0.0.0`

---

## 2. 502 Bad Gateway

**Симптом:** Nginx отвечает, но показывает "502 Bad Gateway"

**Причина:** Nginx работает, но не может достучаться до backend.

**Диагностика:**
```bash
# Проверить что backend жив
ss -tlnp | grep 8000

# Посмотреть логи Nginx
sudo tail -20 /var/log/nginx/error.log
```

**Решение:**
- Backend не запущен → запустить его
- Backend на другом порту → исправить `proxy_pass` в конфиге Nginx
- Backend упал → посмотреть его логи (`journalctl -u myapp`)

---

## 3. 504 Gateway Timeout

**Симптом:** запрос висит долго, потом Nginx отвечает "504"

**Причина:** backend получил запрос, но не ответил вовремя (завис, долгий запрос к БД).

**Диагностика:**
```bash
# Проверить что backend жив но тормозит
curl -v http://127.0.0.1:8000   # напрямую к backend

# Логи
sudo tail -20 /var/log/nginx/error.log
```

**Решение:**
- Backend тормозит → оптимизировать или увеличить таймаут в Nginx:
  ```nginx
  proxy_read_timeout 60s;
  ```
- Зависший процесс → перезапустить backend

---

## 4. SSL: certificate verify failed

**Симптом:** `curl https://localhost` → SSL certificate problem: self-signed certificate

**Причина:** self-signed сертификат не подписан доверенным CA.

**Решение:**
- Для тестов: `curl -k https://localhost` (флаг `-k` игнорирует проверку)
- Для прода: использовать Let's Encrypt (бесплатные сертификаты от настоящего CA)

---

## 5. DNS не резолвится

**Симптом:** `dig example.com` → пусто или SERVFAIL

**Диагностика:**
```bash
# Проверить какой DNS-сервер используется
cat /etc/resolv.conf

# Попробовать другой DNS-сервер
dig @8.8.8.8 example.com
```

**Решение:**
- DNS-сервер недоступен → поменять `nameserver` в `/etc/resolv.conf`
- В WSL: бывает что resolv.conf перезаписывается → проверить `/etc/wsl.conf`

---

## 6. nginx -t выдаёт ошибку

**Симптом:** `sudo nginx -t` → ошибка синтаксиса

**Типичные причины:**
```
# Забыл точку с запятой
proxy_pass http://127.0.0.1:8000     ← нет ;

# Файл сертификата не существует
ssl_certificate /etc/nginx/ssl/selfsigned.crt;   ← файл не создан

# Дублирующийся listen
listen 80;   ← в двух конфигах одновременно
```

**Решение:**
```bash
sudo nginx -t   # покажет строку с ошибкой
# Исправить конфиг → повторить nginx -t → restart
```
