# Shori Dimsum — Mobile App

Aplikasi mobile pemesanan dimsum untuk pelanggan dan admin, dibangun menggunakan Flutter + Supabase.

> **Catatan:** README ini diperbarui secara retroaktif pada 2026-07-23 berdasarkan kode aktual.
> README lama hanya berisi template default Flutter dan tidak mencerminkan proyek ini sama sekali.
> [DRIFT TERDETEKSI] README lama: "A new Flutter project" / "a starting point for a Flutter application" — tidak relevan.

---

## Prasyarat

Sebelum memulai, pastikan sudah terinstall:

- **Flutter SDK** — versi yang mendukung `sdk: ^3.9.2` [VERIFIED: pubspec.yaml]
- **Dart** (sudah termasuk dalam Flutter)
- **Android Studio / Xcode** — untuk menjalankan emulator/simulator
- **Node.js & npm** — untuk Supabase CLI [VERIFIED: package.json]
- **Git**

---

## Setup Lokal

### 1. Clone Repository

```bash
git clone <repo-url>
cd shori-dimsum_mobile-app
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Setup Environment Variables

Buat file `.env` di root project. File ini **tidak boleh di-commit** (sudah ada di `.gitignore`).

```env
SUPABASE_URL=https://<your-project-id>.supabase.co
SUPABASE_ANON_KEY=<your-anon-key>
```

> Untuk mendapatkan nilai ini: Login ke [supabase.com](https://supabase.com) → Project Settings → API.

Lihat detail: [docs/environment-variables.md](docs/environment-variables.md)

### 4. Setup Supabase (Database)

```bash
# Install Supabase CLI via npm (jika belum ada)
npm install

# [PERLU KONFIRMASI] Apakah project ini menggunakan Supabase lokal atau hosted?
# Jika hosted (Supabase Cloud): jalankan migration manual via Supabase Dashboard SQL Editor
# Jika lokal: supabase start && supabase db push

# Jalankan migration
# (via Supabase Dashboard > SQL Editor > paste isi file ini)
# supabase/migrations/20260723_initial_schema.sql

# Jalankan seed data (opsional, untuk data awal produk)
# supabase/seed.sql
```

Lihat detail: [docs/setup.md](docs/setup.md)

---

## Menjalankan Aplikasi

```bash
# Pastikan emulator/device sudah terhubung
flutter devices

# Jalankan aplikasi
flutter run

# Jalankan di device spesifik
flutter run -d <device-id>
```

---

## Akun untuk Testing

Setelah seed, buat user admin dengan:

```sql
-- Jalankan di Supabase SQL Editor SETELAH register manual
UPDATE public.users SET role = 'admin' WHERE email = 'admin@shoridimsum.com';
```

[PERLU KONFIRMASI] Tanyakan ke developer akun test mana yang aktif di environment Supabase yang terhubung.

---

## Struktur Utama

```
lib/
├── main.dart              # Entry point
└── app/
    ├── modules/           # Fitur-fitur (login, home, cart, admin, dst.)
    ├── data/              # Data layer (koneksi ke Supabase)
    ├── models/            # Model data (Product, User, OrderModel)
    ├── routes/            # Routing GetX
    ├── designs/           # Design system (warna)
    └── shared_widgets/    # Widget yang dipakai di banyak tempat
```

Lihat detail: [docs/folder-structure.md](docs/folder-structure.md)

---

## Dokumentasi Teknis

- [Arsitektur](docs/architecture.md)
- [Tech Stack](docs/tech-stack.md)
- [Database Schema](docs/database-schema.md)
- [Fitur Aktif](docs/feature-index.md)
- [Known Issues](docs/known-issues.md)
