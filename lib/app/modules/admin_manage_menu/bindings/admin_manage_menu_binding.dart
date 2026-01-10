import 'package:get/get.dart';

import '../controllers/admin_manage_menu_controller.dart';

class AdminManageMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminManageMenuController>(
      () => AdminManageMenuController(),
    );
  }
}
