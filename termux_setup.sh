#!/bin/bash
# ====================================================
# Project:     StealthEntry - Environment Setup
# Version:     1.1 (Updated with Go Recon Suite)
# Developer:   Jake Lo
# Platform:    Termux (Android)
# Description: Automated setup for initial access, 
#              persistence, and lateral movement.
# ====================================================

echo "[*] StealthEntry: Initializing Environment..."

# 1. Request Storage Access & Wake Lock
# Ensures the session stays alive and has file system access
termux-setup-storage
termux-wake-lock
echo "[+] Storage and Wake-lock requested."

# 2. Update System & Install Core Packages
# Added 'golang' for tool compilation and 'libpcap' for network tools
echo "[*] Updating repositories and installing core packages..."
pkg update && pkg upgrade -y
pkg install -y openssh tmux tur-repo nmap wget tsu clang python git golang libpcap-dev -y

# 3. Install cloudflared (Optimized for Termux/ARM64)
# Essential for the StealthEntry Ingress tunnel
echo "[*] Installing cloudflared..."
pkg install cloudflared -y

# 4. Set SSH Password
echo "[*] Please set your SSH password for remote access:"
passwd

# 5. [NEW] Install ProjectDiscovery Recon Suite (Go-based)
# Compiling from source ensures compatibility with Rootless Termux/aarch64
echo "[*] Setting up Go environment and compiling Recon tools..."
export GO_BIN="$HOME/go/bin"
mkdir -p $GO_BIN

# Install naabu (Fast Port Scanner) and nuclei (Vulnerability Scanner)
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# 6. Persistent PATH Configuration
# Ensures tools are available in every new session
echo "[*] Configuring PATH persistence in .bashrc..."
if ! grep -q "$GO_BIN" ~/.bashrc; then
    echo "export PATH=\$PATH:$GO_BIN" >> ~/.bashrc
    echo "[+] PATH updated in .bashrc."
fi
export PATH="$PATH:$GO_BIN"

# 7. Install NetHunter Rootless (Optional but recommended for Recon)
# Provides additional binary support for advanced penetration testing
echo "[*] Downloading NetHunter Rootless installer..."
wget -O install-nethunter-termux https://offs.ec/2MceZWr
chmod +x install-nethunter-termux
# Note: Requires manual interaction to complete. 
# Run './install-nethunter-termux' manually if needed.

# 8. Verification & Final Report
echo "===================================================="
echo "                INSTALLATION COMPLETE               "
echo "                Developer: Jake Lo                  "
echo "===================================================="
ssh_ver=$(sshd -V 2>&1 | head -n 1)
cf_ver=$(cloudflared --version)
naabu_ver=$($GO_BIN/naabu -version 2>/dev/null || echo "Not Found")
nuclei_ver=$($GO_BIN/nuclei -version 2>/dev/null || echo "Not Found")

echo "Checklist:"
echo "[V] SSH:      $ssh_ver"
echo "[V] CF:       $cf_ver"
echo "[V] Tmux:     $(tmux -V)"
echo "[V] Naabu:    $naabu_ver"
echo "[V] Nuclei:   $nuclei_ver"
echo ""
echo "Next Steps:"
echo "1. Run 'source ~/.bashrc' or restart Termux."
echo "2. Run 'tmux' to start a persistent session."
echo "3. Execute './run_on_termux.sh' to open the portal."
echo "4. Use 'naabu -host 192.168.2.0/24' for lateral reconnaissance."
echo "===================================================="
