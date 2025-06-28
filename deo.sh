#!/bin/bash

# Hindari prompt interaktif dari apt/dpkg
export DEBIAN_FRONTEND=noninteractive

# Update dan install paket dasar tanpa prompt
apt update -y
apt install -y tar screen wget curl nano htop git --no-install-recommends \
    -o Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confold"

# Cek dan install Node.js 18.20.0 jika belum terinstall
if ! node -v 2>/dev/null | grep -q "v18.20.0"; then
    echo "Installing Node.js v18.20.0..."

    # Hapus nodejs lama jika ada
    apt remove -y nodejs || true
    rm -rf /usr/local/bin/node /usr/local/bin/npm /usr/local/lib/node_modules

    # Install n langsung dan gunakan untuk pasang Node.js versi 18.20.0
    curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s v18.20.0

    # Tambahkan path (untuk session skrip)
    export PATH="/usr/local/bin:$PATH"

    # Install pm2
    npm install -g pm2
else
    echo "Node.js v18.20.0 already installed"
fi

# Hapus direktori lama cloud-iprotate jika ada
if [[ -d "/opt/deo.putar/" ]]; then
    rm -rf /opt/deo.putar/
fi

# Jalankan setup shadowsocks
curl -fsSL https://raw.githubusercontent.com/ilyasbit/ss-easy-setup/main/install-only.sh | bash -s

# Clone ulang cloud-iprotate dan setup
mkdir -p /etc/shadowsocks/
rm -rf deo.putar/
git clone https://github.com/WASYHU/deo.putar.git
mv deo.putar /opt/
cd /opt/deo.putar/
npm install
cd ~
