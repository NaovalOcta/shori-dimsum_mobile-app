# Deployment — Shori Dimsum Mobile App

> [PERLU KONFIRMASI] Hampir seluruh bagian dokumen ini perlu dikonfirmasi oleh developer
> karena tidak ada script deploy eksplisit di repository.

---

## Status Deployment

[PERLU KONFIRMASI] Apakah aplikasi ini sudah pernah di-deploy ke production? Di mana?
- Google Play Store?
- Apple App Store?
- APK direct distribution?
- Hanya untuk demo/tugas akhir (tidak di-deploy ke store)?

---

## Build untuk Production

### Android (APK)

```bash
# Build APK release
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android (App Bundle — untuk Play Store)

```bash
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS (untuk App Store) — membutuhkan macOS + Xcode

```bash
flutter build ios --release
# Kemudian archive via Xcode
```

---

## Persiapan Sebelum Build Production

1. **Ganti `.env`** dengan URL dan key Supabase production (bukan development)
2. **Hapus `debugShowCheckedModeBanner: false`** sudah di-set [VERIFIED: lib/main.dart L21]
3. **Hapus semua `print()`** di kode production (atau aktifkan `avoid_print` di `analysis_options.yaml`)
4. **Optimasi asset** — terutama `start_bg.jpg` (3.2MB) [lihat ASSET-01 di known-issues.md]

---

## Konfigurasi Signing Android

[PERLU KONFIRMASI] Apakah sudah ada keystore untuk signing release APK?

```bash
# Generate keystore (jika belum ada)
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

---

## Backend Deployment

Backend aplikasi ini menggunakan **Supabase Cloud** (hosted) — tidak ada server yang perlu di-deploy.

Yang perlu dikelola di Supabase:
- Pastikan migration sudah dijalankan di project Supabase production
- Pastikan bucket `menu-images` ada dan policy storage sudah benar
- Aktifkan Email Auth provider di Supabase Dashboard

---

## CI/CD

[PERLU KONFIRMASI] Apakah ada pipeline CI/CD yang sudah disiapkan? (GitHub Actions, Codemagic, Bitrise, dll.)

Tidak ada file CI/CD ditemukan di repository ini.
