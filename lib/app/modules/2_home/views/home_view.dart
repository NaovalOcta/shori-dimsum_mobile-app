import 'package:mobile_tugas_akhir/app/modules/2_home/views/CustomBottomNavBar.dart';
import 'package:mobile_tugas_akhir/app/modules/3_contact/views/contact_view.dart';
import 'package:mobile_tugas_akhir/app/modules/3_favorite/views/favorite_view.dart';
import 'package:mobile_tugas_akhir/app/modules/3_food_catalog/views/food_catalog_view.dart';
import 'package:mobile_tugas_akhir/app/modules/3_profile/views/profile_view.dart';

import '../controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Obx(() {
            final selectedNavIndex = controller.navbarClass.getSelectedNavIndex();

            return Positioned.fill(
              child: Image.asset(
                selectedNavIndex > 0 ? 'assets/flat_home_bg.jpg' : 'assets/home_bg.jpg',
                fit: BoxFit.cover,
              ),
            );
          }),
          Obx(() {
            final selectedNavIndex = controller.navbarClass.getSelectedNavIndex();

            return IndexedStack(
              index: selectedNavIndex,
              children: [
                FoodCatalogView(),
                FavoriteView(),
                ContactView(),
                ProfileView(),
              ],
            );
          }),
          Align(    
            alignment: Alignment.bottomCenter,
            child: CustomBottomBar(),
          ),
        ]
      ),
    );
  }
}

