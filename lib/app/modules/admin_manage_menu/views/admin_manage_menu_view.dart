import 'dart:io'; // Import Dart IO untuk File
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/designs/colors/CustomColors.dart';
import '../controllers/admin_manage_menu_controller.dart';

class AdminManageMenuView extends GetView<AdminManageMenuController> {
  const AdminManageMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor_1,
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundColor_1,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF3E2723),
              size: 24,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        centerTitle: true,
        title: Text(
          controller.isEditMode.value ? "Edit Menu" : "New Menu",
          style: const TextStyle(
            fontFamily: 'Serif',
            color: Color(0xFF3E2723),
            fontWeight: FontWeight.w900,
            fontSize: 24,
          ),
        ),
        actions: [
          if (controller.isEditMode.value)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
                onPressed: controller.deleteProduct,
              ),
            ),
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: CustomColors.primaryColor,
                ),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- 1. IMAGE UPLOAD SECTION (TAP TO PICK) ---
                    Center(
                      child: GestureDetector(
                        onTap: controller.pickImage, // KLIK UNTUK BUKA GALERI
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.brown.withOpacity(0.1),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child:
                                    _buildImagePreview(), // Fungsi Helper Preview Gambar
                              ),
                            ),
                            // Floating Edit Icon (Visual cue)
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: CustomColors.primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: CustomColors.backgroundColor_1,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        "Tap to change image",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- 2. FORM INPUTS ---
                    _buildLabel("Product Name"),
                    _buildCustomInput(
                      controller: controller.nameC,
                      hint: "e.g. Siomay Ayam Udang",
                      icon: Icons.fastfood_outlined,
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Price (IDR)"),
                              _buildCustomInput(
                                controller: controller.priceC,
                                hint: "15000",
                                icon: Icons.attach_money_rounded,
                                isNumber: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Unit (Pcs)"),
                              _buildCustomInput(
                                controller: controller.piecesC,
                                hint: "4",
                                icon: Icons.tag_rounded,
                                isNumber: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    _buildLabel("Category"),
                    _buildCustomInput(
                      controller: controller.categoryC,
                      hint: "Dimsum / Drinks / Frozen",
                      icon: Icons.category_outlined,
                    ),

                    const SizedBox(height: 20),

                    _buildLabel("Description"),
                    _buildCustomInput(
                      controller: controller.descC,
                      hint: "Describe the taste, ingredients, etc...",
                      isMultiLine: true,
                    ),

                    const SizedBox(height: 40),

                    // --- 3. MAIN ACTION BUTTON ---
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed:
                            controller.saveProduct, // Aksi Simpan & Upload
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.primaryColor,
                          foregroundColor: Colors.white,
                          shadowColor: CustomColors.primaryColor.withOpacity(
                            0.5,
                          ),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          controller.isEditMode.value
                              ? "Save Changes"
                              : "Create Product",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
      ),
    );
  }

  // --- LOGIKA PREVIEW GAMBAR ---
  Widget _buildImagePreview() {
    return Obx(() {
      // 1. Jika User BARU SAJA memilih gambar dari galeri -> Tampilkan File Lokal
      if (controller.selectedImage.value != null) {
        return Image.file(controller.selectedImage.value!, fit: BoxFit.cover);
      }
      // 2. Jika Mode Edit dan ada URL lama -> Tampilkan Gambar dari Internet
      else if (controller.existingImageUrl != null &&
          controller.existingImageUrl!.isNotEmpty) {
        return Image.network(
          controller.existingImageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (c, o, s) =>
              const Icon(Icons.broken_image, color: Colors.grey, size: 40),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2,
              ),
            );
          },
        );
      }
      // 3. Default Placeholder
      else {
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo_outlined,
              size: 40,
              color: Color(0xFFD7CCC8),
            ),
            SizedBox(height: 8),
            Text(
              "Upload",
              style: TextStyle(color: Color(0xFFD7CCC8), fontSize: 12),
            ),
          ],
        );
      }
    });
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF3E2723),
          fontFamily: 'Serif',
        ),
      ),
    );
  }

  Widget _buildCustomInput({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    bool isNumber = false,
    bool isMultiLine = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumber
            ? TextInputType.number
            : (isMultiLine ? TextInputType.multiline : TextInputType.text),
        maxLines: isMultiLine ? 4 : 1,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: CustomColors.primaryColor,
        decoration: InputDecoration(
          prefixIcon: icon != null
              ? Icon(icon, color: Colors.grey[400], size: 22)
              : null,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[300], fontSize: 15),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
