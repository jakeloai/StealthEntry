# StealthEntry v1.0
**Accurate In-Network Persistence & Tactical Ingress**

**Developer:** `Jake Lo`  
**Philosophy:** *Precision over Volume. Stealth over Noise.*

---

## 📖 Introduction
**StealthEntry** is a high-precision Red Team implant designed for **Accurate Targeting**. Unlike mass-scanning tools, it focuses on establishing a stable, covert entry point within a specific target environment using **Termux** (Android) and **Cloudflare Tunneling**.

It transforms a standard Android device into a silent ingress point, allowing remote access to internal networks while mimicking legitimate office traffic to evade detection and network monitoring.

---

## 🛠️ Environment Setup

### 1. Attacker Side (Your Kali Linux Machine)
**CRITICAL:** To handle the `ProxyCommand` and connect to the generated tunnel, your Kali machine **must** have the Cloudflare Tunnel client installed.

Execute the following on your Kali machine:
```bash
# Download the latest Cloudflared (AMD64)
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb

# Install the package
sudo dpkg -i cloudflared-linux-amd64.deb

# Verify installation
cloudflared --version
```

### 2. Target Side (Android Device / Termux)
Run the `termux_setup.sh` on the target device to arm the environment:
```bash
chmod +x termux_setup.sh
./termux_setup.sh
```
*This will install SSHD, Cloudflared (ARM64), Tmux, and power management tools.*

---

## 🚀 Operational Workflow (Jake Lo's Protocol)

### Phase 1: Rapid Physical Implant (On-Site)
Minimize your physical footprint. Your goal is to launch the portal and secure the access link instantly:
1. Open Termux and start a `tmux` session.
2. Execute `./run_on_termux.sh`.
3. **Capture:** Take a photo of the generated `ssh -o ProxyCommand...` command displayed on the screen.
4. **Detach:** Press `Ctrl+B` then `D` to detach from the session.
5. **Deploy:** Lock the screen, hide the device in the target location, and exit the premises.

### Phase 2: Remote Obfuscation (Post-Infiltration)
Once you are back at your safehouse (Kali Machine), activate the cover traffic remotely to ensure long-term persistence:
1. **Remote Login:** Use the captured command from your photo to SSH into the Termux device.
2. **Re-attach:** Run `tmux a` to return to the deployment session.
3. **Trigger Cover:** Press `Ctrl+B` then `C` to create a new window and run:
   ```bash
   ./normal_traffic.sh
   ```
4. **Background:** Press `Ctrl+B` then `D`. Your tunnel is now masked by simulated HTTPS traffic.

---

## 🛡️ Core Components

### `run_on_termux.sh`
* Automates SSHD and Cloudflare Tunnel initialization.
* Forces `termux-wake-lock` to prevent the Android OS from killing background processes.
* Generates a "one-click" remote access command for the attacker.

### `normal_traffic.sh`
* Mimics standard office browsing behavior (Google, LinkedIn, BBC, etc.).
* Creates regular HTTPS pulse traffic to hide C2 communication within background noise.
* Allows remote monitoring of connection health via `current_status.txt`.

---

## 🔐 OpSec & Cleanup
If the operation is compromised or complete, execute the following remotely to wipe your presence:
```bash
# Stop all services and release power locks
pkill cloudflared && pkill sshd && termux-wake-unlock && exit
```

---

## ⚠️ Disclaimer
*This toolkit is developed by **Jake Lo** for authorized security assessments and educational purposes only. Unauthorized access to computer systems is strictly prohibited.*
