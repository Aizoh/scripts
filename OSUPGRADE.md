### 1️⃣ Update current system
```bash
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
```

upgrade updates packages without removing anything.

dist-upgrade allows removing/installing packages to resolve dependencies.

### 2️⃣ Install the update-manager-core (if not already)

```bash 
sudo apt install update-manager-core -y 
```

### 3️⃣ Start the release upgrade
```bash
sudo do-release-upgrade
```


Follow the prompts.

It will ask about replacing configuration files or keeping your current ones — usually keep the existing unless you have custom changes.

This will upgrade Ubuntu from 20.04 → 22.04.

### 4️⃣ Reboot after upgrade
```bash 
sudo reboot
```

### 5️⃣ Verify OS version
```bash 
lsb_release -a
```


You should see:

Distributor ID: Ubuntu
Description:    Ubuntu 22.04 LTS
Release:        22.04
Codename:       jammy
