# API Reference — Shori Dimsum Mobile App

> Aplikasi ini tidak memiliki REST API sendiri.
> Semua operasi backend dilakukan melalui **Supabase client SDK** langsung dari Flutter.
> Dokumen ini mendaftar semua operasi Supabase yang ditemukan di kode.

---

## Autentikasi [VERIFIED: lib/app/modules/1_login/controllers/login_controller.dart]

### Login
```dart
supabase.auth.signInWithPassword(email: email, password: password)
```
- **Trigger:** Tombol login di `LoginView`
- **Return:** `AuthResponse` berisi `User` object
- **Post-action:** Fetch role dari `public.users`, redirect ke `HomeView` atau `AdminHomeView`

### Register
- [PERLU KONFIRMASI] Implementasi register ada di `1_register/controllers/` — tidak dibaca secara penuh, tetapi route `/register` terdaftar dan `RegisterBinding` terdaftar [VERIFIED: lib/app/routes/app_pages.dart L101-105]

### Logout
```dart
supabase.auth.signOut()
```
[VERIFIED: lib/app/modules/3_profile/controllers/profile_controller.dart L122]
- **Post-action:** Redirect ke `LoginView`

---

## Tabel: `users`

### Fetch profil user yang login
```dart
supabase.from('users').select().eq('id', currentUser.id).single()
```
[VERIFIED: lib/app/modules/3_profile/controllers/profile_controller.dart L44-48]

### Fetch role setelah login
```dart
supabase.from('users').select().eq('id', user.id).single()
```
[VERIFIED: lib/app/modules/1_login/controllers/login_controller.dart L40-44]

### Update profil user
```dart
supabase.from('users').update({
  'name': nameC.text,
  'address': addressC.text,
  'phone_number': phoneC.text,
}).eq('id', currentUser.id)
```
[VERIFIED: lib/app/modules/3_profile/controllers/profile_controller.dart L75-84]
- **Catatan:** `email` tidak diupdate via profile form (butuh verifikasi ulang Supabase Auth)
- **Catatan:** `role` tidak bisa diupdate oleh user (terlindungi RLS)

### Fetch semua user (Admin)
```dart
supabase.from('users').select()
```
[VERIFIED: lib/app/data/User_DB .dart L13-15]

---

## Tabel: `products`

### Fetch semua produk
```dart
supabase.from('products').select()
```
[VERIFIED: lib/app/data/Product_DB.dart L9]
- Digunakan oleh `FoodCatalogController` dan `AdminHomeController`

### Tambah produk (Admin)
```dart
supabase.from('products').insert({
  'name', 'price', 'description', 'category', 'unitPieces', 'image_path', 'rating'
})
```
[VERIFIED: lib/app/data/Product_DB.dart L19-30]
- `rating` selalu di-set `'0.0'` saat insert baru

### Update produk (Admin)
```dart
supabase.from('products').update({...}).eq('id', product.id)
```
[VERIFIED: lib/app/data/Product_DB.dart L35-48]

### Hapus produk (Admin)
```dart
supabase.from('products').delete().eq('id', id)
```
[VERIFIED: lib/app/data/Product_DB.dart L51-53]

---

## Tabel: `orders`

### Fetch semua order (Admin — diurutkan terbaru)
```dart
supabase.from('orders').select().order('created_at', ascending: false)
```
[VERIFIED: lib/app/data/Order_DB.dart L10-13]

### Update status order (Admin)
```dart
supabase.from('orders').update({'status': newStatus}).eq('id', orderId)
```
[VERIFIED: lib/app/data/Order_DB.dart L20-22]

### Buat order baru (User)
- [PERLU KONFIRMASI] Implementasi `insert` ke tabel `orders` tidak ditemukan secara eksplisit di controller `5_payment`. Perlu diperiksa lebih lanjut di `payment_controller.dart`.

---

## Supabase Storage

### Upload gambar produk
```dart
Supabase.instance.client.storage
  .from('menu-images')
  .upload(filePath, file)
```
[VERIFIED: lib/app/modules/admin_manage_menu/controllers/admin_manage_menu_controller.dart L84-86]
- File: `XFile` dari `image_picker`, dikompres 70%, max width 800px
- Nama file: `{timestamp}.{ext}` (misal: `1753245678901.jpg`)

### Get public URL gambar
```dart
Supabase.instance.client.storage
  .from('menu-images')
  .getPublicUrl(filePath)
```
[VERIFIED: lib/app/modules/admin_manage_menu/controllers/admin_manage_menu_controller.dart L89-91]

---

## Operasi yang Belum Diimplementasi (Temuan)

| Operasi | Status |
|---|---|
| Insert order baru | [PERLU KONFIRMASI] Tidak ditemukan di payment controller |
| Fetch order history user | [PERLU KONFIRMASI] Tidak ditemukan di modul user |
| Chat (kirim/terima pesan) | [VERIFIED] DUMMY — hardcoded, tidak ada API call |
| Persist favorit ke DB | Tidak ada — in-memory saja |
| Rating produk oleh user | Tidak ada — rating di-set manual |
