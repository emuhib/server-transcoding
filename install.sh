#!/bin/bash

echo "================================================="
echo "      Auto Transcoding Server Installer"
echo "================================================="

# --- Update Sistem & Install Software Penting ---
echo "[INFO] Mengupdate sistem dan menginstall software (ffmpeg, curl, dos2unix, screen)..."
apt-get update
apt-get install -y ffmpeg curl dos2unix screen

# --- Membuat Struktur Folder ---
echo "[INFO] Membuat direktori kerja (/videos_mentah, /videos_jadi)..."
mkdir -p /videos_mentah
mkdir -p /videos_jadi

# --- Mengunduh Skrip Render ---
GITHUB_USER="emuhib" # <--- GANTI INI
REPO_NAME="server-transcoding"
echo "[INFO] Mengunduh skrip render_pintar.sh dari GitHub..."
curl -o /render_pintar.sh https://raw.githubusercontent.com/${GITHUB_USER}/${REPO_NAME}/main/render_pintar.sh

# --- Mengkonversi dan Memberi Izin Eksekusi ---
dos2unix /render_pintar.sh
chmod +x /render_pintar.sh
echo "[INFO] Skrip render_pintar.sh siap digunakan."

# --- Install File Browser ---
echo "[INFO] Menginstall File Browser..."
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

# --- Membuat Skrip Peluncur untuk File Browser di dalam Screen ---
echo "[INFO] Membuat skrip peluncur untuk File Browser..."
cat <<'EOF' > /start_filebrowser.sh
#!/bin/bash
/usr/bin/screen -S filemanager -d -m /usr/local/bin/filebrowser -a 0.0.0.0 -r / -p 8080
EOF
chmod +x /start_filebrowser.sh

# --- Membuat Service untuk Menjalankan Skrip Peluncur saat Booting ---
echo "[INFO] Membuat service agar File Browser selalu aktif di dalam 'screen'..."
cat <<EOF > /etc/systemd/system/filebrowser-screen.service
[Unit]
Description=Start File Browser in a screen session
After=network.target

[Service]
User=root
ExecStart=/start_filebrowser.sh
Type=forking

[Install]
WantedBy=multi-user.target
EOF

# --- Menjalankan Semua Service ---
echo "[INFO] Menjalankan dan mengaktifkan semua service..."
systemctl daemon-reload
systemctl enable filebrowser-screen.service
systemctl start filebrowser-screen.service

# --- Membuka Port Firewall ---
echo "[INFO] Membuka port 8080 (File Browser) di firewall..."
ufw allow 8080/tcp

# --- Menampilkan Informasi Login ---
echo "================================================="
echo "         SETUP SELESAI & INFORMASI AKSES"
echo "================================================="
echo "Mencari password acak yang baru dibuat..."
echo "Tunggu sekitar 10 detik..."
echo ""
sleep 10 # Memberi waktu agar filebrowser.db dan log sempat dibuat
# Mencari password dari file database-nya langsung, ini cara paling andal
PASSWORD=$(/usr/local/bin/filebrowser users find admin | grep "Password" | awk '{print $2}')
echo "Login ke File Browser di: http://IP_SERVER_ANDA:8080"
echo "Gunakan Username: admin"
echo "Gunakan Password: ${PASSWORD}"
echo ""
echo "-------------------------------------------------"
echo "File Browser sekarang berjalan AMAN di dalam 'screen'."
echo "Anda bisa memverifikasinya dengan perintah: screen -ls"
echo "================================================="
