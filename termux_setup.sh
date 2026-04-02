#!/bin/bash
# ====================================================
# Project:    StealthEntry - Environment Setup
# Developer:  Jake Lo
# Platform:   Termux (Android)
# ====================================================

echo "[*] StealthEntry: Initializing Environment..."

# 1. Request Storage Access & Wake Lock
termux-setup-storage
termux-wake-lock
echo "[+] Storage and Wake-lock requested."

# 2. Update System & Install Core Packages
pkg update && pkg upgrade -y
pkg install -y openssh tmux tur-repo nmap wget tsu clang python git -y

# 3. Install cloudflared (Optimized for Termux/ARM64)
# Note: Using pkg install for cloudflared is more stable in Termux
pkg install cloudflared -y

# 4. Set SSH Password
echo "[*] Please set your SSH password for remote access:"
passwd

# 5. Install NetHunter Rootless (Optional but recommended for Recon)
echo "[*] Downloading NetHunter Rootless installer..."
wget -O install-nethunter-termux https://offs.ec/2MceZWr
chmod +x install-nethunter-termux
# Note: This requires manual interaction during installation
# ./install-nethunter-termux

# 6. Verification
echo "===================================================="
echo "                INSTALLATION COMPLETE               "
echo "                Developer: Jake Lo                  "
echo "===================================================="
ssh_ver=$(sshd -V 2>&1 | head -n 1)
cf_ver=$(cloudflared --version)

echo "Checklist:"
echo "[V] SSH: $ssh_ver"
echo "[V] CF:  $cf_ver"
echo "[V] Tmux: $(tmux -V)"
echo ""
echo "Next Steps:"
echo "1. Run 'tmux' to start a persistent session."
echo "2. Execute './run_on_termux.sh' to open the portal."
echo "3. Execute './normal_traffic.sh' to start obfuscation."
echo "===================================================="
