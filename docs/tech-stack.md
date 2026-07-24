# Tech Stack — Shori Dimsum Mobile App

> Semua versi diverifikasi langsung dari file dependency.
> Tanggal verifikasi: **2026-07-23**

---

## Runtime Dependencies [VERIFIED: pubspec.yaml]

| Package | Versi (constraint) | Fungsi |
|---|---|---|
| `flutter` (SDK) | `sdk: ^3.9.2` | Framework utama (mobile, web, desktop) |
| `cupertino_icons` | `^1.0.8` | Icon bergaya iOS |
| `get` | `^4.7.3` | State management + navigation + DI (GetX) |
| `supabase_flutter` | `^2.0.0` | Client Supabase: Auth, Database, Storage |
| `flutter_dotenv` | `^5.1.0` | Load environment variables dari file `.env` |
| `image_picker` | `^1.2.1` | Pilih gambar dari galeri device |
| `intl` | `^0.20.2` | Format angka, tanggal, dan string internasional |

---

## Dev Dependencies [VERIFIED: pubspec.yaml]

| Package | Versi (constraint) | Fungsi |
|---|---|---|
| `flutter_test` (SDK) | bundled | Framework testing Flutter |
| `flutter_lints` | `^5.0.0` | Aturan lint standar Flutter |

---

## Tooling Node.js [VERIFIED: package.json]

| Package | Versi (constraint) | Fungsi |
|---|---|---|
| `supabase` (npm) | `^2.109.1` | Supabase CLI — untuk mengelola migration & schema |

> Catatan: `node_modules/` ada di root project (tidak lazim untuk project Flutter murni).
> Ini kemungkinan untuk menjalankan Supabase CLI lokal. [INFERENSI]

---

## Versi Terinstall (Resolved)

[PERLU KONFIRMASI] Untuk melihat versi pasti yang terinstall (resolved), jalankan:
```bash
flutter pub deps
```
File `pubspec.lock` berisi versi resolved lengkap [VERIFIED: pubspec.lock ada di root].

---

## Platform Target

[VERIFIED: direktori di root project]

| Platform | Status |
|---|---|
| Android | Ada folder `android/` |
| iOS | Ada folder `ios/` |
| Web | Ada folder `web/` |
| Linux | Ada folder `linux/` |
| macOS | Ada folder `macos/` |
| Windows | Ada folder `windows/` |

> [PERLU KONFIRMASI] Platform mana yang menjadi target utama pengembangan dan deployment?

---

## Komponen Backend (Supabase Cloud)

| Layanan | Penggunaan |
|---|---|
| Supabase Auth | Login, Register, Logout — via `supabase.auth` |
| PostgreSQL (Supabase DB) | Tabel `users`, `products`, `orders` |
| Supabase Storage | Bucket `menu-images` untuk gambar produk |

[VERIFIED: lib/main.dart, supabase/migrations/20260723_initial_schema.sql, lib/app/modules/admin_manage_menu/controllers/admin_manage_menu_controller.dart]

---

## Linting

[VERIFIED: analysis_options.yaml]
- Menggunakan `package:flutter_lints/flutter.yaml` (set lint standar Flutter)
- Tidak ada kustomisasi tambahan (semua rule dalam kondisi default/comment)
- Rule `avoid_print` dan `prefer_single_quotes` di-comment → **tidak aktif**
  - Ini berarti `print()` digunakan bebas di codebase saat ini (ada banyak `print()` di controller)
