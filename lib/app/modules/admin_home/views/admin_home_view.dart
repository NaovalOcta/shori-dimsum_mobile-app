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
      backgroundColor: CustomColors.backgroundColor_1, // Cream Background
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // --- Main Content ---
          Column(
            children: [
              const SizedBox(height: 60), // Top Margin
              // 1. Header (Title Besar & Logo Image)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Shori Dimsum",
                            style: TextStyle(
                              fontFamily: 'Serif', // Font Serif sesuai mockup
                              fontSize: 36, // UKURAN DIPERBESAR
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF3E2723),
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Order your favourite dimsum!",
                            style: TextStyle(
                              fontSize: 16, // UKURAN DIPERBESAR
                              color: Colors.brown.shade400,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // LOGO SHORI DIMSUM (Bukan Tombol Toko)
                    Container(
                      width: 60,
                      height: 60,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          15,
                        ), // Sudut rounded kotak
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/logo_icon.png', // Pastikan asset ini ada
                          fit: BoxFit.contain,
                          errorBuilder: (c, o, s) => const Icon(
                            Icons.restaurant,
                            color: CustomColors.primaryColor,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 2. Search Bar & Filter (Sudut Sedikit Melengkung)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // REVISI: Sudut tidak full melengkung (15), mirip tombol filter
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: controller.searchC,
                          onChanged: controller.searchProduct,
                          style: const TextStyle(fontSize: 18),
                          decoration: const InputDecoration(
                            hintText: "Search",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              size: 30,
                              color: Colors.black87,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),

                    // Tombol Filter (Maroon)
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: CustomColors.primaryColor,
                        borderRadius: BorderRadius.circular(
                          15,
                        ), // Sama dengan Search
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.tune,
                          color: CustomColors.backgroundColor_1,
                          size: 28,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 3. Stats Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Obx(
                      () => Text(
                        "Total Menu: ${controller.totalMenu.value}",
                        style: const TextStyle(
                          fontSize: 16,
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3E2723),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // 4. List Menu
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
                      120,
                    ), // Padding bawah besar utk navbar
                    itemCount: controller.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = controller.filteredProducts[index];
                      // Dummy logic untuk status sold out visual sesuai mockup
                      bool isSoldOut = index > 0 && index % 2 != 0;

                      return _buildAdminProductCard(product, isSoldOut);
                    },
                  );
                }),
              ),
            ],
          ),

          // 5. Custom Bottom Nav Bar
          _buildAdminBottomBar(controller),
        ],
      ),
    );
  }

  // --- Widget: Product Card ---
  Widget _buildAdminProductCard(Product product, bool isSoldOut) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 120, // Tinggi card
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25), // Rounded lebih besar
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                product.imagePath.isNotEmpty
                    ? product.imagePath[0]
                    : 'assets/products_placeholder.jpg',
                width: 95,
                height: 95,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Info Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 18, bottom: 18, right: 20),
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
                            fontSize: 18,
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
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // Status Badge Pill
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSoldOut
                            ? Colors.red
                            : const Color(0xFF52D726), // Hijau neon mockup
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isSoldOut ? "SOLD OUT" : "ACTIVE",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
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

  // --- Widget: Bottom Navbar Admin ---
  Widget _buildAdminBottomBar(AdminHomeController controller) {
    const double barHeight = 80.0;

    // Warna Navbar: Maroon Gelap (Secondary Color)
    const Color navColor = Color(0xFF550B18);
    // Warna Icon: Cream
    const Color iconColor = CustomColors.backgroundColor_1;

    return SizedBox(
      height:
          barHeight + 35, // Tinggi total termasuk tombol floating yang menonjol
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Background Curve
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: barHeight,
              child: CustomPaint(
                painter: CurvePainter(backgroundColor: navColor),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Kiri
                      IconButton(
                        icon: const Icon(
                          Icons.home_filled,
                          color: iconColor,
                          size: 32,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.person_outline_rounded,
                          color: iconColor,
                          size: 32,
                        ),
                        onPressed: () => Get.toNamed('/profile'),
                      ),

                      const SizedBox(
                        width: 60,
                      ), // Space tengah untuk tombol plus
                      // Kanan
                      IconButton(
                        icon: const Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: iconColor,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.favorite_border_rounded,
                          color: iconColor,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Floating Action Button (+) - REVISI: LINGKARAN SEMPURNA
          Positioned(
            bottom: 45, // Posisi naik ke atas curve
            child: Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                color: navColor, // Warna Maroon Gelap
                shape: BoxShape.circle, // LINGKARAN
                border: Border.all(
                  color: CustomColors.backgroundColor_1, // Border Cream Tebal
                  width: 6,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
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
                    child: Icon(
                      Icons.add,
                      color: iconColor, // Icon Cream
                      size: 38,
                    ),
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
