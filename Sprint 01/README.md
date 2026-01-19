# Sprint 01 — Терминал, SSH, Git, базовый Bash

**Цель:** комфортно работать в Linux и не бояться консоли.

**Длительность:** 2 недели

## Чему научишься

- Работать с VM Ubuntu Server
- Настраивать SSH-доступ по ключам
- Bash-основы: пайпы, редиректы, exit codes
- Git: commit, branch, merge

## Подготовка

### 1. Установка VM

```bash
# VirtualBox + Ubuntu Server 22.04/24.04
# Минимум: 2 CPU, 2 GB RAM, 20 GB disk
```

### 2. Настройка SSH

```bash
# На хосте: генерация ключа (если нет)
ssh-keygen -t ed25519 -C "devops-labs"

# Копирование ключа на VM
ssh-copy-id user@<vm-ip>

# Проверка подключения
ssh user@<vm-ip>
```

### 3. (Опционально) Отключение входа по паролю

```bash
# На VM: /etc/ssh/sshd_config
PasswordAuthentication no

sudo systemctl restart sshd
```

## Bash-шпаргалка

| Команда | Что делает |
|---------|------------|
| `cmd > file` | Перезаписать файл |
| `cmd >> file` | Дописать в файл |
| `cmd1 \| cmd2` | Пайп: вывод cmd1 → вход cmd2 |
| `echo $?` | Exit code предыдущей команды |
| `grep pattern file` | Поиск по шаблону |
| `cut -d':' -f1` | Вырезать поле |
| `sort \| uniq -c` | Сортировка + подсчёт уникальных |
| `awk '{print $1}'` | Вывод первого поля |

## Задания

### 1. `scripts/collect_sysinfo.sh`

Скрипт выводит информацию о системе в файл:
- CPU (модель, кол-во ядер)
- RAM (всего/свободно)
- Диск (использование)
- Сеть (IP-адреса)

```bash
./scripts/collect_sysinfo.sh > sysinfo.txt
```

### 2. `scripts/log_grep.sh`

Скрипт фильтрует логи по шаблону и считает частоту:

```bash
./scripts/log_grep.sh /var/log/syslog ERROR
# Вывод: количество совпадений, топ строк
```

## Git-минимум

```bash
git status              # что изменилось
git add .               # добавить всё
git commit -m "msg"     # зафиксировать
git log --oneline       # история
git diff                # что изменилось (до add)
git branch feature      # создать ветку
git checkout feature    # переключиться
git merge feature       # слить в текущую
```

## Экзамен (15 мин)

1. Показать SSH-подключение к VM
2. Объяснить разницу `>` и `>>`, что такое exit code
3. Показать `git log`, `git status`, `git diff`
4. Запустить свои скрипты и объяснить, что они делают

## Чеклист

- [x] VM установлена и доступна по SSH
- [x] SSH по ключам работает
- [x] `collect_sysinfo.sh` написан и работает
- [x] `log_grep.sh` написан и работает
- [x] `troubleshooting.md` заполнен (минимум 2 проблемы)
- [x] Экзамен сдан
