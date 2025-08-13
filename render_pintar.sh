#!/bin/bash

# --- Pengaturan Direktori ---
DIR_MENTAH="/videos_mentah"
DIR_JADI="/videos_jadi"

if ! command -v ffprobe &> /dev/null; then
    echo "ERROR: ffprobe tidak ditemukan."
    exit 1
fi

if ! find "$DIR_MENTAH" -maxdepth 1 -type f -name "*.mp4" -print -quit | grep -q .; then
    echo "Tidak ada file .mp4 ditemukan di folder $DIR_MENTAH."
    exit 0
fi

echo "--- Memulai Proses Render Pintar (Versi 4K - CBR) ---"

# --- PERUBAHAN DI SINI: Menggunakan metode looping yang lebih aman ---
find "$DIR_MENTAH" -maxdepth 1 -type f -name "*.mp4" -print0 | while IFS= read -r -d '' file; do
    filename=$(basename -- "$file")
    output_file="$DIR_JADI/$filename"

    echo " " 
    echo "-> Memproses file: $filename"

    height=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=s=x:p=0 "$file")

    if [[ $height -ge 2160 ]]; then
        echo "   Resolusi terdeteksi: 4K. Menerapkan preset 4K (12000k)."
        ffmpeg -y -nostdin -i "$file" -vf "scale=3840:2160" -c:v libx264 -preset veryfast -b:v 12000k -minrate 12000k -maxrate 12000k -r 30 -g 60 -c:a copy "$output_file"
    elif [[ $height -ge 1080 ]]; then
        echo "   Resolusi terdeteksi: 1080p. Menerapkan preset 1080p (6500k)."
        ffmpeg -y -nostdin -i "$file" -vf "scale=1920:1080" -c:v libx264 -preset veryfast -b:v 6500k -minrate 6500k -maxrate 6500k -r 30 -g 60 -c:a copy "$output_file"
    elif [[ $height -ge 720 ]]; then
        echo "   Resolusi terdeteksi: 720p. Menerapkan preset 720p (2500k)."
        ffmpeg -y -nostdin -i "$file" -vf "scale=1280:720"  -c:v libx264 -preset veryfast -b:v 2500k -minrate 2500k -maxrate 2500k -r 30 -g 60 -c:a copy "$output_file"
    else
        echo "   Resolusi di bawah 720p. Video hanya akan disalin."
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
