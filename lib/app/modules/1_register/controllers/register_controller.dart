import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterInputClass {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confPasswordController = TextEditingController();
  final TextEditingController phoneNumController = TextEditingController();

  RxBool isPasswordViewable = false.obs;
  RxBool isConfPasswordViewable = false.obs;

  final supabase = Supabase.instance.client;

  void togglePasswordViewable() {
    isPasswordViewable.value = !isPasswordViewable.value;
  }

  void toggleConfPasswordViewable() {
    isConfPasswordViewable.value = !isConfPasswordViewable.value;
  }

  Future<void> registerAction() async {
    // Ubah jadi void, handle navigasi di sini
    String emailInput = emailController.text;
    String passwordInput = passwordController.text;
    String confPassInput = confPasswordController.text;
    String phoneNumInput = phoneNumController.text;

    // 1. Validasi Format
    if (!isRegisterFormatCorrect(
      emailInput,
      passwordInput,
      confPassInput,
      phoneNumInput,
    )) {
      return;
    }

    try {
      // 2. Daftar ke Supabase Auth
      final AuthResponse res = await supabase.auth.signUp(
        email: emailInput,
        password: passwordInput,
      );

      final User? user = res.user;

      if (user != null) {
        // 3. Simpan data tambahan (Role, Phone, dll) ke tabel 'users'
        // Tabel 'users' harus sudah dibuat di Supabase Dashboard
        await supabase.from('users').insert({
          'id': user.id, // PENTING: Link ID auth ke tabel public users
          'email': emailInput,
          'name': 'New User', // Default name, atau tambah controller input name
          'phone_number': phoneNumInput,
          'role': 'user', // Default role user biasa
          'created_at': DateTime.now().toIso8601String(),
        });

        Get.snackbar(
          'Register Successful',
          "Account created! Please Login.",
          backgroundColor: Colors.white,
        );

        // Opsional: Langsung arahkan ke login
        // Get.offNamed(Routes.LOGIN);
      }
    } on AuthException catch (e) {
      Get.snackbar('Register Failed', e.message, backgroundColor: Colors.white);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.white,
      );
    }
  }

  bool isRegisterFormatCorrect(
    String emailInput,
    String passwordInput,
    String confPassInput,
    String phoneNumInput,
  ) {
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
    } else if (passwordInput != confPassInput) {
      Get.snackbar(
        'Warning',
        "Your password must be the same as confirm password ...",
        backgroundColor: Colors.white,
      );
      return false;
    } else if (phoneNumInput.length != 12) {
      Get.snackbar(
        'Warning',
        "Your phone number length must be exactly 12 ...",
        backgroundColor: Colors.white,
      );
      return false;
    }

    return true;
  }
}

class RegisterController extends GetxController {
  RegisterInputClass registerInputClass = RegisterInputClass();
}










// class RegisterInputClass {
//   final UserDb userDB = UserDb();

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confPasswordController = TextEditingController();
//   final TextEditingController phoneNumController = TextEditingController();
//   RxBool isPasswordViewable = false.obs;
//   RxBool isConfPasswordViewable = false.obs;

//   void togglePasswordViewable() {
//     isPasswordViewable.value = !isPasswordViewable.value;
//   }
//   void toggleConfPasswordViewable() {
//     isConfPasswordViewable.value = !isConfPasswordViewable.value;
//   }

//   Future<bool> isRegisterValid() async {
//     String emailInput = emailController.text;
//     String passwordInput = passwordController.text;
//     String confPassInput = confPasswordController.text;
//     String phoneNumInput = phoneNumController.text;

//     if(isRegisterFormatCorrect(emailInput, passwordInput, confPassInput, phoneNumInput) && !isUserInDB(emailInput, passwordInput)) {
//       await userDB.fetchUsers().add(
//         User(
//           name: '', 
//           email: emailInput, 
//           address: '', 
//           phoneNumber: '',
//           password: passwordInput, 
//           profileImg: userDB.getDefaultProfImg(),
//           role: 'user',
//         )
//       );
      
//       Get.snackbar(
//         'Register Successfull', 
//         "You have successfully Register, Please Login with your new Account !",
//         backgroundColor: Colors.white
//       );
      
//       return true;
//     }
//     return false;
//   }

//   bool isRegisterFormatCorrect(String emailInput, String passwordInput, String confPassInput, String phoneNumInput) {
//     if(!emailInput.contains('@')) {
//       Get.snackbar(
//         'Warning', 
//         "Your email must contain the symbol '@' ...",
//         backgroundColor: Colors.white
//       );
//       return false;
//     } else if(emailInput.length < 5) {
//       Get.snackbar(
//         'Warning', 
//         "Your email must be more than 5 letter long ...",
//         backgroundColor: Colors.white
//       );
//       return false;
//     } else if(passwordInput.length < 8) {
//       Get.snackbar(
//         'Warning', 
//         "Your password must be more than 8 letter long ...",
//         backgroundColor: Colors.white
//       );
//       return false;
//     } else if(passwordInput != confPassInput) {
//       Get.snackbar(
//         'Warning', 
//         "Your password must be the same as confirm password ...",
//         backgroundColor: Colors.white
//       );
//       return false;
//     } else if(phoneNumInput.length != 12) {
//       Get.snackbar(
//         'Warning', 
//         "Your phone number length must be exactly 12 ...",
//         backgroundColor: Colors.white
//       );
//       return false;
//     }

//     return true;
//   }
//   Future<bool> isUserInDB(String emailInput, String passwordInput) async {
//     List<User> userDataList = await userDB.fetchUsers();
    
//     for(User user in getUserDataList()) {
//       if(user.email == emailInput) { 
//         Get.snackbar(
//           'Warning', 
//           "Email ini sudah terdaftar ...",
//           backgroundColor: Colors.white
//         );
//         return true; 
//       }
//     }
    
//     return false;
//   }
// }

// class RegisterController extends GetxController {
//   RegisterInputClass registerInputClass = RegisterInputClass();
// }
