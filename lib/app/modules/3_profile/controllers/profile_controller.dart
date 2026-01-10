// lib/app/modules/3_profile/controllers/profile_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile_tugas_akhir/app/routes/app_pages.dart';
import 'package:mobile_tugas_akhir/app/models/User.dart';

class ProfileController extends GetxController {
  // Instance Supabase
  final supabase = Supabase.instance.client;

  // UI State Variables
  RxBool isProfileEditable = false.obs;
  RxBool isLoading = false.obs;

  // Text Controllers
  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController addressC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();

  // Kita tidak menampilkan password di profile form demi keamanan
  // Jika ingin ganti password, sebaiknya di menu terpisah (Reset Password)

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  // Fungsi 1: Ambil data user dari Supabase
  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      final currentUser = supabase.auth.currentUser;

      if (currentUser == null) {
        Get.offAllNamed(Routes.LOGIN); // Tendang ke login jika sesi habis
        return;
      }

      // Query ke tabel 'users' berdasarkan ID user yang sedang login
      final data = await supabase
          .from('users')
          .select()
          .eq('id', currentUser.id)
          .single();

      // Isi TextControllers dengan data dari database
      nameC.text = data['name'] ?? '';
      emailC.text = data['email'] ?? currentUser.email ?? '';
      addressC.text = data['address'] ?? '';
      phoneC.text = data['phone_number'] ?? '';
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat profil: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi 2: Tombol Edit ditekan
  void editProfileFunc() {
    isProfileEditable.value = true;
  }

  // Fungsi 3: Simpan Perubahan ke Supabase
  Future<void> saveProfileFunc() async {
    try {
      isLoading.value = true;
      final currentUser = supabase.auth.currentUser;

      if (currentUser != null) {
        // Update data ke tabel 'users'
        await supabase
            .from('users')
            .update({
              'name': nameC.text,
              'address': addressC.text,
              'phone_number': phoneC.text,
              // Email di tabel public bisa diupdate, tapi auth email butuh verifikasi khusus
              // 'email': emailC.text,
            })
            .eq('id', currentUser.id);

        isProfileEditable.value = false;
        Get.snackbar(
          "Sukses",
          "Profil berhasil diperbarui!",
          backgroundColor: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal menyimpan: $e",
        backgroundColor: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void backToDashboard() {
    Get.back();
    // // 1. Coba Back normal dulu (paling smooth)
    // if (Get.previousRoute.isNotEmpty && !Get.previousRoute.contains('login')) {
    //   Get.back();
    // }
    // // 2. Jika history kosong (misal refresh), paksa arahkan sesuai role
    // else {
    //   if (User.value.role == 'admin') {
    //     Get.offAllNamed(Routes.ADMIN_HOME);
    //   } else {
    //     Get.offAllNamed(Routes.HOME);
    //   }
    // }
  }

  // Fungsi 4: Logout
  Future<void> logout() async {
    await supabase.auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}


// class UserClass {
//   final UserDb userDb = UserDb();
//   late final LoginController lC = Get.find<LoginController>();

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController phoneNumController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   RxBool isProfileEditable = false.obs;
//   RxList<User> users = <User>[].obs;

//   void editProfileFunc() {
//     isProfileEditable.value = true;
//   }
//   void saveProfileFunc() {
//     User currUser = userDb.userDataList[lC.loginInputClass.currentUserIndex];
    
//     currUser.name = nameController.text; 
//     currUser.email = emailController.text;
//     currUser.address = addressController.text;
//     currUser.phoneNumber = phoneNumController.text;
//     currUser.password = passwordController.text;

//     isProfileEditable.value = false;
//   }
// }

// class ProfileController extends GetxController {
//   final UserClass userClass = UserClass();

//   @override
//   void onInit() {
//     super.onInit();

//     userClass.users.addAll(UserDb().userDataList);
//   }
// }
