#!/bin/bash

# --- Pengaturan Direktori ---
DIR_MENTAH="/videos_mentah"
DIR_JADI="/videos_jadi"

# Cek apakah ffprobe ada
if ! command -v ffprobe &> /dev/null; then
    echo "ERROR: ffprobe tidak ditemukan. Pastikan ffmpeg terinstal dengan benar."
    exit 1
fi

# Cek apakah ada file video di folder mentah
if ! ls "$DIR_MENTAH"/*.mp4 &> /dev/null; then
    echo "Tidak ada file .mp4 ditemukan di folder $DIR_MENTAH."
    exit 0
fi

echo "--- Memulai Proses Render Pintar (Versi 4K - Nama File Sama) ---"

# Loop melalui setiap file mp4 di direktori mentah
for file in "$DIR_MENTAH"/*.mp4; do
    filename=$(basename -- "$file")
    output_file="$DIR_JADI/$filename"

    echo " " 
    echo "-> Memproses file: $filename"

    height=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=s=x:p=0 "$file")

    if [[ $height -ge 2160 ]]; then
        echo "   Resolusi terdeteksi: 4K. Menerapkan preset 4K (12000k)."
        ffmpeg -y -i "$file" -vf "scale=3840:2160" -c:v libx264 -preset veryfast -b:v 12000k -minrate 12000k -maxrate 12000k -r 30 -g 60 -c:a copy "$output_file"
    elif [[ $height -ge 1080 ]]; then
        echo "   Resolusi terdeteksi: 1080p. Menerapkan preset 1080p (6500k)."
        ffmpeg -y -i "$file" -vf "scale=1920:1080" -c:v libx264 -preset veryfast -b:v 6500k -minrate 6500k -maxrate 6500k -r 30 -g 60 -c:a copy "$output_file"
    elif [[ $height -ge 720 ]]; then
        echo "   Resolusi terdeteksi: 720p. Menerapkan preset 720p (2500k)."
        ffmpeg -y -i "$file" -vf "scale=1280:720"  -c:v libx264 -preset veryfast -b:v 2500k -minrate 2500k -maxrate 2500k -r 30 -g 60 -c:a copy "$output_file"
    else
        echo "   Resolusi di bawah 720p. Video hanya akan disalin tanpa render ulang."
        cp "$file" "$output_file"
    fi

    if [ $? -eq 0 ]; then
        echo "   SUKSES: File \"$output_file\" berhasil dibuat."
    else
        echo "   GAGAL: Terjadi masalah saat memproses $filename."
    fi
done

echo " "
echo "--- Semua Proses Selesai ---"
