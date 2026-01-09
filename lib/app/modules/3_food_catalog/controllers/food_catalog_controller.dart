import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_tugas_akhir/app/data/Product_DB.dart';
import 'package:mobile_tugas_akhir/app/designs/colors/CustomColors.dart';
import 'package:mobile_tugas_akhir/app/models/Product.dart';
import 'package:mobile_tugas_akhir/app/routes/app_pages.dart';

class FilterClass {
  // late final FoodCatalogController fCC = Get.find<FoodCatalogController>(); // INI LOOPING DIPANGGIL TERUS
  final List<String> filterOptionsList = [
    'Pilih Opsi',
    'A-Z',
    'Z-A',
    'Highest Price',
    'Lowest Price',
    'Highest Rating',
    'Lowest Rating',
  ];
  final RxString currentFilter = 'Pilih Opsi'.obs;
  final RxString latestFilter = 'Pilih Opsi'.obs;

  void handleFilterSelection(String selection, FoodCatalogController fCC) {
    if (selection != currentFilter.value) {
      currentFilter.value = selection;

      int optionIndex = filterOptionsList.indexOf(selection);
      switch (optionIndex) {
        case 0:
          fCC.productClass.searchProducts.isEmpty
              ? fCC.productClass.products.sort((a, b) => a.id.compareTo(b.id))
              : fCC.productClass.searchProducts.sort(
                  (a, b) => a.id.compareTo(b.id),
                );
          break;
        case 1:
          fCC.productClass.searchProducts.isEmpty
              ? fCC.productClass.products.sort(
                  (a, b) => a.name.compareTo(b.name),
                )
              : fCC.productClass.searchProducts.sort(
                  (a, b) => a.name.compareTo(b.name),
                );
          break;
        case 2:
          fCC.productClass.searchProducts.isEmpty
              ? fCC.productClass.products.sort(
                  (a, b) => b.name.compareTo(a.name),
                )
              : fCC.productClass.searchProducts.sort(
                  (a, b) => b.name.compareTo(a.name),
                );
          break;
        case 3:
          fCC.productClass.searchProducts.isEmpty
              ? fCC.productClass.products.sort(
                  (a, b) => b.price.compareTo(a.price),
                )
              : fCC.productClass.searchProducts.sort(
                  (a, b) => b.price.compareTo(a.price),
                );
          break;
        case 4:
          fCC.productClass.searchProducts.isEmpty
              ? fCC.productClass.products.sort(
                  (a, b) => a.price.compareTo(b.price),
                )
              : fCC.productClass.searchProducts.sort(
                  (a, b) => a.price.compareTo(b.price),
                );
          break;
        case 5:
          fCC.productClass.searchProducts.isEmpty
              ? fCC.productClass.products.sort(
                  (a, b) => a.rating.compareTo(b.rating),
                )
              : fCC.productClass.searchProducts.sort(
                  (a, b) => a.rating.compareTo(b.rating),
                );
          break;
        case 6:
          fCC.productClass.searchProducts.isEmpty
              ? fCC.productClass.products.sort(
                  (a, b) => b.rating.compareTo(a.rating),
                )
              : fCC.productClass.searchProducts.sort(
                  (a, b) => b.rating.compareTo(a.rating),
                );
          break;
        default:
          break;
      }
    }
  }

  Color changeTextColor(String choosenFilter) {
    return choosenFilter == currentFilter.value ? Colors.blue : Colors.black;
  }

  Color get changeIconColor {
    return currentFilter.value != 'Pilih Opsi' ? Colors.white : Colors.white;
  }
}

class CategoryClass {
  final List<String> categoryNameList = [
    'All',
    'Dimsum',
    'Topping',
    'Classic',
    'Popular',
  ];
  final RxList<bool> categorySelectionStateList = [
    true,
    false,
    false,
    false,
    false,
  ].obs;
  final RxString selectedCategory = 'All'.obs;

  void toggleCategory(int newIndex) {
    int currentIndex = categorySelectionStateList.indexOf(true);
    if (newIndex == currentIndex) return;
    if (currentIndex != -1) categorySelectionStateList[currentIndex] = false;

    categorySelectionStateList[newIndex] = true;
    selectedCategory.value = categoryNameList[newIndex];
    // Get.log('Selected category: ${selectedCategory.value}');
  }

