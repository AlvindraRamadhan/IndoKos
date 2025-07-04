# 🏠 IndoKos - Aplikasi Pencarian Kos


**IndoKos** IndoKos adalah aplikasi mobile yang dirancang untuk memudahkan pengguna dalam mencari, memesan, dan mengelola kos/kontrakan di seluruh Indonesia. Aplikasi ini menyediakan berbagai fitur lengkap mulai dari pencarian kos berdasarkan lokasi, harga, fasilitas, hingga sistem pemesanan dan pembayaran yang terintegrasi.

Dengan antarmuka yang user-friendly dan sistem yang aman, IndoKos menjadi solusi bagi mahasiswa dan pekerja yang membutuhkan tempat tinggal sementara dengan kenyamanan dan keamanan terjamin.

---

## ✨ Fitur Utama

### 🏠 Pencarian Kos Cerdas
- Filter pencarian berdasarkan lokasi, harga, jenis kos (putra/putri/campur), dan fasilitas
- Sistem rating dan ulasan untuk membantu pengambilan keputusan


### 💳 Manajemen Pemesanan
- Sistem pemesanan online dengan multi-step form
- Penyimpanan riwayat pemesanan
- Notifikasi status pemesanan


### 💳 Manajemen Pembayaran
- Berbagai metode pembayaran (Transfer Bank, E-Wallet)
- Pembayaran aman dengan verifikasi
- Invoice digital setelah pembayaran berhasil

### 👤 Manajemen Akun
- Sistem autentikasi pengguna (email & Google)
- Profil pengguna dengan data lengkap
- Wishlist untuk menyimpan kos favorit

### ✨ Fitur Tambahan
- Pengajuan kos baru oleh pemilik
- Sistem notifikasi terpusat
- Tema aplikasi (light/dark mode)


## 📱 Framework dan Teknologi

- **Frontend**
- Flutter (Dart)
- Provider (State Management)
- Go Router (Navigation)
- **Backend**
- **Library Pendukung**
- Cached Network Image
- Image Picker
- URL Launcher
- Intl (Internationalization)
- Card Swiper 

---

## 🖼️ Screenshot Aplikasi



---

## 🛠️ Cara Instalasi
**Prasyarat**
- Flutter SDK (versi terbaru)
- Android Studio/Xcode (untuk emulator)
- Perangkat Android/iOS fisik (opsional)

**Langkah-Langkah**

1. Clone repository:
```bash
git clone https://github.com/AlvindraRamadhan/IndoKos.git
cd IndoKos
```
2. Install dependencies:
``` bash
flutter pub get 
```
3. Jalankan Aplikasi:
```bash
flutter run
```
---

## 🗂️ Struktur Project

```bash
lib/
├── main.dart
├── app_theme.dart
├── app_router.dart
├── models.dart
├── auth_provider.dart
├── kos_provider.dart
├── utils.dart
├── main_layout.dart
├── mobile_bottom_nav.dart
├── login_screen.dart
├── register_screen.dart
├── mobile_home_screen.dart
├── chat_list_screen.dart
├── booking_history_screen.dart
├── profile_screen.dart
├── submit_kos_screen.dart
├── notifications_screen.dart
├── search_screen.dart
├── kos_detail_screen.dart
├── booking_screen.dart
├── payment_screen.dart
├── payment_success_screen.dart
├── filter_modal.dart
├── kos_card.dart
├── kos_card_mobile.dart
├── promo_carousel.dart
├── loading_screen.dart
├── wishlist_screen.dart      
├── about_us_screen.dart      
├── settings_screen.dart
├── theme_provider.dart      
└── pubspec.yaml

```

---

🤝 Kontribusi
Proyek ini dikembangkan sebagai bagian dari tugas mata kuliah Teknologi Mobile di Universitas Ahmad Dahlan. Kami menerima masukan dan saran untuk pengembangan lebih lanjut. 

**Jika Anda ingin Berkontribusi** 

1. Fork repository ini

2. Buat branch baru (git checkout -b fitur-baru)

3. Commit perubahan Anda (git commit -am 'Menambahkan fitur baru')

3. Push ke branch (git push origin fitur-baru)

4. Buat Pull Request

---

## 📌 Status Proyek

🟡 Dalam Pengembangan
Proyek ini masih dalam tahap pengembangan aktif. Fitur-fitur baru sedang ditambahkan dan perbaikan bug sedang dilakukan secara berkala.


---

## 📫 Kontak

Untuk pertanyaan lebih lanjut, silakan hubungi: 
- 📧 [2300016035@webmail.uad.ac.id]
- 📧 [2300016021@webmail.uad.ac.id]

---

© 2023 IndoKos - Tim Pengembang Teknologi Mobile UAD
