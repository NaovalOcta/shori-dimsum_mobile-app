# Environment Variables — Shori Dimsum Mobile App

> File ini mendaftar semua environment variable yang dibutuhkan aplikasi.
> **Jangan pernah menyimpan nilai asli (secret) di file ini.**
> Nilai asli hanya boleh ada di file `.env` lokal yang tidak di-commit.

---

## Variabel yang Digunakan [VERIFIED: lib/main.dart L15-16]

| Key | Digunakan di | Keterangan |
|---|---|---|
| `SUPABASE_URL` | `lib/main.dart` | URL project Supabase (format: `https://<id>.supabase.co`) |
| `SUPABASE_ANON_KEY` | `lib/main.dart` | Anonymous/public key Supabase |

---

## Template `.env`

Buat file `.env` di root project dengan isi berikut (ganti nilainya):

```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-supabase-anon-key-here
```

---

## Cara Mendapatkan Nilai

1. Login ke [supabase.com](https://supabase.com)
2. Pilih project → **Project Settings** → **API**
3. **Project URL** → `SUPABASE_URL`
4. **Project API Keys → anon public** → `SUPABASE_ANON_KEY`

---

## Cara `.env` Dimuat

[VERIFIED: lib/main.dart L11 dan pubspec.yaml L65]

```dart
// main.dart
await dotenv.load(fileName: ".env");
```

```yaml
# pubspec.yaml
flutter:
  assets:
    - .env
```

File `.env` dimuat sebagai Flutter asset melalui package `flutter_dotenv`. Ini berarti file `.env` di-bundle ke dalam APK/IPA. Pastikan nilai yang dimasukkan adalah **anon key** (bukan service role key).

---

## Keamanan

⚠️ **PENTING:**
- **JANGAN commit `.env`** ke repository — sudah ada di `.gitignore` [VERIFIED]
- `SUPABASE_ANON_KEY` adalah public key yang aman di-bundle, tapi akses data dilindungi oleh **Row Level Security (RLS)** [VERIFIED: supabase/migrations/20260723_initial_schema.sql]
- **JANGAN PERNAH** menggunakan `service_role` key di aplikasi mobile/client-side

---

## Catatan Tambahan

[PERLU KONFIRMASI] Apakah ada environment berbeda (development, staging, production)? Jika ya, nilai Supabase URL dan key mungkin berbeda per environment.
