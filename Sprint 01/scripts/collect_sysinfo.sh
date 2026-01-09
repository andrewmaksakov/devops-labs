#!/bin/bash

  echo "=== CPU ==="
  lscpu | grep -E "Model name|^CPU\(s\)"

  echo ""
  echo "=== RAM ==="
  free -h | grep -E "Mem|total"

  echo ""
  echo "=== DISK ==="
  df -h /

  echo ""
  echo "=== NETWORK ==="
  hostname -I
