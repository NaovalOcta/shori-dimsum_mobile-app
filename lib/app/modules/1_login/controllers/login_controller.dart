import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Routes

class LoginInputClass {
  // Hapus UserDb karena kita pakai Supabase
  // final UserDb userDB = UserDb();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxBool isPasswordViewable = false.obs;

  // Instance Supabase Client
  final supabase = Supabase.instance.client;

  void togglePasswordViewable() {
    isPasswordViewable.value = !isPasswordViewable.value;
  }

  Future<void> loginAction() async {
    String emailInput = emailController.text;
    String passwordInput = passwordController.text;

    // 1. Validasi Format Input
    if (!isLoginFormatCorrect(emailInput, passwordInput)) return;

    try {
      // 2. Login ke Supabase Auth (Otomatis cek password)
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: emailInput,
        password: passwordInput,
      );

      final User? user = res.user;

      if (user != null) {
        // 3. Ambil data role dari tabel 'users' di database Supabase
        // Asumsi: Anda punya tabel 'users' dengan kolom 'email', 'name', 'role'
        final userData = await supabase
            .from('users')
            .select()
            .eq('id', user.id) // Query berdasarkan ID user yang login
            .single();

        String userName = userData['name'] ?? 'User';
        String role = userData['role'] ?? 'user';

        Get.snackbar(
          'Login Successful',
          "Welcome back, $userName!",
          backgroundColor: Colors.white,
        );

        // 4. Redirect Berdasarkan Role
        if (role == 'admin') {
          Get.offAllNamed(Routes.ADMIN_HOME);
        } else {
          Get.offAllNamed(Routes.HOME);
        }
      }
    } on AuthException catch (e) {
      // Menangkap error salah password/email dari Supabase
      Get.snackbar('Login Failed', e.message, backgroundColor: Colors.white);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.white,
      );
    }
  }

  bool isLoginFormatCorrect(String emailInput, String passwordInput) {
    if (!emailInput.contains('@')) {
      Get.snackbar(
        'Warning',
        "Your email must contain the symbol '@' ...",
        backgroundColor: Colors.white,
      );
      return false;
    } else if (emailInput.length < 5) {
      Get.snackbar(
        'Warning',
        "Your email must be more than 5 letter long ...",
        backgroundColor: Colors.white,
      );
      return false;
    } else if (passwordInput.length < 8) {
      Get.snackbar(
        'Warning',
        "Your password must be more than 8 letter long ...",
        backgroundColor: Colors.white,
      );
      return false;
    }
    return true;
  }
}

class LoginController extends GetxController {
  LoginInputClass loginInputClass = LoginInputClass();
}

// class LoginInputClass {
//   final UserDb userDB = UserDb();
//   late final ProfileController pC = Get.find<ProfileController>();

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   RxBool isPasswordViewable = false.obs;
//   int currentUserIndex = 0;

//   void togglePasswordViewable() {
//     isPasswordViewable.value = !isPasswordViewable.value;
//   }

//   // Ganti isLoginValid() dengan fungsi void ini untuk dipanggil di tombol Login
//   void loginAction() {
//     String emailInput = emailController.text;
//     String passwordInput = passwordController.text;

//     // Lakukan validasi format dan validasi database
//     if (isLoginFormatCorrect(emailInput, passwordInput) &&
//         isInputedDataValidInDB(emailInput, passwordInput)) {
//       // Update data profil pengguna yang sedang aktif
//       User? loggedInUser = changeUserDefaultProfileInfo(emailInput);

//       Get.snackbar(
//         'Login Successful',
//         "Welcome back, ${loggedInUser?.name}!",
//         backgroundColor: Colors.white,
//       );

//       // --- LOGIKA UTAMA REDIRECT ADMIN VS USER ---
//       if (loggedInUser != null && loggedInUser.role == 'admin') {
//         // Jika role admin, masuk ke Admin Home
//         Get.offAllNamed(Routes.ADMIN_HOME);
//       } else {
//         // Jika user biasa, masuk ke Home biasa
//         Get.offAllNamed(Routes.HOME);
//       }
//     }
//   }

//   bool isLoginFormatCorrect(String emailInput, String passwordInput) {
//     if (!emailInput.contains('@')) {
//       Get.snackbar(
//         'Warning',
//         "Your email must contain the symbol '@' ...",
//         backgroundColor: Colors.white,
//       );
//       return false;
//     } else if (emailInput.length < 5) {
//       Get.snackbar(
//         'Warning',
//         "Your email must be more than 5 letter long ...",
//         backgroundColor: Colors.white,
//       );
//       return false;
//     } else if (passwordInput.length < 8) {
//       Get.snackbar(
//         'Warning',
//         "Your password must be more than 8 letter long ...",
//         backgroundColor: Colors.white,
//       );
//       return false;
//     }
//     return true;
//   }

//   bool isInputedDataValidInDB(String emailInput, String passwordInput) {
//     for (User user in userDB.userDataList) {
//       if (user.email == emailInput) {
//         if (user.password == passwordInput) {
//           return true;
//         } else {
//           Get.snackbar(
//             'Warning',
//             "Password anda salah ...",
//             backgroundColor: Colors.white,
//           );
//           return false;
//         }
//       }
//     }
//     Get.snackbar(
//       'Warning',
//       "Email anda salah ...",
//       backgroundColor: Colors.white,
//     );
//     return false;
//   }

//   // Diupdate untuk mengembalikan objek User agar bisa dicek role-nya
//   User? changeUserDefaultProfileInfo(String emailInput) {
//     for (User user in userDB.userDataList) {
//       if (user.email == emailInput) {
//         pC.userClass.nameController.text = user.name;
//         pC.userClass.emailController.text = user.email;
//         pC.userClass.addressController.text = user.address;
//         pC.userClass.phoneNumController.text = user.phoneNumber;
//         pC.userClass.passwordController.text = user.password;

//         currentUserIndex = userDB.userDataList.indexOf(user);

//         pC.userClass.isProfileEditable.value = false;

//         return user; // Kembalikan user yang ditemukan
//       }
//     }
//     return null;
//   }
// }

// class LoginController extends GetxController {
//   LoginInputClass loginInputClass = LoginInputClass();

//   @override
//   void onInit() {
//     super.onInit();

//     fetchProduct();
//     // productClass.products.addAll(ProductDb().productDataList);
//   }

//   void fetchProduct() async {
//     productClass.products.addAll(await ProductDb().fetchProducts());
//   }
// }