  Color changeTextColor(int index) {
    return categorySelectionStateList.value[index] == true
        ? Colors.white
        : Colors.black54;
  }

  Color changeBgColor(int index) {
    return categorySelectionStateList.value[index] == true
        ? CustomColors.primaryColor
        : Colors.white;
  }

  Color changeBorderColor(int index) {
    return categorySelectionStateList.value[index] == true
        ? Colors.white
        : Colors.black54;
  }
}

class ResponsivityClass {
  RxInt gridCrossAxisCount = 2.obs;
  RxDouble topMargin = 100.0.obs;

  void updateWidgetOnRotation(Orientation orientation) {
    if (isLandscape(orientation)) {
      gridCrossAxisCount.value = 4;
      topMargin.value = 0.0;
    } else {
      gridCrossAxisCount.value = 2;
      topMargin.value = 100.0;
    }
  }

  bool isLandscape(Orientation orientation) {
    return orientation == Orientation.landscape;
  }
}

class ProductsCatalogClass {
  final TextEditingController searchController = TextEditingController();

  RxList products = <Product>[].obs;
  RxList favProductIds = <int>[].obs;
  RxList cartProductsIds = <int>[].obs;
  RxList searchProducts = <Product>[].obs;
  RxInt selectedProductId = 0.obs;

  void toggleFavProduct(int productIndex) {
    // product referensi ke fav product dan product biasa
    Product product = products[productIndex];

    if (product.isFavorite.value) {
      favProductIds.remove(productIndex);
      product.isFavorite.value = false;
    } else {
      favProductIds.add(productIndex);
      product.isFavorite.value = true;
    }
  }

  void addCartProduct(int productIndex) {
    if (!cartProductsIds.contains(productIndex)) {
      cartProductsIds.add(productIndex);
      Get.toNamed(Routes.CART);
    } else if (cartProductsIds.contains(productIndex)) {
      Get.snackbar(
        'Informasi',
        'Product sudah ada pada cart Anda !',
        colorText: Colors.white,
        backgroundColor: CustomColors.primaryColor,
      );
    }
  }

  void deleteCartProduct(int productIndex) {
    if (cartProductsIds.contains(productIndex)) {
      Product selectedProduct = products[productIndex];
      selectedProduct.orderQuantity.value = 1;
      cartProductsIds.remove(productIndex);
    }
  }

  void increaseUnitQuantity(int productIndex) {
    Product selectedProduct = products[productIndex];
    selectedProduct.orderQuantity++;
  }

  void lowerUnitQuantity(int productIndex) {
    Product selectedProduct = products[productIndex];
    if (selectedProduct.orderQuantity > 1) selectedProduct.orderQuantity--;
  }

  void setSelectedProductId(int productId) {
    selectedProductId.value = productId;
  }

  String getFormattedPrice(Product product) {
    return "Rp. ${product.price.toString()}";
  }

  void searchFilteredProducts(String newValue) {
    searchProducts.value = products.where((product) {
      final String filteredProductName = product.name.toLowerCase();
      return filteredProductName.contains(newValue);
    }).toList();
  }

  void updateCloudDb() {
    // MASUKIN PENGUPDATEAN KE SUPABASE
    /*
    Hal-hal yang diperlukan
    1. Identify selected user
    2. Update Product DB tergantung hasil login User
    */
  }

  void resetCart() {
    for (int cartId in cartProductsIds) {
      Product productInCart = products[cartId];
      productInCart.orderQuantity.value = 1;
    }

    selectedProductId.value = 0;
    cartProductsIds.clear();
  }
}

class FoodCatalogController extends GetxController {
  final FilterClass filterClass = FilterClass();
  final CategoryClass categoryClass = CategoryClass();
  final ResponsivityClass responsiveClass = ResponsivityClass();
  final ProductsCatalogClass productClass = ProductsCatalogClass();

  @override
  void onInit() {
    super.onInit();

    fetchProduct();
    // productClass.products.addAll(ProductDb().productDataList);
  }

  void fetchProduct() async {
    productClass.products.addAll(await ProductDb().fetchProducts());
  }
}
