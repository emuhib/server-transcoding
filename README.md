# Server Transcoding Video Otomatis

Repositori ini berisi skrip untuk secara otomatis menyiapkan server Ubuntu baru sebagai mesin transcoding video.

## Fitur

- **Instalasi Satu Perintah:** Siapkan seluruh server dengan satu skrip `install.sh`.
- **Antarmuka Web:** Kelola file dengan mudah melalui File Browser.
- **Render Pintar:** Skrip `render_pintar.sh` secara otomatis mendeteksi resolusi video (4K, 1080p, 720p) dan menerapkan preset FFmpeg yang sesuai.

## Cara Penggunaan

1.  Sewa VPS baru dengan sistem operasi **Ubuntu 22.04 LTS**.
2.  Login ke server Anda sebagai `root` melalui SSH.
3.  Jalankan perintah berikut:

    ```bash
    wget [https://raw.githubusercontent.com/NAMA_USER_GITHUB_ANDA/server-transcoding/main/install.sh](https://raw.githubusercontent.com/NAMA_USER_GITHUB_ANDA/server-transcoding/main/install.sh) && bash install.sh
    ```

4.  Tunggu proses instalasi selesai. Di akhir, Anda akan diberikan **password** untuk login ke File Browser.
5.  Akses antarmuka web di `http://IP_SERVER_ANDA:8080`.

## Alur Kerja

1.  **Transfer Video:** Gunakan `scp` untuk memindahkan video dari server utama ke folder `/videos_mentah` di server ini.
2.  **Jalankan Render:** Login ke SSH dan jalankan perintah `/render_pintar.sh`.
3.  **Ambil Hasil:** Video yang sudah diproses akan muncul di folder `/videos_jadi`.
