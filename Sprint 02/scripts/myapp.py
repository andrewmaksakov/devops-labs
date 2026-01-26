#!/usr/bin/env python3
import time
import signal
import sys
import os

running = True

def handle_sigterm(signum, frame):
    global running
    print("Получил SIGTERM! Завершаюсь корректно...")
    running = False

signal.signal(signal.SIGTERM, handle_sigterm)

print(f"Сервис запущен. PID: {os.getpid()}")
sys.stdout.flush()

while running:
    print("Я работаю!")
    sys.stdout.flush()
    time.sleep(10)

print("Сервис остановлен корректно. Пока!")
