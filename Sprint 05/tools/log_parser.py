#!/usr/bin/env python3
"""
log_parser.py — парсер лог-файлов.
Считает топ ошибок/событий по паттернам.

Использование:
    python3 log_parser.py --file /var/log/nginx/error.log
    python3 log_parser.py --file /var/log/nginx/error.log --top 5
    python3 log_parser.py --file /var/log/nginx/error.log --level error
"""

import argparse
import re
from collections import Counter


def parse_args():
    """Разбираем аргументы командной строки."""
    parser = argparse.ArgumentParser(description="Парсер лог-файлов")
    parser.add_argument("--file", required=True, help="Путь к лог-файлу")
    parser.add_argument("--top", type=int, default=10, help="Сколько топ записей показать (по умолчанию 10)")
    parser.add_argument("--level", default=None, help="Фильтр по уровню: error, warn, info (по умолчанию все)")
    return parser.parse_args()


def read_log(filepath):
    """Читаем лог-файл, возвращаем список строк."""
    try:
        with open(filepath, "r") as f:
            return f.readlines()
    except FileNotFoundError:
        print(f"Ошибка: файл '{filepath}' не найден")
        exit(1)
    except PermissionError:
        print(f"Ошибка: нет прав на чтение '{filepath}'")
        exit(1)


def extract_message(line):
    """
    Извлекаем сообщение из строки лога.
    Пробуем несколько форматов.
    """
    # Формат Nginx: 2026/02/17 10:00:00 [error] 123#0: *1 message
    nginx = re.search(r'\[(\w+)\] \d+#\d+: (?:\*\d+ )?(.+)', line)
    if nginx:
        return nginx.group(1).lower(), nginx.group(2).strip()

    # Формат systemd/journald: Feb 17 10:00:00 host app[123]: message
    systemd = re.search(r'\w+ +\d+ [\d:]+ \S+ \S+\[\d+\]: (.+)', line)
    if systemd:
        return "info", systemd.group(1).strip()

    # Если не распознали формат — берём всю строку
    line = line.strip()
    if line:
        return "info", line
    return None, None


def main():
    args = parse_args()
    lines = read_log(args.file)

    if not lines:
        print("Лог-файл пустой")
        exit(0)

    messages = []
    for line in lines:
        level, message = extract_message(line)
        if level is None:
            continue
        # Фильтр по уровню если задан
        if args.level and level != args.level.lower():
            continue
        messages.append(message)

    if not messages:
        print(f"Записей не найдено (уровень: {args.level or 'все'})")
        exit(0)

    # Считаем топ
    counter = Counter(messages)
    top = counter.most_common(args.top)

    level_str = f" (уровень: {args.level})" if args.level else ""
    print(f"Топ {args.top} записей из {args.file}{level_str}:")
    print(f"Всего записей: {len(messages)}")
    print()
    for i, (message, count) in enumerate(top, 1):
        print(f"  {i:2}. {count:4}x  {message}")


if __name__ == "__main__":
    main()
