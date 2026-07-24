# Coding Standards — Shori Dimsum Mobile App

> Dokumen ini mendeskripsikan pola yang **konsisten ditemukan** di kode aktual.
> Bukan standar ideal yang diinginkan, melainkan standar yang SUDAH dipakai.
> Inkonsistensi dicatat sebagai [DRIFT TERDETEKSI].

---

## 1. Struktur Modul

Setiap modul mengikuti struktur GetX CLI yang konsisten:

```
modules/<nama_modul>/
├── bindings/<nama>_binding.dart
├── controllers/<nama>_controller.dart
└── views/<nama>_view.dart
```

[VERIFIED: Konsisten di semua 17 modul yang diperiksa]

---

## 2. Controller Pattern

Pola yang ditemukan di **sebagian besar** controller:

```dart
class XxxController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchData(); // Fetch data saat controller init
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      // ...
    } catch (e) {
      Get.snackbar("Error", "$e");
    } finally {
      isLoading.value = false;
    }
  }
}
```

[VERIFIED: admin_orders_controller.dart, profile_controller.dart, admin_manage_menu_controller.dart]

---

## 3. Error Handling

- Error ditampilkan via `Get.snackbar()` [VERIFIED: Konsisten di semua controller yang dibaca]
- Tidak ada centralized error handler
- `print()` digunakan untuk debug logging (belum pakai `logger` package)
- [DRIFT TERDETEKSI] Beberapa error message dalam Bahasa Indonesia, sebagian dalam Bahasa Inggris — tidak konsisten

---

## 4. State Management

Pola reactive state yang konsisten:

```dart
RxList<Product> products = <Product>[].obs;
RxBool isLoading = false.obs;
RxInt selectedIndex = 0.obs;
```

Update state:
```dart
isLoading.value = true;
products.assignAll(data);
products.refresh();
```

[VERIFIED: food_catalog_controller.dart, admin_orders_controller.dart]

---

## 5. Supabase Calls

Pola direct call tanpa abstraksi tambahan:

```dart
// Di data layer (XxxDB):
final SupabaseClient client = Supabase.instance.client;
// atau (singleton pattern di UserDb):
final _supabase = Supabase.instance.client;
```

[DRIFT TERDETEKSI] `ProductDb` dan `OrderDb` menggunakan pola instance biasa, sedangkan `UserDb` menggunakan **Singleton pattern** (`static final _instance`) — tidak konsisten.

---

## 6. Model Parsing

Semua model punya factory `fromMap()`:

```dart
factory Product.fromMap(Map<String, dynamic> map) {
  return Product(
    id: map['id']?.toString() ?? '',
    // ...
  );
}
```

[VERIFIED: Product.dart, User.dart, OrderModel.dart]

---

## 7. Navigation

Navigasi menggunakan GetX named routes:

```dart
Get.toNamed(Routes.PRODUCT_INFO);   // Push
Get.back();                          // Pop
Get.offAllNamed(Routes.HOME);        // Replace stack
```

[VERIFIED: Konsisten di semua controller yang dibaca]

---

## 8. Kode yang Di-comment

[DRIFT TERDETEKSI — Kebijakan Tidak Jelas] Ada banyak kode lama yang di-comment (bukan dihapus):

- `login_controller.dart` — ~120 baris kode lama di-comment [VERIFIED]
- `profile_controller.dart` — ~40 baris kode lama di-comment [VERIFIED]
- `Product_DB.dart` — ~65 baris kode lama di-comment [VERIFIED]
- `User_DB .dart` — ~30 baris kode lama di-comment [VERIFIED]

Ini sisa migrasi dari dummy data ke Supabase. Berguna sebagai histori, tapi membuat file panjang dan sulit dibaca.

**Rekomendasi (untuk developer putuskan):** Apakah komentar lama ini akan tetap dipertahankan sebagai histori, atau dihapus? [PERLU KONFIRMASI]

---

## 9. Class Pembantu dalam Controller

Beberapa controller memiliki beberapa class dalam satu file:

- `food_catalog_controller.dart` — berisi `FilterClass`, `CategoryClass`, `ResponsivityClass`, `ProductsCatalogClass`, `FoodCatalogController` [VERIFIED]
- `login_controller.dart` — berisi `LoginInputClass` dan `LoginController` [VERIFIED]
- `home_controller.dart` — berisi `MenuNavBarClass` dan `HomeController` [VERIFIED]

[INFERENSI] Ini pola yang dipilih developer untuk mengelompokkan logika yang berhubungan, bukan satu-controller-satu-class.

---

## 10. Widget Build Function vs Widget Class

`Build_ProductItems.dart` mendefinisikan widget sebagai **function** (`Widget buildProductItems(...)`) bukan class `StatelessWidget`.

[DRIFT TERDETEKSI] Ini tidak konsisten dengan pola Flutter yang direkomendasikan (class > function untuk reuse dan performance). Sisanya menggunakan class.

---

## 11. Dart Code Style

- Menggunakan `const` pada widget yang static [INFERENSI — terlihat di beberapa `const SizedBox()`]
- Tidak menggunakan `prefer_single_quotes` (rule di-comment di `analysis_options.yaml`) — string menggunakan mix single dan double quotes [DRIFT TERDETEKSI]
- `avoid_print` juga tidak aktif — `print()` digunakan bebas di controller
