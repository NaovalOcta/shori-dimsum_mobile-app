# Known Issues & Technical Debt — Shori Dimsum Mobile App

> Ini adalah hasil paling berharga dari proses reverse-engineering.
> Semua item di sini ditemukan langsung dari kode — bukan asumsi.
> Tingkat keparahan: 🔴 Kritis | 🟡 Sedang | 🟢 Minor

---

## Arsitektur & Design

### [ARCH-01] 🔴 `Product` Extends `HomeController` — Tidak Lazim
**File:** [VERIFIED: lib/app/models/Product.dart L4]
```dart
class Product extends HomeController { ... }
```
Model **tidak seharusnya** extend Controller. Ini menciptakan coupling yang tidak perlu antara model data dan layer UI. Jika `HomeController` berubah, `Product` ikut terpengaruh. Ini adalah anti-pattern.

**Dampak:** Sulit untuk unit test `Product` karena membawa dependency GetX Controller.

---

### [ARCH-02] 🟡 Tidak Ada Interface/Abstract untuk Data Layer
**File:** lib/app/data/
Kelas `ProductDb`, `OrderDb`, `UserDb` tidak memiliki interface abstract. Ini membuat:
- Testing dengan mock sulit dilakukan
- Penggantian implementasi (misal: dari Supabase ke Firebase) butuh perubahan di banyak tempat

---

### [ARCH-03] 🟡 State Favorit & Cart Tidak Persist
**File:** [VERIFIED: lib/app/modules/3_food_catalog/controllers/food_catalog_controller.dart]
Favorit dan cart disimpan di in-memory state `FoodCatalogController`. Jika app di-restart atau `FoodCatalogController` di-dispose, semua data hilang.

---

### [ARCH-04] 🟡 Chat Fitur Sepenuhnya Dummy
**File:** [VERIFIED: lib/app/modules/admin_chat/controllers/admin_chat_controller.dart]
Fitur chat admin menggunakan data hardcoded. Tidak ada koneksi ke backend manapun. Pesan yang dikirim hanya masuk ke state lokal.

---

### [ARCH-05] 🟡 Route Chat Detail dengan Hardcoded Username
**File:** [VERIFIED: lib/app/routes/app_pages.dart L128]
```dart
GetPage(
  name: _Paths.ADMIN_CHAT_DETAIL,
  page: () => const AdminChatDetailView(userName: 'Customer 1'),
  ...
)
```
Nama user di-hardcode di routing definition, bukan dikirim via `Get.arguments`.

---

## File & Naming

### [FILE-01] 🟡 Nama File dengan Spasi
**File:** `lib/app/data/User_DB .dart` [VERIFIED]
Nama file ini memiliki spasi sebelum `.dart`. Ini bisa menyebabkan masalah di:
- File system yang case-sensitive (Linux/Mac)
- Beberapa CI/CD pipeline
- Import statement di Windows vs Unix bisa berbeda behavior

---

### [FILE-02] 🟢 Model & Data Files Menggunakan PascalCase
**File:** `Product.dart`, `User.dart`, `OrderModel.dart`, `Product_DB.dart`, dll.
Dart convention merekomendasikan snake_case untuk nama file (`product.dart`, `user.dart`). Controller, view, dan binding sudah benar, tapi model dan data layer tidak.

---

### [FILE-03] 🟢 File Backup Controller
**File:** [VERIFIED: lib/app/modules/3_food_catalog/controllers/catalog_controller_backup.txt]
Ada file `.txt` backup controller yang tidak terpakai. Seharusnya dihapus atau pindah ke `.git` (sudah tercatat di git history jika pernah di-commit).

---

## Database & Backend

### [DB-01] 🟡 `rating` Disimpan sebagai TEXT
**File:** [VERIFIED: supabase/migrations/20260723_initial_schema.sql L38]
```sql
rating TEXT DEFAULT '0.0'
```
Rating disimpan sebagai string. Ini menyebabkan sorting "Highest Rating" di `FilterClass` menggunakan string comparison, bukan numerik. Misal: "4.9" < "5.0" benar, tapi "4.10" > "4.9" (string sort) adalah salah.

---

### [DB-02] 🟡 Tidak Ada Tabel `order_items` — Detail Order Disimpan sebagai Teks
**File:** [VERIFIED: supabase/migrations/20260723_initial_schema.sql L56]
```sql
items_summary TEXT DEFAULT ''
```
Item pesanan disimpan sebagai ringkasan teks (contoh: "Siomay (2), Hakau (1)"). Tidak ada tabel relasional untuk item pesanan. Ini menyulitkan:
- Query pesanan per produk
- Analitik penjualan per item
- Refund/modifikasi per item

