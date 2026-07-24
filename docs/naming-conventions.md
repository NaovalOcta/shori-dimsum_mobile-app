# Naming Conventions — Shori Dimsum Mobile App

> Konvensi yang BENAR-BENAR DIPAKAI di kode aktual, bukan yang ideal.
> Inkonsistensi dicatat sebagai [DRIFT TERDETEKSI].

---

## File & Folder

### Folder Modul
Pattern: `{angka}_{nama_fitur}` (user flow) atau `admin_{nama_fitur}` (admin)

```
0_start/
1_login/
1_register/
2_home/
3_cart/
3_contact/
3_favorite/
3_food_catalog/
3_profile/
4_product_info/
5_payment/
6_payment_complete/
admin_chat/
admin_chat_detail/
admin_home/
admin_manage_menu/
admin_orders/
```

[VERIFIED: lib/app/modules/]

### File Dart — Controller, View, Binding
Pattern: `{nama_modul}_{tipe}.dart` dalam snake_case

```
login_controller.dart
login_view.dart
login_binding.dart
food_catalog_controller.dart
admin_manage_menu_controller.dart
```

[VERIFIED: Konsisten di semua modul]

### File Dart — Model & Data Layer
[DRIFT TERDETEKSI] Inkonsistensi antara snake_case dan PascalCase:

| File | Naming Style |
|---|---|
| `lib/app/models/Product.dart` | PascalCase |
| `lib/app/models/User.dart` | PascalCase |
| `lib/app/models/OrderModel.dart` | PascalCase |
| `lib/app/data/Product_DB.dart` | PascalCase + underscore |
| `lib/app/data/Order_DB.dart` | PascalCase + underscore |
| `lib/app/data/User_DB .dart` | PascalCase + underscore + **SPASI** |
| `lib/app/shared_widgets/Build_ProductItems.dart` | PascalCase + underscore |
| `lib/app/designs/colors/CustomColors.dart` | PascalCase |

**Model dan data file menggunakan PascalCase** (berbeda dari Dart convention yang merekomendasikan snake_case untuk file). Controller, view, dan binding file sudah mengikuti snake_case.

---

## Class Names

Semua class menggunakan PascalCase — konsisten:

```dart
class LoginController extends GetxController {}
class ProductDb {}
class UserDb {}
class OrderDb {}
class Product {}
class User {}
class OrderModel {}
class FoodCatalogController extends GetxController {}
class AdminManageMenuController extends GetxController {}
```

[VERIFIED: Konsisten di semua file yang dibaca]

---

## Variabel & Field

### State Reaktif (Rx variables)
Pattern: `{namaVariabel}` + `.obs` postfix

```dart
RxList<Product> products = <Product>[].obs;
RxBool isLoading = false.obs;
RxInt selectedProductId = 0.obs;
Rx<File?> selectedImage = Rx<File?>(null);
RxString currentFilter = 'Pilih Opsi'.obs;
```

[VERIFIED: Konsisten di semua controller]

### TextEditingController
[DRIFT TERDETEKSI] Dua pola berbeda ditemukan:

```dart
// Pola 1: Singkat (admin_manage_menu_controller.dart)
TextEditingController nameC = TextEditingController();
TextEditingController priceC = TextEditingController();

// Pola 2: Panjang (profile_controller.dart)
final TextEditingController nameC = TextEditingController();
final TextEditingController emailC = TextEditingController();
```

### Boolean flag
```dart
RxBool isLoading = false.obs;
RxBool isEditMode = false.obs;
RxBool isPasswordViewable = false.obs;
RxBool isProfileEditable = false.obs;
```

Pattern konsisten: prefix `is` untuk boolean state.

---

## Route Names

Konstanta route menggunakan SCREAMING_SNAKE_CASE:

```dart
static const HOME = '/home';
static const ADMIN_HOME = '/admin-home';
static const FOOD_CATALOG = '/food-catalog';
static const PAYMENT_COMPLETE = '/payment-complete';
```

[VERIFIED: lib/app/routes/app_routes.dart]

URL path menggunakan kebab-case: `/admin-home`, `/food-catalog`, `/payment-complete`

---

## Database Column Names

[VERIFIED: supabase/migrations/20260723_initial_schema.sql]

Kolom database menggunakan snake_case:
- `user_id`, `total_price`, `items_summary`, `created_at`
- `phone_number`, `profile_img`, `image_path`
- `unitpieces` (lowercase semua — **bukan** `unit_pieces`)

### Mapping DB Column → Dart Field
[DRIFT TERDETEKSI] Tidak konsisten antara nama DB dan nama field Dart:

| DB Column | Dart Field | File |
|---|---|---|
| `phone_number` | `phoneNumber` | User.dart |
| `profile_img` | `profileImg` | User.dart |
| `image_path` | `imagePath` | Product.dart |
| `unitpieces` | `unitPieces` | Product.dart |
| `total_price` | `totalPrice` | OrderModel.dart |
| `items_summary` | `itemsSummary` | OrderModel.dart |
| `user_id` | `userId` | OrderModel.dart |
| `created_at` | `createdAt` | OrderModel.dart |

Pola: DB column (snake_case) → Dart field (camelCase) — ini sudah benar dan konsisten.

---

## Asset Names

[VERIFIED: assets/]

Asset menggunakan snake_case:
- `home_bg.jpg`, `start_bg.jpg`, `sign_in_pattern.png`
- `products_placeholder.jpg`, `filter_btn.png`, `success_icon.png`

Semua konsisten dalam snake_case.
