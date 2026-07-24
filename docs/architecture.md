# Arsitektur — Shori Dimsum Mobile App

> Dokumen ini mendeskripsikan pola arsitektur yang **terdeteksi** dari kode aktual,
> bukan arsitektur ideal yang direncanakan.
> Semua klaim ditandai dengan tag verifikasi.

---

## Pola Utama: GetX MVC per Modul

[INFERENSI] Berdasarkan struktur folder `lib/app/modules/`, setiap fitur diorganisir dalam folder mandiri yang masing-masing berisi tiga sub-folder: `bindings/`, `controllers/`, dan `views/`. Ini adalah konvensi standar GetX CLI.

```
modules/
└── <nama_fitur>/
    ├── bindings/     # Dependency injection: daftarkan controller ke Get
    ├── controllers/  # Business logic & state management (GetxController)
    └── views/        # UI (StatelessWidget/StatefulWidget)
```

[VERIFIED: lib/app/modules/2_home/] — Struktur ini konsisten di semua 17 modul.

---

## Lapisan Aplikasi

### Layer 1: Presentation (Views)
- Widget Flutter yang merender UI
- Menggunakan `Obx()` untuk reactive binding ke state di controller
- Tidak mengandung business logic

### Layer 2: Controller (GetX)
- Mengextend `GetxController`
- Mengelola state dengan variabel `Rx` (`RxList`, `RxBool`, `RxInt`, dll.)
- Memanggil layer Data untuk operasi database

### Layer 3: Data
- Kelas-kelas di `lib/app/data/` yang berinteraksi langsung dengan Supabase
- [VERIFIED: lib/app/data/Product_DB.dart] — `ProductDb` melakukan CRUD ke tabel `products`
- [VERIFIED: lib/app/data/Order_DB.dart] — `OrderDb` melakukan fetch & update status orders
- [VERIFIED: lib/app/data/User_DB .dart] — `UserDb` melakukan fetch users (singleton pattern)

> [INFERENSI] Layer ini berfungsi mirip Repository pattern, tapi tidak diformalkan dengan interface/abstract class.

### Layer 4: Models
- Plain Dart class di `lib/app/models/`
- Semua model memiliki factory constructor `fromMap()` untuk parsing response Supabase
- [VERIFIED: lib/app/models/Product.dart, User.dart, OrderModel.dart]

---

## Routing

Menggunakan **GetX Named Routes** [VERIFIED: lib/app/routes/app_routes.dart]:
- Semua route didefinisikan sebagai konstanta string di `_Paths`
- `AppPages.routes` mendaftarkan setiap route dengan page + binding-nya
- Initial route: `/start` → `StartView` [VERIFIED: lib/app/routes/app_pages.dart]

---

## Dependency Injection

GetX Bindings digunakan untuk lazy injection:
- Setiap modul punya `XxxBinding` yang mendaftarkan controller
- Controller di-inject saat route aktif dan dibuang saat route keluar (kecuali `Get.lazyPut` dengan `fenix: true`)

---

## State Management

- **Reactive state**: `RxList`, `RxBool`, `RxInt`, `Rx<T>` — diobservasi via `Obx()`
- **Shared state lintas modul**: `FoodCatalogController` diakses dari modul lain via `Get.find<FoodCatalogController>()`
  - [VERIFIED: lib/app/shared_widgets/Build_ProductItems.dart]
  - [VERIFIED: lib/app/modules/admin_manage_menu/controllers/admin_manage_menu_controller.dart]

---

## Backend: Supabase

[VERIFIED: lib/main.dart] — Supabase diinisialisasi di `main()` sebelum `runApp()`.

Layanan Supabase yang digunakan:
1. **Supabase Auth** — login, register, logout, session
2. **Supabase Database** (PostgreSQL) — CRUD tabel `users`, `products`, `orders`
3. **Supabase Storage** — bucket `menu-images` untuk gambar produk

---

## Flow Autentikasi

```
StartView
    │
    ▼
LoginView ──────── (Supabase Auth: signInWithPassword)
    │
    ├── role == 'admin' ──► AdminHomeView
    │
    └── role == 'user'  ──► HomeView
```

[VERIFIED: lib/app/modules/1_login/controllers/login_controller.dart]

---

## Catatan Arsitektural

### Yang Berjalan Baik
- Modularisasi per fitur konsisten
- State management reaktif dengan GetX

### Yang Perlu Perhatian
- [INFERENSI] Tidak ada pemisahan interface untuk data layer — testing sulit karena tidak bisa mock `ProductDb`, `OrderDb`
- [VERIFIED: lib/app/models/Product.dart L4] `Product extends HomeController` — ini tidak lazim; model tidak seharusnya extend controller
- Chat belum terintegrasi ke backend apapun [VERIFIED: admin_chat_controller.dart — semua data hardcoded]
- Favorit dan cart tidak persist (hanya in-memory state)
