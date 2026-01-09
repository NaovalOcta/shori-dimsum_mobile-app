import 'package:get/get.dart';

import '../controllers/food_catalog_controller.dart';

class FoodCatalogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FoodCatalogController>(
      () => FoodCatalogController(),
    );
  }
}
