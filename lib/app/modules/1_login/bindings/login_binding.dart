import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/modules/3_profile/controllers/profile_controller.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
