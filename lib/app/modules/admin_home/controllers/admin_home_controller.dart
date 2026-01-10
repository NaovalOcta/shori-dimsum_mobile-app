import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/data/Product_DB.dart';
import 'package:mobile_tugas_akhir/app/models/Product.dart';

class AdminHomeController extends GetxController {
  // --- Reactive Variables ---
  RxList<Product> allProducts = <Product>[].obs;
  RxList<Product> filteredProducts = <Product>[].obs;
  RxInt totalMenu = 0.obs;
  RxInt menuHabis = 0.obs;
  RxBool isLoading = true.obs;

  // Variabel untuk menyimpan filter yang aktif
  // Value: 'name_asc', 'name_desc', 'pcs_asc', 'pcs_desc'
  RxString currentSort = 'name_asc'.obs;

  TextEditingController searchC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      List<Product> products = await ProductDb().fetchProducts();

      allProducts.assignAll(products);
      filteredProducts.assignAll(products);

      // Terapkan sort default setelah fetch
      applySort(currentSort.value);
      calculateStats();
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // --- LOGIKA FILTER / SORTING ---
  void applySort(String sortType) {
    currentSort.value = sortType; // Simpan status sort

    switch (sortType) {
      case 'name_asc': // A - Z
        filteredProducts.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;
      case 'name_desc': // Z - A
        filteredProducts.sort(
          (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
        );
        break;
      case 'pcs_asc': // Sedikit - Banyak
        filteredProducts.sort(
          (a, b) =>
              _getPcsCount(a.unitPieces).compareTo(_getPcsCount(b.unitPieces)),
        );
        break;
      case 'pcs_desc': // Banyak - Sedikit
        filteredProducts.sort(
          (a, b) =>
              _getPcsCount(b.unitPieces).compareTo(_getPcsCount(a.unitPieces)),
        );
        break;
    }
  }

  // Helper: Mengambil angka dari string "16 pcs" -> 16
  int _getPcsCount(String pcsString) {
    try {
      // Hapus semua karakter non-digit, lalu parse ke int
      String numbers = pcsString.replaceAll(RegExp(r'[^0-9]'), '');
      return int.parse(numbers);
    } catch (e) {
      return 0; // Default jika gagal parse
    }
  }

  void calculateStats() {
    totalMenu.value = allProducts.length;
    menuHabis.value = allProducts.where((p) {
      String stockStr = p.unitPieces.toLowerCase().replaceAll(
        RegExp(r'[^0-9]'),
        '',
      );
      int stock = int.tryParse(stockStr) ?? 1;
      return stock == 0 || p.name.toLowerCase().contains('habis');
    }).length;
  }

  void searchProduct(String query) {
    if (query.isEmpty) {
      filteredProducts.assignAll(allProducts);
    } else {
      filteredProducts.assignAll(
        allProducts
            .where(
              (product) =>
                  product.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
    }
    // Tetap terapkan sort saat searching
    applySort(currentSort.value);
  }

  void toAddMenu() {
    Get.snackbar("Info", "Masuk ke halaman CRUD Menu");
  }
}
