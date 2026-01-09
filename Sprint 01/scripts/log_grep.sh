#!/bin/bash

  if [ $# -lt 2 ]; then
      echo "Usage: $0 <logfile> <pattern>"
      exit 1
  fi

  LOGFILE=$1
  PATTERN=$2

  echo "Searching for '$PATTERN' in $LOGFILE"
  echo "Total matches: $(grep -c "$PATTERN" "$LOGFILE" 2>/dev/null)"
  echo ""
  echo "Top 10 matches:"
  grep "$PATTERN" "$LOGFILE" 2>/dev/null | head -10
