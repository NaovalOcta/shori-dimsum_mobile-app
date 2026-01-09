import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/modules/5_payment/controllers/payment_controller.dart';

import '../controllers/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(
      () => CartController(),
    );
    // NOTE: PaymentController disini karena pagenya belum diinisialisasikan 
    Get.lazyPut<PaymentController>(
      () => PaymentController(),
    );
  }
}
