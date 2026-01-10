import 'package:get/get.dart';

import '../controllers/admin_chat_detail_controller.dart';

class AdminChatDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminChatDetailController>(
      () => AdminChatDetailController(),
    );
  }
}
