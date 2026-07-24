# Testing Strategy — Shori Dimsum Mobile App

> Dokumen ini jujur tentang kondisi testing aktual proyek ini.
> Tidak ada test yang dikarang atau dilebih-lebihkan.

---

## Kondisi Testing Aktual

**Status: Hampir tidak ada automated testing.**

Satu-satunya file test yang ada adalah template bawaan Flutter:

```
test/
└── widget_test.dart   [VERIFIED — berisi template default, TIDAK VALID]
```

### Detail Masalah

[VERIFIED: test/widget_test.dart L14-16]
```dart
testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());  // ← MyApp TIDAK ADA di main.dart!
```

`MyApp` adalah class dari template default Flutter yang tidak dibuat di proyek ini. `main.dart` menggunakan `GetMaterialApp` langsung, bukan class terpisah bernama `MyApp`. **Test ini akan langsung gagal jika dijalankan.**

---

## Coverage Saat Ini

| Area | Status |
|---|---|
| Unit tests (controller) | ❌ Tidak ada |
| Widget tests (view) | ❌ Tidak ada |
| Integration tests | ❌ Tidak ada |
| Manual testing | ✅ Developer melakukan testing manual |

---

## Tantangan untuk Membuat Tests

Beberapa faktor di codebase saat ini menyulitkan penulisan unit test:

1. **`Product extends HomeController`** — Model yang extend Controller membuat unit test model membutuhkan GetX setup [VERIFIED: lib/app/models/Product.dart L4]
2. **Tidak ada interface untuk data layer** — `ProductDb`, `OrderDb`, `UserDb` tidak bisa di-mock tanpa refactoring [VERIFIED: lib/app/data/]
3. **Supabase client diinstansiasi langsung** — `Supabase.instance.client` sulit diganti dengan mock

---

## Rekomendasi (Jika Ingin Menambah Tests)

[PERLU KONFIRMASI] Apakah ada rencana menambahkan tests? Jika ya, prioritaskan:

### Prioritas 1: Perbaiki File Test yang Rusak
```dart
// test/widget_test.dart — hapus isi lama, ganti dengan:
void main() {
  // Tests belum diimplementasi
}
```

### Prioritas 2: Unit Test untuk Business Logic Murni
Yang bisa di-test tanpa Supabase:
- `FilterClass.handleFilterSelection()` — sorting logic
- `CategoryClass.toggleCategory()` — state toggle
- `LoginInputClass.isLoginFormatCorrect()` — validasi format

### Prioritas 3: Refactor untuk Testability
- Pisahkan interface untuk data layer
- Inject Supabase client via constructor (bukan `Supabase.instance.client`)

---

## Cara Menjalankan Tests (Jika Sudah Ada)

```bash
# Jalankan semua tests
flutter test

# Jalankan test dengan coverage
flutter test --coverage

# Lihat coverage report
genhtml coverage/lcov.info -o coverage/html
```

---

## Manual Testing Checklist [PERLU KONFIRMASI]

[PERLU KONFIRMASI] Apakah ada checklist manual testing yang biasa dijalankan sebelum release?
Developer perlu mengisi bagian ini.

Contoh checklist yang bisa dipakai:
- [ ] Login sebagai user biasa → berhasil masuk ke HomeView
- [ ] Login sebagai admin → berhasil masuk ke AdminHomeView
- [ ] Browse katalog → produk tampil dari Supabase
- [ ] Search produk → hasil filter sesuai
- [ ] Tambah produk (admin) + upload gambar → tampil di katalog
- [ ] Edit status pesanan → perubahan tersimpan di DB
- [ ] Edit profil → perubahan tersimpan
- [ ] Logout → session berakhir, redirect ke login
