// Class CustomPainter untuk menggambar lekukan
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/designs/colors/CustomColors.dart';
import 'package:mobile_tugas_akhir/app/modules/2_home/controllers/home_controller.dart';
import 'package:mobile_tugas_akhir/app/modules/3_food_catalog/controllers/food_catalog_controller.dart';
import 'package:mobile_tugas_akhir/app/routes/app_pages.dart';

class CurvePainter extends CustomPainter {
  final Color backgroundColor;

  CurvePainter({required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Definisikan Titik dan Ukuran
    final height = size.height;
    final width = size.width;
    final center = width / 2;
    // Radius lingkaran (misalnya 32.0, harus disesuaikan dengan ukuran tombol +)
    const buttonRadius = 32.0; 
    // 2. Buat objek cat (Paint) untuk mengisi warna latar belakang
    final paint = Paint()..color = backgroundColor;

    // 3. Mulai membuat Path (jalur bentuk)
    var path = Path();
    // Mulai dari kiri bawah (titik 0)
    path.moveTo(0, height); 
    // Pindah ke sudut kiri atas (titik A)
    path.lineTo(0, 0);
    // Pindah ke titik sebelum lekukan dimulai (titik B)
    path.lineTo(center - (buttonRadius + 50), 0);
    
    // --- Bagian Lekukan ke Atas (Kiri Lekukan) ---
    // Titik Kontrol Pertama (Control Point 1)
    var controlPoint1 = Offset(center - 50, 0);
    var endPoint1 = Offset(center - 30, 20);
    path.quadraticBezierTo(
      controlPoint1.dx, controlPoint1.dy, 
      endPoint1.dx, endPoint1.dy
    );
    
    // --- Bagian Lengkungan Lingkaran (Center Curve) ---
    // Titik Kontrol Kedua (Control Point 2)
    var controlPoint2 = Offset(center, buttonRadius + 20);
    // Titik Akhir Lengkungan Lingkaran (End Point 2)
    var endPoint2 = Offset(center + buttonRadius, 20);
    // Gambarkan kurva Bezier Q(E1, C2, E2)
    path.quadraticBezierTo(
      controlPoint2.dx, controlPoint2.dy, 
      endPoint2.dx, endPoint2.dy
    );

    // --- Bagian Lekukan ke Bawah (Kanan Lekukan) ---
    // Titik Kontrol Ketiga (Control Point 3)
    var controlPoint3 = Offset(center + 50, 0);
    // Titik Akhir Lekukan Ketiga (End Point 3)
    var endPoint3 = Offset(center + buttonRadius + 40, 0);
    // Gambarkan kurva Bezier Q(E2, C3, E3)
    path.quadraticBezierTo(
      controlPoint3.dx, controlPoint3.dy, 
      endPoint3.dx, endPoint3.dy
    );
    
    // Pindah ke sudut kanan atas (titik D)
    path.lineTo(width, 0);
    // Pindah ke sudut kanan bawah (titik E)
    path.lineTo(width, height);
    // Tutup jalur (menyambung ke titik awal)
    path.close();

    // Gambar Path pada Canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CustomBottomBar extends GetView<HomeController> {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final FoodCatalogController fCC = Get.find<FoodCatalogController>();

    const double barHeight = 60.0;
    const double plusBottomMargin = 10.0;
    const double plusRadius = 32.0;

    return Stack(
      alignment: Alignment.bottomCenter, 
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: barHeight,
            child: CustomPaint(
              painter: CurvePainter(backgroundColor: CustomColors.primaryColor), 
              child: Obx(() {
                final menuNavbarClass = controller.navbarClass;
                final isSelected = controller.navbarClass.navItemSelectionStateList.value;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(
                        isSelected[0] ? Icons.home : Icons.home_outlined, 
                        color: isSelected[0] ? Colors.white : CustomColors.backgroundColor_1, 
                        size: 28
                      ),
                      onPressed: () {
                        menuNavbarClass.toggleNavSelectionState(0);
                        fCC.filterClass.handleFilterSelection(fCC.filterClass.latestFilter.value, fCC);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        isSelected[1] ? Icons.favorite : Icons.favorite_border, 
                        color: isSelected[1] ? Colors.white : CustomColors.backgroundColor_1, 
                        size: 28
                      ),
                      onPressed: () {
                        menuNavbarClass.toggleNavSelectionState(1);
                        fCC.filterClass.latestFilter.value = fCC.filterClass.currentFilter.value;
                        fCC.filterClass.handleFilterSelection('Pilih Opsi', fCC);
                      },
                    ),
                    const SizedBox(width: plusRadius * 2), 
                    IconButton(
                      icon: Icon(
                        isSelected[2] ? Icons.chat : Icons.chat_outlined, 
                        color: isSelected[2] ? Colors.white : CustomColors.backgroundColor_1, 
                        size: 28
                      ),
                      onPressed: () {
                        menuNavbarClass.toggleNavSelectionState(2);
                      }
                    ),
                    IconButton(
                      icon: Icon(
                        isSelected[3] ? Icons.person_2 : Icons.person_2_outlined, 
                        color: isSelected[3] ? Colors.white : CustomColors.backgroundColor_1, 
                        size: 28
                      ),
                      onPressed: () {
                        menuNavbarClass.toggleNavSelectionState(3);
                      },
                    ),
                  ],
                );
              })
            ),
          ),
        ),
        Positioned(
          bottom: barHeight - plusRadius + plusBottomMargin,
          child: FloatingActionButton(
            backgroundColor: CustomColors.primaryColor,
            shape: const CircleBorder(),
            child: Icon(Icons.shopping_cart_rounded, 
              color: CustomColors.backgroundColor_1, 
              size: 30
            ),
            onPressed: () => Get.toNamed(Routes.CART),
          ),
        ),
      ],
    );
  }
}
