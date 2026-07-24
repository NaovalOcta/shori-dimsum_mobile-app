# Feature Index — Shori Dimsum Mobile App

> Daftar fitur yang **benar-benar ada** di kode, berdasarkan routes + controllers + bindings.
> Diverifikasi dari [VERIFIED: lib/app/routes/app_pages.dart] dan controllers masing-masing.

---

## Fitur Pelanggan (User Role)

### 1. Start / Splash Screen
- **Route:** `/start` [VERIFIED: app_routes.dart]
- **Module:** `0_start/`
- **Deskripsi:** Layar awal sebelum login

### 2. Login
- **Route:** `/login`
- **Module:** `1_login/`
- **Fungsi terverifikasi:**
  - Input email & password
  - Validasi format (email berisi `@`, panjang min 5; password min 8 karakter)
  - Autentikasi via Supabase Auth `signInWithPassword`
  - Fetch role user setelah login
  - Redirect: `admin` → `/admin-home`, `user` → `/home`
- [VERIFIED: lib/app/modules/1_login/controllers/login_controller.dart]

### 3. Register
- **Route:** `/register`
- **Module:** `1_register/`
- **Status:** Route terdaftar [VERIFIED: app_pages.dart], implementasi tidak diperiksa secara penuh
- [PERLU KONFIRMASI] Detail implementasi register (field apa yang dikumpulkan, validasi, dll.)

### 4. Home
- **Route:** `/home`
- **Module:** `2_home/`
- **Deskripsi:** Dashboard utama user dengan navigasi bottom bar
- **Navigasi:** 4 item di nav bar (Home, Favorit, Kontak, Profil berdasarkan `navItemSelectionStateList` dengan 4 item) [VERIFIED: home_controller.dart L4]

### 5. Katalog Makanan
- **Route:** `/food-catalog`
- **Module:** `3_food_catalog/`
- **Fungsi terverifikasi:**
  - Fetch produk dari Supabase
  - Search by nama produk (case-insensitive, substring match)
  - Filter by: A-Z, Z-A, Highest/Lowest Price, Highest/Lowest Rating
  - Filter by kategori: All, Dimsum, Topping, Classic, Popular
  - Responsif terhadap rotasi device (2 vs 4 kolom grid)
  - Toggle favorit per produk
  - Tambah ke cart
- [VERIFIED: lib/app/modules/3_food_catalog/controllers/food_catalog_controller.dart]

### 6. Detail Produk
- **Route:** `/product-info`
- **Module:** `4_product_info/`
- **Deskripsi:** Halaman info lengkap produk yang dipilih
- [PERLU KONFIRMASI] Isi lengkap tampilan detail (tombol apa saja, dsb.)

### 7. Cart (Keranjang)
- **Route:** `/cart`
- **Module:** `3_cart/`
- **Fungsi terverifikasi:**
  - Tampil daftar produk yang ditambahkan ke cart
  - Atur quantity per produk (tambah/kurang, min 1)
  - Hapus produk dari cart
- **Catatan:** Cart state in-memory, tidak persist ke DB [INFERENSI dari FoodCatalogController]

### 8. Payment (Pembayaran)
- **Route:** `/payment`
- **Module:** `5_payment/`
- **Status:** Route terdaftar. [PERLU KONFIRMASI] Apakah sudah ada integrasi payment gateway? Atau hanya simulasi?

### 9. Payment Complete (Konfirmasi)
- **Route:** `/payment-complete`
- **Module:** `6_payment_complete/`
- **Deskripsi:** Halaman konfirmasi setelah pembayaran

### 10. Favorit
- **Route:** `/favorite`
- **Module:** `3_favorite/`
- **Fungsi terverifikasi:**
  - Tampil produk yang difavoritkan
  - Toggle favorit (hapus dari daftar favorit)
- **Catatan:** State in-memory — favorit hilang jika app di-restart [VERIFIED: food_catalog_controller.dart L178-188]

### 11. Kontak
- **Route:** `/contact`
- **Module:** `3_contact/`
- **Status:** Route terdaftar. [PERLU KONFIRMASI] Isi implementasinya (form kontak? nomor telepon? WhatsApp?)

### 12. Profil
- **Route:** `/profile`
- **Module:** `3_profile/`
- **Fungsi terverifikasi:**
  - Fetch data profil dari Supabase
  - Edit nama, alamat, nomor telepon
  - Simpan perubahan ke Supabase
  - Email tidak bisa diedit via UI (butuh verifikasi Supabase Auth)
  - Logout (Supabase Auth signOut + redirect ke login)
- [VERIFIED: lib/app/modules/3_profile/controllers/profile_controller.dart]

---

## Fitur Admin

### 13. Admin Home (Dashboard)
- **Route:** `/admin-home`
- **Module:** `admin_home/`
- **Deskripsi:** Dashboard utama admin
- [PERLU KONFIRMASI] Konten dashboard (statistik apa saja yang ditampilkan?)

### 14. Admin Manage Menu (Kelola Produk)
- **Route:** `/admin-manage-menu`
- **Module:** `admin_manage_menu/`
- **Fungsi terverifikasi:**
  - **Mode Tambah:** Input nama, harga, deskripsi, kategori, jumlah pcs, upload gambar
  - **Mode Edit:** Isi form dengan data existing (dikirim via `Get.arguments`)
  - Upload gambar ke Supabase Storage bucket `menu-images` (kompres 70%, max 800px)
  - Simpan URL gambar sebagai string ke kolom `image_path`
  - Hapus produk (dengan konfirmasi dialog)
  - Refresh `AdminHomeController` setelah save/delete
- [VERIFIED: lib/app/modules/admin_manage_menu/controllers/admin_manage_menu_controller.dart]

### 15. Admin Orders (Kelola Pesanan)
- **Route:** `/admin-orders`
- **Module:** `admin_orders/`
- **Fungsi terverifikasi:**
  - Fetch semua order dari Supabase (diurutkan terbaru)
  - Tampil status per order (color-coded: orange/biru/hijau/merah)
  - Update status via Bottom Sheet: `pending` → `process` → `completed` / `cancelled`
  - Optimistic UI update (perubahan langsung terlihat, revert jika gagal)
- [VERIFIED: lib/app/modules/admin_orders/controllers/admin_orders_controller.dart]

### 16. Admin Chat (Inbox)
- **Route:** `/admin-chat`
- **Module:** `admin_chat/`
- **Fungsi terverifikasi:**
  - Tampil daftar "chat session" (DUMMY — hardcoded 3 chat)
- **⚠️ PENTING:** Ini adalah fitur DUMMY sepenuhnya — tidak ada backend [VERIFIED: admin_chat_controller.dart]

### 17. Admin Chat Detail (Room)
- **Route:** `/admin-chat-detail`
- **Module:** `admin_chat_detail/`
- **Fungsi terverifikasi:**
  - Tampil pesan (DUMMY — hardcoded)
  - Kirim pesan (hanya update state lokal, tidak dikirim ke server)
- **⚠️ PENTING:** Ini adalah fitur DUMMY sepenuhnya [VERIFIED: admin_chat_controller.dart]
- **[DRIFT TERDETEKSI]** Route didaftarkan dengan hardcoded `userName: 'Customer 1'` [VERIFIED: app_pages.dart L128]

---

## Ringkasan Status Fitur

| Kategori | Total | Terverifikasi Penuh | Perlu Konfirmasi | DUMMY |
|---|---|---|---|---|
| User | 12 | 8 | 4 | 0 |
| Admin | 5 | 3 | 1 | 2 |
