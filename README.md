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
    wget https://raw.githubusercontent.com/emuhib/server-transcoding/main/install.sh && bash install.sh
    
    ```

4.  Tunggu proses instalasi selesai. Di akhir, Anda akan diberikan **password** (`serverku12345` atau yang Anda atur di skrip) untuk login ke File Browser.

---

## B. Alur Kerja Transcoding (Proses Sehari-hari)

Ini adalah langkah-langkah yang akan Anda ulangi setiap kali ingin memproses video.

### Langkah 1: Pindahkan Video ke Server Transcoding

1.  Login ke **Server Transcoding** Anda via SSH.
2.  Jalankan perintah `scp` untuk "menarik" semua video dari server lama ke folder `/videos_mentah`. Ganti `IP_SERVER_LAMA` dengan IP server StreamHib Anda.

    ```bash
    scp root@IP_SERVER_LAMA:/root/StreamHibV2/videos/*.mp4 /videos_mentah/
    ```
3.  Anda akan dimintai password untuk **server lama**. Masukkan passwordnya dan tunggu proses transfer selesai.

### Langkah 2: Mulai Sesi Render di `screen`

1.  Setelah semua video berhasil dipindahkan, buat sesi `screen` baru bernama `render`:
    ```bash
    screen -S render
    ```
    *(Jika sesi `render` sudah ada dari sebelumnya, gunakan `screen -r render` untuk masuk kembali).*

### Langkah 3: Jalankan Skrip Render

1.  Setelah masuk ke dalam `screen`, **pindah direktori terlebih dahulu** agar tidak salah lokasi. Ini penting!
    ```bash
    cd /
    
    ```
2.  Sekarang jalankan skrip render pintar:
    ```bash
    ./render_pintar.sh
    
    ```
3.  Proses render akan berjalan di layar Anda.

### Langkah 4: Tinggalkan Proses Agar Berjalan Aman

1.  Biarkan proses render berjalan, Anda bisa keluar dari sesi `screen` dengan menekan:
    * **`Ctrl+A`** (lepaskan)
    * Lalu tekan **`D`**
2.  Anda sekarang bisa menutup jendela SSH. Proses render akan tetap berjalan dengan aman di server.

### Langkah 5: Kembalikan Video Hasil ke Server Lama

1.  Login kembali ke **Server Transcoding** via SSH kapan pun Anda mau untuk mengecek. Gunakan `screen -r render` untuk melihat progres.
2.  Jika semua proses sudah selesai (terminal di dalam `screen` menampilkan "Semua Proses Selesai"), kembalikan semua video yang sudah diproses dari folder `/videos_jadi` ke server lama.

    ```bash
    scp /videos_jadi/*.mp4 root@IP_SERVER_LAMA:/root/StreamHibV2/videos/
    
    ```
3.  Tunggu hingga proses transfer selesai. Video Anda yang sudah dioptimalkan kini siap digunakan di server StreamHib.