---

### [DB-03] 🟡 Kolom `unitpieces` — Case Sensitivity Mismatch
**File:** [VERIFIED: supabase/migrations/20260723_initial_schema.sql L36] dan [VERIFIED: lib/app/models/Product.dart L33]
DB: `unitpieces` (lowercase all), Kode: ada fallback untuk `unitPieces`, `unitpieces`, dan `unit_pieces`. Ini menandakan ada ketidakpastian penamaan kolom di antara developer.

---

### [DB-04] 🟡 Storage Policy Terlalu Permisif
**File:** [VERIFIED: supabase/migrations/20260723_initial_schema.sql L226-257]
Upload, update, dan delete gambar di bucket `menu-images` diizinkan untuk **semua** authenticated user. Seharusnya dibatasi hanya untuk admin.

---

### [DB-05] 🟢 Insert Order Tidak Ditemukan di Kode
**File:** lib/app/modules/5_payment/
Tidak ditemukan kode yang melakukan `insert` ke tabel `orders`. Kemungkinan belum diimplementasi atau ada di file yang belum diperiksa.

---

## Kode

### [CODE-01] 🟡 Banyak Kode Lama di-Comment (Dead Code)
**File:** login_controller.dart (~120 baris), profile_controller.dart (~40 baris), Product_DB.dart (~65 baris), User_DB .dart (~30 baris)
Kode lama (era dummy data) masih ada sebagai comment. Berguna sebagai histori pengembangan, tapi membuat file panjang dan membingungkan kontributor baru.

---

### [CODE-02] 🟡 `print()` Digunakan untuk Logging
**File:** Banyak controller — admin_manage_menu_controller.dart L67, L95, dll.
`print()` digunakan untuk debug output. Ini tidak terfilter di build production dan tidak bisa dikontrol per level (info/warn/error). Seharusnya menggunakan package `logger` atau minimal `debugPrint()`.

---

### [CODE-03] 🟡 Singleton Pattern Tidak Konsisten di Data Layer
**File:** [VERIFIED: lib/app/data/User_DB .dart L5-7] vs [VERIFIED: lib/app/data/Product_DB.dart L4]
`UserDb` menggunakan Singleton, `ProductDb` dan `OrderDb` tidak. Setiap pemanggilan `ProductDb()` dan `OrderDb()` membuat instance baru.

---

### [CODE-04] 🟡 `updateCloudDb()` — Fungsi Kosong
**File:** [VERIFIED: lib/app/modules/3_food_catalog/controllers/food_catalog_controller.dart L238-245]
```dart
void updateCloudDb() {
  // MASUKIN PENGUPDATEAN KE SUPABASE
  /* ... */
}
```
Fungsi kosong dengan comment TODO. Belum diimplementasi.

---

### [CODE-05] 🟢 Hard-coded String Pengiriman dalam `Product.getDeliveryInfo()`
**File:** [VERIFIED: lib/app/models/Product.dart L72]
```dart
String getDeliveryInfo() {
  return "Delivered between monday aug and thursday 20 from 8pm to 91:32 pm";
}
```
String ini jelas placeholder (jam "91:32" tidak valid). Belum dihapus atau diperbarui.

---

## Asset

### [ASSET-01] 🟡 `start_bg.jpg` Berukuran 3.2MB
**File:** [VERIFIED: assets/start_bg.jpg — 3.26MB]
File gambar background terlalu besar. Ini akan memperlambat waktu loading pertama aplikasi. Rekomendasikan kompres ke < 500KB.

---

### [ASSET-02] 🟢 Kemungkinan Duplikat Asset
**File:** [VERIFIED: assets/sign_up_pattern.png (1.09MB) dan assets/sign_up_pattern1.png (1.09MB)]
Kedua file memiliki ukuran yang sama persis. Kemungkinan duplikat.

---

### [ASSET-03] 🟢 Ada Dua Versi Filter Button
**File:** [VERIFIED: assets/filter_btn.jpg (11KB) dan assets/filter_btn.png (1.4KB)]
Dua format berbeda (JPG dan PNG) untuk button yang sama. Salah satunya tidak terpakai.

---

## Testing

### [TEST-01] 🔴 File Test Default Tidak Valid
**File:** [VERIFIED: test/widget_test.dart]
File test bawaan Flutter masih ada tanpa modifikasi, merujuk ke `MyApp` yang tidak ada di `main.dart`. Test ini akan **langsung gagal** jika dijalankan:
```dart
await tester.pumpWidget(const MyApp()); // MyApp tidak ada!
```
