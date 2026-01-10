import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/designs/colors/CustomColors.dart';
import 'package:mobile_tugas_akhir/app/models/Product.dart';
import 'package:mobile_tugas_akhir/app/modules/2_home/views/CustomBottomNavBar.dart';
import '../controllers/admin_home_controller.dart';

class AdminHomeView extends GetView<AdminHomeController> {
  const AdminHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Background
          Positioned.fill(
            child: Image.asset('assets/home_bg.jpg', fit: BoxFit.cover),
          ),

          // Main Content
          Column(
            children: [
              const SizedBox(height: 200),

              // Search Bar & Filter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: controller.searchC,
                          onChanged: controller.searchProduct,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            hintText: "Search",
                            prefixIcon: Icon(Icons.search, size: 28),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),

                    // --- TOMBOL FILTER (Interaktif) ---
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: CustomColors.primaryColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: CustomColors.primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _showFilterBottomSheet(
                              context,
                            ), // Panggil BottomSheet
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                '/assets/filter_btn.png',
                                color: Colors.white,
                                errorBuilder: (c, o, s) =>
                                    const Icon(Icons.tune, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Statistik
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Obx(
                      () => Text(
                        "Total Menu: ${controller.totalMenu.value}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3E2723),
                        ),
                      ),
                    ),
                    const SizedBox(width: 25),
                    Obx(
                      () => Text(
                        "Menu Habis: ${controller.menuHabis.value}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3E2723),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // List Product
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.allProducts.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: CustomColors.primaryColor,
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.fetchProducts,
                    color: CustomColors.primaryColor,
                    child: controller.filteredProducts.isEmpty
                        ? ListView(
                            children: const [
                              SizedBox(height: 100),
                              Center(child: Text("No products found")),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(25, 10, 25, 140),
                            itemCount: controller.filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product =
                                  controller.filteredProducts[index];
                              bool isSoldOut =
                                  product.name.toLowerCase().contains(
                                    'habis',
                                  ) ||
                                  product.unitPieces.startsWith('0');
                              return _buildCard(product, isSoldOut);
                            },
                          ),
                  );
                }),
              ),
            ],
          ),

          _buildNavBar(controller),
        ],
      ),
    );
  }

  // --- FILTER MODAL BOTTOM SHEET ---
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          Colors.transparent, // Transparan agar bisa bikin rounded custom
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ukuran menyesuaikan konten
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul & Indikator Geser
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Filter Menu",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Serif',
                  color: Color(0xFF3E2723),
                ),
              ),

              const SizedBox(height: 25),

              // Opsi 1: Nama
              const Text(
                "Urutkan Nama",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildFilterChip("A - Z", "name_asc"),
                  const SizedBox(width: 15),
                  _buildFilterChip("Z - A", "name_desc"),
                ],
              ),

              const SizedBox(height: 25),

              // Opsi 2: Porsi (Pcs)
              const Text(
                "Urutkan Porsi",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildFilterChip("Sedikit - Banyak", "pcs_asc"), // Ascending
                  const SizedBox(width: 15),
                  _buildFilterChip(
                    "Banyak - Sedikit",
                    "pcs_desc",
                  ), // Descending
                ],
              ),

              const SizedBox(height: 40),

              // Tombol Terapkan
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // Tutup modal
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    "Terapkan Filter",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // Widget Kecil untuk Pilihan Filter (Chip)
  Widget _buildFilterChip(String label, String value) {
    return Obx(() {
      bool isSelected = controller.currentSort.value == value;
      return GestureDetector(
        onTap: () => controller.applySort(value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? CustomColors.primaryColor : Colors.grey[100],
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isSelected ? CustomColors.primaryColor : Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      );
    });
  }

  // --- Widget Card & Navbar (Tetap Sama) ---
  Widget _buildCard(Product product, bool isSoldOut) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                product.imagePath.isNotEmpty
                    ? product.imagePath[0]
                    : 'assets/products_placeholder.jpg',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (c, o, s) =>
                    Container(width: 90, height: 90, color: Colors.grey[200]),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E2723),
                            height: 1.1,
                          ),
                        ),
                      ),
                      Text(
                        isSoldOut ? "0 pcs" : product.unitPieces,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isSoldOut ? Colors.red : const Color(0xFF52D726),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isSoldOut ? "SOLD OUT" : "ACTIVE",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar(AdminHomeController controller) {
    return SizedBox(
      height: 110,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 65,
              child: CustomPaint(
                painter: CurvePainter(backgroundColor: const Color(0xFF550B18)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.home_filled,
                          color: Color(0xFFFFF8E1),
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.receipt_long_rounded,
                          color: Color(0xFFFFF8E1),
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 80),
                      IconButton(
                        icon: const Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: Color(0xFFFFF8E1),
                          size: 28,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.person_outline_rounded,
                          color: Color(0xFFFFF8E1),
                          size: 30,
                        ),
                        onPressed: () => Get.toNamed('/profile'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF550B18),
                shape: BoxShape.circle,
                // Border dihapus agar tidak ada kuning/bg
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: InkWell(
                onTap: controller.toAddMenu,
                borderRadius: BorderRadius.circular(100),
                child: const Center(
                  child: Icon(
                    Icons.restaurant_menu_rounded,
                    color: Color(0xFFFFF8E1),
                    size: 34,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
