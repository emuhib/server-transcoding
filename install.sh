#!/binbash

echo "================================================="
echo "      StreamHib - Auto Transcoding Server Installer"
echo "================================================="

# --- Update Sistem & Install Software Penting ---
echo "[INFO] Mengupdate sistem dan menginstall software..."
apt-get update
apt-get install -y ffmpeg curl dos2unix

# --- Membuat Struktur Folder ---
echo "[INFO] Membuat direktori kerja..."
mkdir -p /videos_mentah
mkdir -p /videos_jadi

# --- Mengunduh Skrip Render ---
echo "[INFO] Mengunduh skrip render_pintar.sh dari GitHub..."
curl -o /render_pintar.sh https://raw.githubusercontent.com/emuhib/server-transcoding/main/render_pintar.sh

# --- Mengkonversi dan Memberi Izin Eksekusi ---
dos2unix /render_pintar.sh
chmod +x /render_pintar.sh
echo "[INFO] Skrip render_pintar.sh siap digunakan."

# --- Install & Konfigurasi File Browser sebagai Service ---
echo "[INFO] Menginstall File Browser..."
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

echo "[INFO] Membuat File Browser menjadi service agar selalu aktif..."
cat <<EOF > /etc/systemd/system/filebrowser.service
[Unit]
Description=File Browser
After=network.target

[Service]
ExecStart=/usr/local/bin/filebrowser -a 0.0.0.0 -r / -p 8080
User=root
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable filebrowser.service
systemctl start filebrowser.service

echo "[INFO] File Browser sekarang aktif di http://IP_SERVER:8080"

# --- Menampilkan Password File Browser ---
echo "================================================="
echo "         SETUP SELESAI & INFORMASI LOGIN"
echo "================================================="
echo "File Browser akan menampilkan log dan password di bawah ini."
echo "Tunggu sekitar 5-10 detik..."
echo ""
sleep 5
journalctl -u filebrowser.service --no-pager | grep "initialized with randomly generated password"
echo ""
echo "-------------------------------------------------"
echo "Login ke File Browser di http://IP_SERVER:8080"
echo "Gunakan username 'admin' dan password yang ditampilkan di atas."
echo "================================================="
