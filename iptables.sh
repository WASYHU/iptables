#!/bin/bash

# Update dan install paket dasar
apt update -y
apt install -y tar screen wget curl nano htop git --no-install-recommends

# Cek dan install Node.js 18.20.0 jika belum terinstall
if ! node -v 2>/dev/null | grep -q "v18.20.0"; then
    echo "Installing Node.js v18.20.0..."
    
    # Hapus nodejs yang lama jika ada
    apt remove -y nodejs || true
    rm -rf /usr/local/bin/node /usr/local/bin/npm /usr/local/lib/node_modules
    
    # Install n secara langsung dan gunakan untuk install Node.js v18.20.0
    curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s v18.20.0

    # Tambahkan path (penting jika dijalankan dari skrip otomatis)
    export PATH="/usr/local/bin:$PATH"

    # Install pm2
    npm install -g pm2
else
    echo "Node.js v18.20.0 already installed"
fi

# Bersihkan direktori lama jika ada
if [[ -d "/opt/cloud-iprotate/" ]]; then
    rm -rf /opt/cloud-iprotate/
fi

# Jalankan setup dari GitHub
curl -fsSL https://raw.githubusercontent.com/ilyasbit/ss-easy-setup/main/install-only.sh | bash -s

# Clone dan pasang cloud-iprotate
mkdir -p /etc/shadowsocks/
rm -rf cloud-iprotate/
git clone https://github.com/ilyasbit/cloud-iprotate.git
mv cloud-iprotate /opt/
cd /opt/cloud-iprotate/
npm install
cd ~
