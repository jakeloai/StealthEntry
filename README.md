# StealthEntry v1.0
**Accurate In-Network Persistence & Tactical Ingress**

**Developer:** `Jake Lo`  
**Philosophy:** *Precision over Volume. Stealth over Noise.*

---

## 📖 Introduction
**StealthEntry** is a professional Red Team implant suite designed for the **"Plant & Persist"** phase of a targeted operation. It enables an attacker to transform a standard Android device into a covert, remote-access gateway that bypasses modern firewalls and NAT. 

By leveraging **Phase 0 Intelligence**, this tool allows for surgical strikes against specific network infrastructures, especially in environments where legacy hardware or third-party supply chains provide the path of least resistance.

---

## 🎯 The Attack Chain (Jake Lo's Protocol)

This toolkit is optimized for a professional, multi-stage lifecycle that begins long before the physical breach:

### **Phase 0: Pre-Action Intelligence (Reconnaissance)**
* **Infrastructure History Recon:** Analyze the age and history of the target building. Older architectural infrastructures often suffer from poor **network isolation** (Flat Networks). Identifying a "legacy" building means that once an ingress point is established, you may be able to recon the entire building's shared network.
* **Supply Chain Recon:** Identify the third-party ecosystem (Cleaning services, lift maintenance, IT contractors, HVAC repair). You do not always need to target the authorized test subject directly; playing the role of a trusted third-party vendor provides the most effective physical cover.

### **Phase 1: Physical Engagement (The Plant)**
* **Social Engineering:** Leverage Phase 0 intelligence to gain physical access under a legitimate-looking pretense (e.g., service technician).
* **Deployment:** Conceal the Android device (running Termux) near a stable power source (behind a printer, under a desk, or inside a network closet).

### **Phase 2: Establish Ingress (The Persistence)**
* **StealthEntry Activation:** Establish an outbound SSH tunnel via Cloudflare. This bypasses strict inbound firewall rules without requiring any local network modification or Root access.
* **Remote Connection:** Attacker connects securely via SSH from a remote Kali machine to the deployed implant.

### **Phase 3: Exploitation & Pivot (The Move)**
* **Internal Recon:** Perform `nmap` scans and service enumeration. 
* **Lateral Movement:** Leverage the lack of network segmentation to pivot from the mobile implant deeper into high-value corporate assets or Building Management Systems (BMS).

---

## 🛠️ Environment Setup

### 1. Attacker Side (Your Kali Linux Machine)
**CRITICAL:** Your Kali machine **must** have the Cloudflare Tunnel client installed to handle the `ProxyCommand`.

```bash
# Download and Install Cloudflared (AMD64)
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
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

---

## 🚀 Operational Workflow

### Phase 1: On-Site Deployment
1.  Open Termux and start a `tmux` session.
2.  Execute `./run_on_termux.sh`.
3.  **Capture:** Take a photo of the generated `ssh -o ProxyCommand...` command.
4.  **Detach:** Press `Ctrl+B` then `D`.
5.  **Hide:** Conceal the device and exit the premises.

### Phase 2: Remote Operations
1.  **Remote Login:** SSH into the device from your Kali machine using the captured command.
2.  **Activate Mask:** Start `./normal_traffic.sh` in a new tmux window to hide your C2 traffic within legitimate HTTPS noise.
3.  **Lateral Movement:**
    ```bash
    # Scan for vulnerabilities in the local subnet
    nmap -sV --script=vuln [Target_Subnet]
    ```

---

## 🛡️ Core Components
* **`run_on_termux.sh`**: Automates tunnel creation and persistent wake-locks.
* **`normal_traffic.sh`**: Mimics standard HTTPS browsing behavior (Google, LinkedIn, etc.) to mask C2 pulse.
* **`current_status.txt`**: Real-time remote health check of the implant.

---

## 🔐 OpSec & Cleanup
Wipe the implant traces remotely if the mission is compromised:
```bash
pkill cloudflared && pkill sshd && termux-wake-unlock && exit
```

---

## ⚠️ Disclaimer
*This toolkit is developed by **Jake Lo** for authorized security assessments only. Unauthorized access to computer systems is strictly prohibited.*
