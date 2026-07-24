# Database Schema — Shori Dimsum Mobile App

> Semua tabel, kolom, dan constraint diverifikasi langsung dari migration.
> Sumber: [VERIFIED: supabase/migrations/20260723_initial_schema.sql]

---

## Diagram Relasi

```
auth.users (Supabase Auth — built-in)
    │
    │ ON DELETE CASCADE
    ▼
public.users ──────────── (1 user → N orders)
    │                              │
    │                              ▼
    │                     public.orders
    │
    └── (tidak ada relasi langsung ke products)

public.products (standalone, dikelola admin)

storage.objects (Supabase Storage)
└── bucket: menu-images (gambar produk)
```

---

## Tabel: `public.users`

[VERIFIED: supabase/migrations/20260723_initial_schema.sql L11-20]

| Kolom | Tipe | Default | Nullable | Keterangan |
|---|---|---|---|---|
| `id` | UUID | — | NOT NULL (PK) | FK ke `auth.users(id)`, CASCADE delete |
| `email` | TEXT | — | Ya | Email user |
| `name` | TEXT | `'New User'` | Ya | Nama tampilan |
| `phone_number` | TEXT | `''` | Ya | Nomor telepon |
| `address` | TEXT | `''` | Ya | Alamat pengiriman |
| `profile_img` | TEXT | `''` | Ya | URL/path foto profil |
| `role` | TEXT | `'user'` | Ya | CHECK: `'user'` atau `'admin'` |
| `created_at` | TIMESTAMPTZ | `now()` | Ya | Waktu registrasi |

**Index:** `idx_users_email` pada kolom `email`

**Trigger:** `on_auth_user_created` — otomatis membuat baris di `public.users` saat user baru signup via Supabase Auth. Field yang diambil dari `raw_user_meta_data`: `name`, `phone_number`, `role`.

---

## Tabel: `public.products`

[VERIFIED: supabase/migrations/20260723_initial_schema.sql L30-40]

| Kolom | Tipe | Default | Nullable | Keterangan |
|---|---|---|---|---|
| `id` | UUID | `gen_random_uuid()` | NOT NULL (PK) | Auto-generated |
| `name` | TEXT | — | NOT NULL | Nama produk/menu |
| `price` | BIGINT | `0` | NOT NULL | Harga dalam Rupiah (integer, bukan desimal) |
| `description` | TEXT | `''` | Ya | Deskripsi produk |
| `category` | TEXT | `'General'` | Ya | Kategori produk |
| `unitpieces` | SMALLINT | `1` | Ya | Jumlah pcs per porsi (angka saja, misal: 16) |
| `image_path` | TEXT | `''` | Ya | URL publik gambar (dari Supabase Storage) |
| `rating` | TEXT | `'0.0'` | Ya | Rating sebagai string (misal: "4.9") |
| `created_at` | TIMESTAMPTZ | `now()` | Ya | Waktu dibuat |

**Index:**
- `idx_products_category` pada kolom `category`
- `idx_products_name` pada kolom `name`

> ⚠️ **Catatan penting:** Nama kolom di DB adalah `unitpieces` (lowercase), tapi di kode Flutter kadang dirujuk sebagai `unitPieces` atau `unit_pieces`. Ada fallback di `Product.fromMap()` [VERIFIED: lib/app/models/Product.dart L33].

> ⚠️ **Catatan:** `rating` disimpan sebagai TEXT, bukan numerik — ini membuat sorting by rating tidak akurat secara aritmetik.

---

## Tabel: `public.orders`

[VERIFIED: supabase/migrations/20260723_initial_schema.sql L51-58]

| Kolom | Tipe | Default | Nullable | Keterangan |
|---|---|---|---|---|
| `id` | UUID | `gen_random_uuid()` | NOT NULL (PK) | Auto-generated |
| `user_id` | UUID | — | Ya | FK ke `public.users(id)`, SET NULL on delete |
| `status` | TEXT | `'pending'` | Ya | CHECK: `pending`, `process`, `completed`, `cancelled` |
| `total_price` | BIGINT | `0` | Ya | Total harga pesanan (Rupiah) |
| `items_summary` | TEXT | `''` | Ya | Ringkasan item, contoh: "Siomay (2), Hakau (1)" |
| `created_at` | TIMESTAMPTZ | `now()` | Ya | Waktu pesanan dibuat |

**Index:**
- `idx_orders_user_id` pada kolom `user_id`
- `idx_orders_status` pada kolom `status`
- `idx_orders_created_at` pada kolom `created_at DESC`

> ⚠️ **Catatan:** Tidak ada tabel terpisah untuk `order_items`. Detail item disimpan sebagai teks di kolom `items_summary` — desain yang menyederhanakan implementasi tapi membatasi query/analitik per item.

---

## Row Level Security (RLS)

[VERIFIED: supabase/migrations/20260723_initial_schema.sql L93-196]

RLS diaktifkan untuk semua tabel (`users`, `products`, `orders`).

### Tabel `users`
| Policy | Operasi | Kondisi |
|---|---|---|
| Users can view own profile | SELECT | `auth.uid() = id` |
| Admins can view all users | SELECT | Role caller = `admin` |
| Users can update own profile | UPDATE | `auth.uid() = id` (kecuali `email` dan `role`) |
| Service role can insert users | INSERT | `true` (via trigger) |

### Tabel `products`
| Policy | Operasi | Kondisi |
|---|---|---|
| Authenticated users can view products | SELECT | `auth.role() = 'authenticated'` |
| Admins can insert/update/delete products | INSERT/UPDATE/DELETE | Role caller = `admin` |

### Tabel `orders`
| Policy | Operasi | Kondisi |
|---|---|---|
| Users can view own orders | SELECT | `auth.uid() = user_id` |
| Admins can view all orders | SELECT | Role caller = `admin` |
| Users can create orders | INSERT | `auth.uid() = user_id` |
| Admins can update orders | UPDATE | Role caller = `admin` |

---

## Supabase Storage

[VERIFIED: supabase/migrations/20260723_initial_schema.sql L200-274]

**Bucket:** `menu-images` (public = true)

| Policy | Operasi | Kondisi |
|---|---|---|
| Public images are viewable | SELECT | Semua (tanpa auth) |
| Users can upload images | INSERT | `authenticated` |
| Users can update their images | UPDATE | `authenticated` |
| Users can delete their images | DELETE | `authenticated` |

> [PERLU KONFIRMASI] Policy upload/update/delete berlaku untuk semua authenticated user — seharusnya dibatasi hanya untuk admin. Ini kemungkinan celah keamanan.

---

## Seed Data

[VERIFIED: supabase/seed.sql]

10 produk awal tersedia, kategori: `Dimsum`, `Classic`, `Popular`, `Topping`.

Contoh: `Dimsum Mental` (Rp 10.000, 16 pcs, rating "4.9"), `Hakau Udang` (Rp 11.500, 8 pcs, rating "4.8")
