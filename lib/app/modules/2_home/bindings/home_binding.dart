import 'package:get/get.dart';

import '../../3_favorite/controllers/favorite_controller.dart';
import '../../3_food_catalog/controllers/food_catalog_controller.dart';
import '../../3_profile/controllers/profile_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<FoodCatalogController>(
      () => FoodCatalogController(),
    );
    Get.lazyPut<FavoriteController>(
      () => FavoriteController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
