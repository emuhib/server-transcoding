# Server Transcoding Video Otomatis

Repositori ini berisi skrip untuk secara otomatis menyiapkan server Ubuntu baru sebagai mesin transcoding video, lengkap dengan antarmuka web untuk manajemen file dan eksekusi perintah.

## Fitur

- **Instalasi Satu Perintah:** Siapkan seluruh server dengan satu skrip `install.sh`.
- **Antarmuka File Web:** Kelola file (upload/download) dengan mudah melalui File Browser di port `8080`.
- **Terminal Web:** Jalankan perintah render langsung dari browser melalui `ttyd` di port `7681`, tidak perlu aplikasi SSH.
- **Render Pintar:** Skrip `render_pintar.sh` secara otomatis mendeteksi resolusi video (4K, 1080p, 720p) dan menerapkan preset FFmpeg yang sesuai.

---

## A. Instalasi Server (Hanya dilakukan sekali)

1.  Sewa VPS baru dengan sistem operasi **Ubuntu 22.04 LTS**.
2.  Login ke server Anda sebagai `root` melalui SSH untuk pertama kali.
3.  Jalankan perintah berikut (ganti `NAMA_USER_GITHUB_ANDA` dengan username GitHub Anda):

    ```bash
    wget [https://raw.githubusercontent.com/emuhib/server-transcoding/main/install.sh](https://raw.githubusercontent.com/emuhib/server-transcoding/main/install.sh) && bash install.sh
    ```

4.  Tunggu proses instalasi selesai. Di akhir, Anda akan diberikan **password** untuk login ke File Browser. **CATAT PASSWORD INI BAIK-BAIK.**

---

## B. Alur Kerja Transcoding (Proses Sehari-hari)

Semua langkah di bawah ini dilakukan dari browser Anda, tidak perlu membuka aplikasi SSH lagi.

### Langkah 1: Pindahkan Video dari Server Lama

1.  Buka **Terminal Web** di browser Anda dengan mengunjungi alamat:
    `http://IP_SERVER_TRANSCODING:7681`

2.  Jalankan perintah `scp` untuk "menarik" semua video dari server lama ke folder `/videos_mentah`. Ganti `IP_SERVER_LAMA` dengan IP server StreamHib Anda.
    ```bash
    scp root@IP_SERVER_LAMA:/root/StreamHibV2/videos/*.mp4 /videos_mentah/
    ```

3.  Anda akan dimintai password untuk **server lama**. Masukkan passwordnya dan tunggu proses transfer selesai.

### Langkah 2: Jalankan Proses Render

1.  Masih di **Terminal Web** yang sama.
2.  Jalankan skrip render pintar dengan perintah:
    ```bash
    /render_pintar.sh
    ```
3.  Proses render akan berjalan di jendela terminal tersebut. Anda bisa memantaunya sampai selesai.

### Langkah 3: Kembalikan Video Hasil ke Server Lama

1.  Setelah proses render selesai, tetap di **Terminal Web**.
2.  Jalankan perintah `scp` untuk "mendorong" semua video yang sudah diproses dari folder `/videos_jadi` kembali ke server lama.
    ```bash
    scp /videos_jadi/*.mp4 root@IP_SERVER_LAMA:/root/StreamHibV2/videos/
    ```
3.  Anda akan dimintai password untuk **server lama** lagi. Tunggu hingga proses transfer selesai.
4.  (Opsional) Anda bisa membersihkan folder `/videos_mentah` dan `/videos_jadi` melalui **File Browser** (`http://IP_SERVER_TRANSCODING:8080`) untuk persiapan render berikutnya.
