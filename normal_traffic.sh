#!/bin/bash
# ====================================================
# Project:    StealthEntry - Traffic Obfuscation
# Developer:  Jake Lo
# ====================================================

sites=("https://www.google.com.hk" "https://www.linkedin.com" "https://www.bbc.com" "https://www.wikipedia.org")
STATUS_FILE="current_status.txt"
LOG_FILE="traffic_gen.log"

echo "[$(date)] StealthEntry Obfuscator started by Jake Lo." >> $LOG_FILE

while true; do
  target=${sites[$RANDOM % ${#sites[@]}]}
  start_time=$(date "+%Y-%m-%d %H:%M:%S")
  
  # Update Status Snapshot
  echo "--- STEALTH ENTRY STAT ---" > $STATUS_FILE
  echo "Developer:  Jake Lo" >> $STATUS_FILE
  echo "Targeting:  $target" >> $STATUS_FILE
  echo "Status:     Active" >> $STATUS_FILE

  # Execute Stealth Request
  res=$(curl -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" -s -L -o /dev/null -w "%{http_code}" "$target")
  
  # Random Interval (300-900s)
  wait_time=$((300 + RANDOM % 600))
  next_run=$(date -d "@$(($(date +%s) + $wait_time))" "+%H:%M:%S")
  
  {
    echo "--- STEALTH ENTRY STAT ---"
    echo "Developer:  Jake Lo"
    echo "Last Visit: $start_time"
    echo "HTTP Code:  $res"
    echo "Next Run:   $next_run"
    echo "--------------------------"
  } > $STATUS_FILE

  echo "[$start_time] $target - Code: $res" >> $LOG_FILE
  sleep $wait_time
done
