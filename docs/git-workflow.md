# Git Workflow — Shori Dimsum Mobile App

> [PERLU KONFIRMASI] Git history tidak dapat dibaca secara otomatis dalam sesi ini.
> Seluruh bagian yang berkaitan dengan riwayat commit dan branching strategy
> perlu dikonfirmasi langsung oleh developer.

---

## Status Saat Ini

Repositori ini adalah **Git repository** (folder `.git/` ada di root) [VERIFIED: root directory].

### Informasi yang Perlu Dikonfirmasi oleh Developer

1. **Remote repository:** Di mana repo ini di-host? (GitHub / GitLab / Bitbucket / Private?)
2. **Branching strategy:** Apakah ada branch selain `main`/`master`? (misal: `dev`, `feature/*`, `release/*`)
3. **Commit convention:** Apakah ada format commit message yang disepakati? (Conventional Commits, dll.)
4. **Pull Request / Code Review:** Apakah ada proses review sebelum merge?
5. **Tag/Release:** Apakah ada tag versi yang sudah dibuat?

---

## Yang Dapat Diinferensi dari Kode

### Pola Perkembangan Fitur

Dari `lib/UpdateNote.txt` [VERIFIED: lib/UpdateNote.txt], terlihat ada 3 fase pengembangan:

- **V1:** UI, navigasi, logic pembelian, database dummy (JSON)
- **V2:** Login system, register system, bug fixes
- **V3:** Edit profil, save profil, search produk, filter produk, atribut ID, bug fixes

Ini mengindikasikan pengembangan iteratif, tapi tidak ada informasi tentang struktur branch.

### File yang Seharusnya Tidak Di-commit

[VERIFIED: .gitignore ada di root] Pastikan item berikut tidak masuk ke repository:
- `.env` — berisi kredensial Supabase
- `build/` — output build Flutter
- `node_modules/` — dependency npm
- `.dart_tool/` — cache Dart tools
- `supabase/.temp/` — cache Supabase CLI

---

## Rekomendasi Workflow (Template — Developer Perlu Konfirmasi/Sesuaikan)

[PERLU KONFIRMASI] Isi bagian ini berdasarkan praktik yang sudah digunakan tim.

```
# Template yang umum digunakan untuk proyek Flutter kecil:

main/master     ← production-ready code
    └── dev     ← development integration
         └── feature/{nama-fitur}   ← pengembangan fitur baru
         └── fix/{nama-bug}         ← perbaikan bug
```

### Format Commit (Jika Belum Ada, Ini Rekomendasi)

```
<type>: <deskripsi singkat>

type: feat | fix | refactor | docs | style | test | chore
```

Contoh:
- `feat: tambah fitur upload gambar produk`
- `fix: perbaiki bug login redirect admin`
- `refactor: migrasi Product_DB dari dummy ke Supabase`
- `docs: tambah dokumentasi baseline`
