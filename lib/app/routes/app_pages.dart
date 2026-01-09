import 'package:get/get.dart';

import '../modules/0_start/bindings/start_binding.dart';
import '../modules/0_start/views/start_view.dart';
import '../modules/1_login/bindings/login_binding.dart';
import '../modules/1_login/views/login_view.dart';
import '../modules/1_register/bindings/register_binding.dart';
import '../modules/1_register/views/register_view.dart';
import '../modules/2_home/bindings/home_binding.dart';
import '../modules/2_home/views/home_view.dart';
import '../modules/3_cart/bindings/cart_binding.dart';
import '../modules/3_cart/views/cart_view.dart';
import '../modules/3_contact/bindings/contact_binding.dart';
import '../modules/3_contact/views/contact_view.dart';
import '../modules/3_favorite/bindings/favorite_binding.dart';
import '../modules/3_favorite/views/favorite_view.dart';
import '../modules/3_food_catalog/bindings/food_catalog_binding.dart';
import '../modules/3_food_catalog/views/food_catalog_view.dart';
import '../modules/3_profile/bindings/profile_binding.dart';
import '../modules/3_profile/views/profile_view.dart';
import '../modules/4_product_info/bindings/product_info_binding.dart';
import '../modules/4_product_info/views/product_info_view.dart';
import '../modules/5_payment/bindings/payment_binding.dart';
import '../modules/5_payment/views/payment_view.dart';
import '../modules/6_payment_complete/bindings/payment_complete_binding.dart';
import '../modules/6_payment_complete/views/payment_complete_view.dart';
import '../modules/admin_home/bindings/admin_home_binding.dart';
import '../modules/admin_home/views/admin_home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.START;

  static final routes = [
    GetPage(
      name: _Paths.START,
      page: () => const StartView(),
      binding: StartBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.FAVORITE,
      page: () => const FavoriteView(),
      binding: FavoriteBinding(),
    ),
    GetPage(
      name: _Paths.CONTACT,
      page: () => const ContactView(),
      binding: ContactBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.FOOD_CATALOG,
      page: () => const FoodCatalogView(),
      binding: FoodCatalogBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_INFO,
      page: () => const ProductInfoView(),
      binding: ProductInfoBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => const PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_COMPLETE,
      page: () => const PaymentCompleteView(),
      binding: PaymentCompleteBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_HOME,
      page: () => const AdminHomeView(),
      binding: AdminHomeBinding(),
    ),
  ];
}
