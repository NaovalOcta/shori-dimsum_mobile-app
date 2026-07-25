    # ADR 0001: Baseline — Dokumentasi Retroaktif Sistem yang Sudah Ada

**Status:** Diterima  
**Tanggal:** 2026-07-23  
**Penulis:** AI Agent (reverse-engineering dari kode aktual)

---

## Konteks

Proyek **Shori Dimsum Mobile App** sudah berjalan (dalam tahap pengembangan aktif berdasarkan `UpdateNote.txt`) tanpa dokumentasi teknis formal. Seluruh dokumentasi di direktori `docs/` dibuat secara **retroaktif** pada tanggal tersebut di atas.

Dokumentasi dibuat berdasarkan eksplorasi kode aktual — bukan dari asumsi atau rencana awal pengembangan.

---

## Keputusan

Dokumentasi baseline dibuat pada 2026-07-23 untuk:
1. Merekam kondisi sistem saat ini sebagai titik referensi
2. Menyediakan panduan bagi developer dan AI agent berikutnya
3. Mengidentifikasi technical debt yang ada

---

## Kondisi Sistem Saat Baseline Dibuat

### Tech Stack
- Flutter (SDK ^3.9.2) + Dart
- GetX ^4.7.3 (state management + routing + DI)
- Supabase Flutter ^2.0.0 (Auth + Database + Storage)
- flutter_dotenv ^5.1.0 (env config)
- image_picker ^1.2.1 (upload gambar)

### Database (Supabase PostgreSQL)
- Tabel: `public.users`, `public.products`, `public.orders`
- 1 migration file: `20260723_initial_schema.sql`
- Row Level Security: aktif di semua tabel
- Storage bucket: `menu-images` (public)

### Status Fitur
- ✅ Authentication (login/register via Supabase Auth)
- ✅ Role-based access (user vs admin)
- ✅ Katalog produk dengan search & filter
- ✅ Cart (in-memory)
- ✅ Admin CRUD produk + upload gambar
- ✅ Admin kelola status order
- ⚠️ Chat (DUMMY — hardcoded)
- ⚠️ Favorit (in-memory, tidak persist)
- ❓ Payment (route ada, implementasi belum dikonfirmasi penuh)

### Status Testing
- ❌ Tidak ada automated test yang valid
- File test default Flutter belum dimodifikasi dan tidak valid

### Technical Debt Utama (Saat Baseline)
1. `Product extends HomeController` — anti-pattern
2. Nama file dengan spasi (`User_DB .dart`)
3. Asset besar belum dioptimasi (`start_bg.jpg` 3.2MB)
4. Tidak ada interface untuk data layer (sulit di-test/mock)
5. `rating` disimpan sebagai TEXT di database
6. Kode lama banyak di-comment (dead code)

---

## Konsekuensi

- Semua dokumentasi di `docs/` adalah baseline, bukan histori lengkap
- Developer yang bekerja setelah tanggal ini harus memperbarui `CHANGELOG.md` untuk setiap perubahan signifikan
- Known issues di `docs/known-issues.md` adalah backlog yang perlu diselesaikan
