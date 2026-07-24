2# AGENTS.md — Shori Dimsum Mobile App

> Dokumen ini adalah **entry point untuk AI agent** yang bekerja di repo ini.
> Baca seluruh dokumen ini sebelum membuat perubahan apa pun.
> Dibuat secara retroaktif pada **2026-07-23** berdasarkan kode aktual yang ada.

---

## Ringkasan Proyek

**Shori Dimsum** adalah aplikasi mobile pemesanan dimsum yang dibangun dengan Flutter.
Aplikasi ini melayani dua jenis pengguna: **pelanggan** (user) dan **admin**.

- Package name: `mobile_tugas_akhir` [VERIFIED: pubspec.yaml]
- App title: `"Dimsum"` [VERIFIED: lib/main.dart]
- Versi: `1.0.0+1` [VERIFIED: pubspec.yaml]
- Konteks: Proyek tugas akhir (berdasarkan nama package dan `lib/UpdateNote.txt`)

---

## Tech Stack Terverifikasi

| Komponen | Teknologi | Versi |
|---|---|---|
| Framework | Flutter | SDK ^3.9.2 [VERIFIED: pubspec.yaml] |
| Bahasa | Dart | — |
| State Management | GetX (`get`) | ^4.7.3 [VERIFIED: pubspec.yaml] |
| Backend-as-a-Service | Supabase | `supabase_flutter` ^2.0.0 [VERIFIED: pubspec.yaml] |
| Environment Config | flutter_dotenv | ^5.1.0 [VERIFIED: pubspec.yaml] |
| Image Picker | image_picker | ^1.2.1 [VERIFIED: pubspec.yaml] |
| Date/Number Formatting | intl | ^0.20.2 [VERIFIED: pubspec.yaml] |
| Supabase CLI (dev tool) | supabase (npm) | ^2.109.1 [VERIFIED: package.json] |

---

## Arsitektur Singkat

Pola yang digunakan: **GetX MVC per modul** (diinferensi dari struktur folder `modules/`).

```
lib/app/
├── data/          # Data layer — direct Supabase calls (bukan Repository pattern formal)
├── models/        # Plain Dart classes (Product, User, OrderModel)
├── modules/       # Setiap fitur = 1 folder, berisi bindings/ controllers/ views/
├── routes/        # Routing GetX (app_pages.dart + app_routes.dart)
├── designs/       # Color tokens (CustomColors)
└── shared_widgets/ # Widget yang dipakai lintas modul
```

Lihat detail: [docs/architecture.md](docs/architecture.md)

---

## Dua Peran Pengguna [VERIFIED: supabase/migrations/20260723_initial_schema.sql]

- **`user`** — Pelanggan: browse menu, cart, payment, profil
- **`admin`** — Admin: kelola menu (CRUD), lihat semua pesanan, update status, chat (dummy)

Role disimpan di kolom `role` tabel `public.users`. Redirect dilakukan di `login_controller.dart` setelah fetch role.

---

## Fitur Aktif (dari Routes + Controllers)

**Pelanggan:**
- Login / Register (Supabase Auth)
- Browse katalog produk (search + filter + kategori)
- Favorit produk (state in-memory, tidak persist ke DB)
- Cart (state in-memory)
- Checkout / Payment
- Halaman konfirmasi pembayaran
- Edit profil (nama, alamat, telepon)
- Kontak (belum ada implementasi backend)

**Admin:**
- Dashboard admin
- Kelola menu: tambah, edit, hapus produk + upload gambar ke Supabase Storage
- Lihat & update status pesanan (`pending` → `process` → `completed` / `cancelled`)
- Chat (DUMMY — data hardcoded, tidak ada backend)

---

## Hal Kritis untuk AI Agent

1. **Jangan hapus komentar lama** — banyak kode lama di-comment sebagai referensi migrasi dari dummy data ke Supabase. Ini berharga untuk histori.
2. **Package name adalah `mobile_tugas_akhir`** [VERIFIED: pubspec.yaml] — pakai ini saat `import`.
3. **`.env` tidak boleh di-commit** — berisi kredensial Supabase. Sudah ada di `.gitignore`.
4. **Supabase Storage bucket: `menu-images`** [VERIFIED: supabase/migrations/20260723_initial_schema.sql] — jangan ubah nama bucket tanpa update di controller.
5. **Fitur Chat adalah DUMMY** [VERIFIED: lib/app/modules/admin_chat/controllers/admin_chat_controller.dart] — data hardcoded. Belum ada backend chat.
6. **Favorit tidak persist** — disimpan sebagai state in-memory di `FoodCatalogController`. Jika app di-restart, favorit hilang.
7. **File `User_DB .dart` memiliki spasi pada namanya** — [VERIFIED: lib/app/data/User_DB .dart] — ini anomali dan bisa menyebabkan masalah di beberapa OS.

---

## Dokumentasi Lengkap

| Dokumen | Topik |
|---|---|
| [README.md](README.md) | Setup & cara menjalankan aplikasi |
| [docs/architecture.md](docs/architecture.md) | Pola arsitektur yang terdeteksi |
| [docs/tech-stack.md](docs/tech-stack.md) | Semua dependency + versi |
| [docs/database-schema.md](docs/database-schema.md) | Schema DB dari migration |
| [docs/api-reference.md](docs/api-reference.md) | Endpoint / operasi Supabase yang dipakai |
| [docs/folder-structure.md](docs/folder-structure.md) | Penjelasan tiap folder |
| [docs/coding-standards.md](docs/coding-standards.md) | Pola yang ditemukan di kode |
| [docs/naming-conventions.md](docs/naming-conventions.md) | Konvensi penamaan aktual |
| [docs/git-workflow.md](docs/git-workflow.md) | Workflow git |
| [docs/feature-index.md](docs/feature-index.md) | Daftar fitur aktif |
| [docs/known-issues.md](docs/known-issues.md) | Technical debt & inkonsistensi |
| [docs/setup.md](docs/setup.md) | Langkah setup lengkap |
| [docs/environment-variables.md](docs/environment-variables.md) | Daftar env var |
| [docs/deployment.md](docs/deployment.md) | Info deployment |
| [docs/testing-strategy.md](docs/testing-strategy.md) | Kondisi testing aktual |
| [docs/decisions/0001-baseline-existing-system.md](docs/decisions/0001-baseline-existing-system.md) | ADR baseline |
| [CHANGELOG.md](CHANGELOG.md) | Riwayat perubahan |
