import 'package:get/get.dart';

// STILL EMPTY
class StartController extends GetxController {
  final count = 0.obs;
  
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
