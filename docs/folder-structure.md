# Folder Structure — Shori Dimsum Mobile App

> Semua path diverifikasi dari eksplorasi direktori aktual pada 2026-07-23.

---

## Root Project

```
shori-dimsum_mobile-app/
├── .env                          # Kredensial Supabase (JANGAN commit) [VERIFIED]
├── .gitignore                    # [VERIFIED]
├── .metadata                     # Metadata Flutter internal
├── .flutter-plugins-dependencies # Lock file plugin Flutter
├── .dart_tool/                   # Tool cache Dart
├── .idea/                        # IDE config (IntelliJ/Android Studio)
├── .vscode/                      # IDE config (VS Code)
├── analysis_options.yaml         # Konfigurasi linter [VERIFIED]
├── devtools_options.yaml         # Konfigurasi Flutter DevTools
├── pubspec.yaml                  # Dependency & metadata Flutter [VERIFIED]
├── pubspec.lock                  # Resolved dependency versions [VERIFIED]
├── package.json                  # Dependency Node.js (Supabase CLI) [VERIFIED]
├── package-lock.json             # Lock file npm
├── AGENTS.md                     # Panduan untuk AI agent [DIBUAT]
├── README.md                     # Dokumentasi setup [DIPERBARUI]
├── CHANGELOG.md                  # Riwayat perubahan [DIBUAT]
│
├── lib/                          # Source code Flutter utama
├── assets/                       # Asset gambar lokal
├── supabase/                     # Konfigurasi & migration Supabase
├── test/                         # File tes
├── docs/                         # Dokumentasi teknis [DIBUAT]
│
├── android/                      # Platform-specific: Android
├── ios/                          # Platform-specific: iOS
├── web/                          # Platform-specific: Web
├── linux/                        # Platform-specific: Linux
├── macos/                        # Platform-specific: macOS
├── windows/                      # Platform-specific: Windows
├── build/                        # Output build (jangan commit)
└── node_modules/                 # Dependency npm (jangan commit)
```

---

## `lib/` — Source Code Utama

```
lib/
├── main.dart                     # Entry point aplikasi [VERIFIED]
├── UpdateNote.txt                # Catatan versi developer (bukan docs resmi) [VERIFIED]
└── app/
    ├── data/                     # Data layer (Supabase operations)
    │   ├── Order_DB.dart         # CRUD tabel orders
    │   ├── Product_DB.dart       # CRUD tabel products
    │   └── User_DB .dart         # ⚠️ Nama file ada spasi (anomali!) — fetch users
    │
    ├── models/                   # Plain Dart classes (data models)
    │   ├── OrderModel.dart       # Model order
    │   ├── Product.dart          # Model produk (⚠️ extends HomeController — tidak lazim)
    │   └── User.dart             # Model user
    │
    ├── designs/                  # Design system
    │   └── colors/
    │       └── CustomColors.dart # Color tokens (maroon & cream palette)
    │
    ├── shared_widgets/           # Widget yang dipakai lintas modul
    │   └── Build_ProductItems.dart # Grid item produk (dipakai di catalog & favorit)
    │
    ├── routes/                   # Routing GetX
    │   ├── app_pages.dart        # Registrasi semua GetPage + initial route
    │   └── app_routes.dart       # Konstanta nama route (part of app_pages.dart)
    │
    └── modules/                  # Fitur-fitur aplikasi (17 modul)
        ├── 0_start/              # Splash/start screen
        ├── 1_login/              # Halaman login
        ├── 1_register/           # Halaman registrasi
        ├── 2_home/               # Home user (navigation bar)
        ├── 3_cart/               # Keranjang belanja
        ├── 3_contact/            # Halaman kontak
        ├── 3_favorite/           # Daftar favorit
        ├── 3_food_catalog/       # Katalog produk (search, filter, kategori)
        ├── 3_profile/            # Profil & edit profil
        ├── 4_product_info/       # Detail produk
        ├── 5_payment/            # Halaman pembayaran
        ├── 6_payment_complete/   # Konfirmasi pembayaran selesai
        ├── admin_chat/           # Inbox chat admin (DUMMY)
        ├── admin_chat_detail/    # Detail percakapan chat (DUMMY)
        ├── admin_home/           # Dashboard admin
        ├── admin_manage_menu/    # CRUD produk + upload gambar
        └── admin_orders/         # Kelola status pesanan
```

### Konvensi Prefix Angka pada Modules

[INFERENSI] Prefix angka pada folder module (`0_`, `1_`, `2_`, dst.) tampaknya merepresentasikan urutan user flow, bukan urutan teknis. Module admin tidak menggunakan prefix angka.

---

## `supabase/` — Backend Config

```
supabase/
├── config.toml                   # Konfigurasi Supabase CLI (panjang, 15KB)
├── seed.sql                      # Data awal 10 produk dimsum [VERIFIED]
├── migrations/
│   └── 20260723_initial_schema.sql  # Schema awal: users, products, orders, RLS [VERIFIED]
└── .temp/                        # Cache Supabase CLI (jangan commit)
```

---

## `assets/` — Asset Lokal

```
assets/
├── products_placeholder.jpg      # Gambar placeholder produk (46KB)
├── home_bg.jpg                   # Background halaman home (363KB)
├── flat_home_bg.jpg              # Variasi background home (170KB)
├── start_bg.jpg                  # Background halaman start (3.2MB — besar!)
├── sign_in_pattern.png           # Dekorasi halaman login (1.5MB)
├── sign_up_pattern.png           # Dekorasi halaman register (1.1MB)
├── sign_up_pattern1.png          # Duplikat sign_up_pattern.png? (1.1MB)
├── filter_btn.jpg                # Ikon tombol filter (11KB)
├── filter_btn.png                # Versi PNG tombol filter (1.4KB)
├── chat_send_icon.png            # Ikon kirim chat (1.7KB)
├── edit_prof_icon.png            # Ikon edit profil (1.8KB)
├── sign_out_icon.png             # Ikon logout (1.3KB)
└── success_icon.png              # Ikon pembayaran sukses (6.5KB)
```

> ⚠️ `start_bg.jpg` berukuran 3.2MB — perlu dioptimasi untuk performa load awal.
> ⚠️ `sign_up_pattern.png` dan `sign_up_pattern1.png` kemungkinan duplikat (ukuran sama).

---

## `test/` — File Tes

```
test/
└── widget_test.dart              # Template test default Flutter (bukan test actual app)
```

> [DRIFT TERDETEKSI] `widget_test.dart` masih berisi template "Counter increments smoke test" bawaan Flutter dan merujuk `MyApp` yang tidak ada. Test ini akan **gagal** jika dijalankan.

---

## `docs/` — Dokumentasi Teknis (Baru Dibuat)

```
docs/
├── architecture.md
├── tech-stack.md
├── database-schema.md
├── api-reference.md
├── folder-structure.md           # (file ini sendiri)
├── coding-standards.md
├── naming-conventions.md
├── git-workflow.md
├── feature-index.md
├── known-issues.md
├── setup.md
├── environment-variables.md
├── deployment.md
├── testing-strategy.md
├── decisions/
│   └── 0001-baseline-existing-system.md
└── plans/
    └── _TEMPLATE.md
```
