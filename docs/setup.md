# Setup Guide — Shori Dimsum Mobile App

> Panduan ini berdasarkan file konfigurasi aktual yang ada di repo.
> Langkah yang tidak bisa diverifikasi dari kode ditandai [PERLU KONFIRMASI].

---

## Prasyarat Sistem

| Tool | Versi Minimal | Cara Install |
|---|---|---|
| Flutter | SDK yang mendukung `^3.9.2` | https://docs.flutter.dev/get-started/install |
| Dart | Bundled dengan Flutter | — |
| Git | Any | https://git-scm.com |
| Node.js + npm | Any LTS | https://nodejs.org |
| Android Studio | Any | Untuk Android emulator + SDK |
| Xcode | Any (macOS only) | Untuk iOS simulator |

Verifikasi instalasi Flutter:
```bash
flutter doctor
```

---

## Langkah 1: Clone Repository

```bash
git clone <url-repository>
cd shori-dimsum_mobile-app
```

[PERLU KONFIRMASI] URL repository — tanyakan ke maintainer.

---

## Langkah 2: Install Flutter Dependencies

```bash
flutter pub get
```

[VERIFIED: pubspec.yaml ada dan valid] Ini akan menginstall semua dependency dari `pubspec.yaml`.

---

## Langkah 3: Install Node.js Dependencies (Supabase CLI)

```bash
npm install
```

[VERIFIED: package.json ada dengan dependency `supabase ^2.109.1`]
Ini menginstall Supabase CLI secara lokal.

---

## Langkah 4: Setup Environment Variables

Buat file `.env` di **root project** (sejajar dengan `pubspec.yaml`):

```bash
# Buat file .env
touch .env
```

Isi dengan kredensial Supabase project Anda:

```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

> ✅ File `.env` sudah terdaftar di `assets` di `pubspec.yaml` [VERIFIED: pubspec.yaml L65]
> — jadi Flutter akan otomatis menyertakannya sebagai asset.
>
> ❌ **JANGAN COMMIT file `.env`** — sudah ada di `.gitignore` [VERIFIED: .gitignore ada di root]

### Mendapatkan Kredensial Supabase
1. Login ke [supabase.com](https://supabase.com)
2. Pilih project Anda (atau buat baru)
3. Buka **Project Settings** → **API**
4. Copy **Project URL** → masukkan ke `SUPABASE_URL`
5. Copy **anon/public key** → masukkan ke `SUPABASE_ANON_KEY`

---

## Langkah 5: Setup Database Supabase

### Opsi A: Supabase Cloud (Hosted)

1. Buka Supabase Dashboard → **SQL Editor**
2. Copy isi file `supabase/migrations/20260723_initial_schema.sql` [VERIFIED]
3. Paste dan jalankan di SQL Editor
4. (Opsional) Copy isi `supabase/seed.sql` dan jalankan untuk data awal produk

### Opsi B: Supabase Lokal [PERLU KONFIRMASI]

```bash
# Pastikan Docker berjalan
npx supabase start
npx supabase db push

# Untuk seed data
npx supabase db seed
```

> [PERLU KONFIRMASI] Apakah project ini menggunakan Supabase Cloud atau lokal sebagai default dev environment?

---

## Langkah 6: Setup Admin User (Opsional, untuk Testing Admin)

1. Buka aplikasi dan register akun baru
2. Buka Supabase Dashboard → **SQL Editor**
3. Jalankan query:

```sql
UPDATE public.users SET role = 'admin' WHERE email = 'email-anda@contoh.com';
```

[VERIFIED: supabase/seed.sql L26 — instruksi ini ada di komentar seed]

---

## Langkah 7: Jalankan Aplikasi

```bash
# Cek device yang tersedia
flutter devices

# Jalankan di device default
flutter run

# Jalankan di device spesifik
flutter run -d <device-id>

# Contoh jalankan di Chrome (web)
flutter run -d chrome
```

---

## Troubleshooting Umum

### Error: SUPABASE_URL tidak ditemukan
- Pastikan file `.env` ada di root project (sejajar `pubspec.yaml`)
- Pastikan isi `.env` benar (tidak ada spasi, tidak ada tanda kutip)

### Error: flutter pub get gagal
```bash
flutter clean
flutter pub get
```

### Error: Supabase Auth gagal
- Periksa SUPABASE_URL dan SUPABASE_ANON_KEY di `.env`
- Pastikan **Email** auth provider diaktifkan di Supabase Dashboard → Authentication → Providers

### Error: Upload gambar gagal
- Pastikan bucket `menu-images` sudah dibuat (ada di migration)
- Pastikan policy storage sudah aktif

### Build error di Android
```bash
flutter clean
cd android && ./gradlew clean && cd ..
flutter run
```

---

## Menjalankan Linter

```bash
flutter analyze
```

[VERIFIED: analysis_options.yaml menggunakan `flutter_lints/flutter.yaml`]

---

## (Tidak Tersedia) Menjalankan Test

```bash
flutter test
```

> ⚠️ **Peringatan:** Satu-satunya file test (`test/widget_test.dart`) berisi template default Flutter yang tidak valid untuk proyek ini. Test ini akan **gagal**. Lihat [docs/testing-strategy.md](testing-strategy.md).
