import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/data/Product_DB.dart';
import 'package:mobile_tugas_akhir/app/models/Product.dart';
import 'package:mobile_tugas_akhir/app/routes/app_pages.dart';

class AdminHomeController extends GetxController {
  // List Produk
  RxList<Product> allProducts = <Product>[].obs;
  RxList<Product> filteredProducts = <Product>[].obs;
  
  // Statistik
  RxInt totalMenu = 0.obs;
  RxInt menuHabis = 0.obs;

  // Search Controller
  TextEditingController searchC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // Ambil data produk (bisa dari Supabase via ProductDb)
  void fetchProducts() async {
    // Menggunakan ProductDb yang sudah ada
    List<Product> products = await ProductDb().fetchProducts();
    
    // Jika database kosong/gagal, pakai dummy untuk visualisasi sesuai mockup (Opsional)
    if (products.isEmpty) {
       // Logic fallback jika kosong, tapi idealnya dari DB
    }

    allProducts.assignAll(products);
    filteredProducts.assignAll(products);
    calculateStats();
  }

  void calculateStats() {
    totalMenu.value = allProducts.length;
    // Logika Menu Habis: 
    // Karena di model Product belum ada field 'stock', kita asumsikan 
    // jika rating 0 atau logic lain sebagai 'Sold Out' untuk demo visual.
    // Nanti Anda bisa tambahkan field 'stock' di database.
    // Di sini saya hitung dummy dulu agar sesuai mockup visual.
    menuHabis.value = allProducts.where((p) => p.name.contains("Habis") || p.rating == "0.0").length; 
  }

  void searchProduct(String query) {
    if (query.isEmpty) {
      filteredProducts.assignAll(allProducts);
    } else {
      filteredProducts.assignAll(allProducts.where((product) => 
        product.name.toLowerCase().contains(query.toLowerCase())
      ).toList());
    }
  }

  // Navigasi Tambah Menu (Tombol Plus)
  void toAddMenu() {
    // Arahkan ke halaman tambah produk (buat route baru nanti)
    Get.snackbar("Info", "Fitur Tambah Menu (Create) akan ada di sini");
    // Get.toNamed(Routes.ADD_PRODUCT); 
  }

  void toProductDetail(Product product) {
    // Admin mungkin ingin edit produk saat klik card
    Get.snackbar("Info", "Edit produk: ${product.name}");
  }
}