import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Wajib import ini
import 'package:mobile_tugas_akhir/app/data/Product_DB.dart';
import 'package:mobile_tugas_akhir/app/models/Product.dart';
import 'package:mobile_tugas_akhir/app/modules/admin_home/controllers/admin_home_controller.dart';

class AdminManageMenuController extends GetxController {
  // --- Form Controllers ---
  TextEditingController nameC = TextEditingController();
  TextEditingController priceC = TextEditingController();
  TextEditingController descC = TextEditingController();
  TextEditingController categoryC = TextEditingController();
  TextEditingController piecesC = TextEditingController();

  // --- Image Handling ---
  // Variabel untuk menyimpan file gambar yang dipilih dari galeri
  Rx<File?> selectedImage = Rx<File?>(null);
  // Menyimpan URL gambar lama (jika mode edit)
  String? existingImageUrl;

  final ImagePicker _picker = ImagePicker();

  RxBool isLoading = false.obs;
  RxBool isEditMode = false.obs;
  String? productId;

  @override
  void onInit() {
    super.onInit();
    // Cek Mode Edit
    if (Get.arguments != null && Get.arguments is Product) {
      isEditMode.value = true;
      Product product = Get.arguments;
      productId = product.id;

      // Isi data lama
      nameC.text = product.name;
      priceC.text = product.price.toString();
      descC.text = product.description;
      categoryC.text = product.category;
      piecesC.text = product.unitPieces.replaceAll(RegExp(r'[^0-9]'), '');

      // Simpan URL lama agar bisa ditampilkan previewnya
      if (product.imagePath.isNotEmpty) {
        existingImageUrl = product.imagePath[0];
      }
    }
  }

  // --- 1. FUNGSI PILIH GAMBAR DARI GALERI ---
  Future<void> pickImage() async {
    try {
      // Pick gambar dan kompres kualitasnya agar upload cepat
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Kompres kualitas ke 70%
        maxWidth: 800, // Resize lebar maks 800px
      );

      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      print("Gagal ambil gambar: $e");
      Get.snackbar("Error", "Gagal mengambil gambar dari galeri");
    }
  }

  // --- 2. FUNGSI UPLOAD KE SUPABASE STORAGE ---
  Future<String?> uploadImageToStorage() async {
    if (selectedImage.value == null) return null;

    try {
      final File file = selectedImage.value!;
      // Buat nama file unik: time_stamp.jpg
      final fileExt = file.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = '$fileName';

      // Proses Upload ke Bucket 'product-images'
      await Supabase.instance.client.storage
          .from('menu-images')
          .upload(filePath, file);

      // Ambil Public URL setelah sukses upload
      final String publicUrl = Supabase.instance.client.storage
          .from('menu-images')
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      print("Upload Error: $e");
      // Jika bucket belum dibuat, ini akan error
      Get.snackbar(
        "Upload Gagal",
        "Pastikan Bucket 'menu-images' sudah dibuat di Supabase",
      );
      return null;
    }
  }

  Future<void> saveProduct() async {
    if (nameC.text.isEmpty || priceC.text.isEmpty) {
      Get.snackbar("Error", "Nama dan Harga wajib diisi");
      return;
    }

    try {
      isLoading.value = true;

      String finalImageUrl = '';

      // LOGIKA PENENTUAN GAMBAR:
      if (selectedImage.value != null) {
        // A. Jika User pilih gambar baru -> Upload & Pakai URL baru
        String? uploadedUrl = await uploadImageToStorage();
        if (uploadedUrl != null) {
          finalImageUrl = uploadedUrl;
        } else {
          throw "Gagal mengupload gambar";
        }
      } else {
        // B. Jika tidak pilih gambar baru -> Pakai URL lama (jika edit)
        finalImageUrl = existingImageUrl ?? '';
      }

      // Buat Objek Product
      Product tempProduct = Product(
        id: productId ?? '',
        name: nameC.text,
        price: int.tryParse(priceC.text) ?? 0,
        description: descC.text,
        category: categoryC.text.isEmpty ? 'General' : categoryC.text,
        unitPieces: piecesC.text,
        imagePath: finalImageUrl.isNotEmpty
            ? [finalImageUrl]
            : [], // Simpan URL
        rating: 0.0,
        orderQuantity: 1.obs,
      );

      // Simpan ke DB
      if (isEditMode.value) {
        await ProductDb().updateProduct(tempProduct);
        Get.snackbar("Sukses", "Menu berhasil diperbarui");
      } else {
        await ProductDb().addProduct(tempProduct);
        Get.snackbar("Sukses", "Menu baru berhasil ditambahkan");
      }

      // Refresh Home Admin
      final AdminHomeController homeC = Get.find();
      homeC.fetchProducts();

      Get.back();
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Gagal menyimpan menu: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct() async {
    if (productId == null) return;

    Get.defaultDialog(
      title: "Hapus Menu",
      middleText: "Yakin hapus menu ini?",
      textConfirm: "Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        try {
          isLoading.value = true;
          Get.back();
          await ProductDb().deleteProduct(productId!);

          final AdminHomeController homeC = Get.find();
          homeC.fetchProducts();

          Get.back();
          Get.snackbar("Sukses", "Menu dihapus");
        } catch (e) {
          Get.snackbar("Error", "Gagal menghapus: $e");
        } finally {
          isLoading.value = false;
        }
      },
    );
  }
}
