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
      // Menggunakan Background Image agar sama persis dengan User Home
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // 1. Background Image (Sesuai aset Home User)
          Positioned.fill(
            child: Image.asset(
              'assets/home_bg.jpg', // Menggunakan aset background dari folder assets
              fit: BoxFit.cover,
            ),
          ),

          // 2. Main Content
          Column(
            children: [
              const SizedBox(height: 200),

              // --- SEARCH BAR & FILTER ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    // Search Bar
                    Expanded(
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // REVISI: Sudut sedikit melengkung (15) sesuai tombol filter
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: controller.searchC,
                          onChanged: controller.searchProduct,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            hintText: "Search",
                            hintStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 16,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              size: 28,
                              color: Colors.black87,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),

                    // Filter Button (Menggunakan Image Asset filter_btn)
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: CustomColors.primaryColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {},
                            // Menggunakan aset filter_btn.png/jpg yang ada di folder assets
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                '/assets/filter_btn.png',
                                color: Colors
                                    .white, // Tint putih agar kontras dengan background maroon
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

              // --- STATISTIK ---
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
                    const SizedBox(width: 30),
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

              // --- LIST MENU ---
              Expanded(
                child: Obx(() {
                  if (controller.filteredProducts.isEmpty) {
                    return const Center(child: Text("No products found"));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      25,
                      10,
                      25,
                      130,
                    ), // Padding bawah ekstra untuk navbar
                    itemCount: controller.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = controller.filteredProducts[index];
                      // Simulasi status Sold Out (data asli nanti dari DB)
                      bool isSoldOut = index > 0 && index % 2 != 0;

                      return _buildAdminProductCard(product, isSoldOut);
                    },
                  );
                }),
              ),
            ],
          ),

          // --- 3. CUSTOM BOTTOM NAVBAR ---
          _buildAdminBottomBar(controller),
        ],
      ),
    );
  }

  // Widget Kartu Produk
  Widget _buildAdminProductCard(Product product, bool isSoldOut) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 115,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Gambar Produk
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                product.imagePath.isNotEmpty
                    ? product.imagePath[0]
                    : 'assets/products_placeholder.jpg',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Informasi Produk
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      // Pcs Unit
                      Text(
                        isSoldOut ? "0 pcs" : product.unitPieces,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  // Badge Status (Pill Shape)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isSoldOut
                            ? Colors.red
                            : const Color(0xFF52D726), // Hijau sesuai mockup
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isSoldOut ? "SOLD OUT" : "ACTIVE",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
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

  // Widget Bottom Navbar Admin
  Widget _buildAdminBottomBar(AdminHomeController controller) {
    const double barHeight = 80.0;
    const Color navColor = Color(0xFF550B18); // Maroon Gelap
    const Color iconColor = CustomColors.backgroundColor_1; // Cream

    return SizedBox(
      height: barHeight + 30, // Ruang untuk tombol plus menonjol
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Latar Belakang Lengkungan (CurvePainter)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: barHeight,
              child: CustomPaint(
                painter: CurvePainter(backgroundColor: navColor),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.home_filled,
                          color: iconColor,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.person_outline_rounded,
                          color: iconColor,
                          size: 30,
                        ),
                        onPressed: () => Get.toNamed('/profile'),
                      ),
                      const SizedBox(width: 60), // Spacer tengah
                      IconButton(
                        icon: const Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: iconColor,
                          size: 28,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.favorite_border_rounded,
                          color: iconColor,
                          size: 28,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Tombol Plus (+) Lingkaran Sempurna
          Positioned(
            bottom: 45, // Naik ke atas
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: navColor,
                shape: BoxShape.circle, // REVISI: LINGKARAN
                border: Border.all(
                  color: CustomColors.backgroundColor_1, // Border Cream Tebal
                  width: 5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: controller.toAddMenu,
                  child: const Center(
                    child: Icon(Icons.add, color: iconColor, size: 35),
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
