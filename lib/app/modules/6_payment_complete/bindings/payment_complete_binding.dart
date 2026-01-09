import 'package:get/get.dart';

import '../controllers/payment_complete_controller.dart';

class PaymentCompleteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentCompleteController>(
      () => PaymentCompleteController(),
    );
  }
}
