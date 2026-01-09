// lib/app/modules/admin/home/bindings/admin_home_binding.dart

import 'package:get/get.dart';
import '../controllers/admin_home_controller.dart';

class AdminHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminHomeController>(() => AdminHomeController());
  }
}
