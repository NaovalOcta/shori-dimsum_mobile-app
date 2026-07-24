# Template Rencana Fitur — Shori Dimsum Mobile App

> Salin file ini ke `docs/plans/<nama-fitur>.md` untuk merencanakan fitur baru.
> Isi setiap bagian. Hapus bagian yang tidak relevan.

---

# [Nama Fitur]

**Status:** Draft / Disetujui / Sedang Dikerjakan / Selesai  
**Tanggal dibuat:** YYYY-MM-DD  
**Developer:** [nama]  
**Estimasi:** [waktu pengerjaan]

---

## Latar Belakang

Jelaskan mengapa fitur ini diperlukan. Masalah apa yang dipecahkan?

---

## Deskripsi Fitur

Jelaskan fitur secara singkat dari perspektif pengguna.

**User story:**
> Sebagai [role], saya ingin [melakukan sesuatu], agar [mendapat manfaat].

---

## Scope

### Yang Akan Dikerjakan (In Scope)
- [ ] Item 1
- [ ] Item 2

### Yang Tidak Dikerjakan (Out of Scope)
- Item yang sengaja tidak dimasukkan

---

## Perubahan Database

Apakah fitur ini membutuhkan perubahan schema?

```sql
-- Migration yang diperlukan (jika ada)
```

---

## Perubahan UI

- Module baru: `lib/app/modules/X_<nama>/`
- Route baru: [PERLU KONFIRMASI] nama route
- Widget baru: —

---

## Perubahan Data Layer

Operasi Supabase baru yang diperlukan:
- `supabase.from('...').select/insert/update/delete()`

---

## Ketergantungan

Apakah fitur ini bergantung pada fitur lain? Atau fitur lain bergantung padanya?

---

## Catatan Teknis

Hal-hal yang perlu diperhatikan saat implementasi.

---

## Acceptance Criteria

Bagaimana menentukan bahwa fitur ini selesai?

- [ ] Kriteria 1
- [ ] Kriteria 2

---

## Status Progress

- [ ] Design / Planning
- [ ] Implementasi
- [ ] Testing manual
- [ ] Code review
- [ ] Merge ke main
