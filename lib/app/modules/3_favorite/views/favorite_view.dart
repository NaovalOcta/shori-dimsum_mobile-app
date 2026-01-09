import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/designs/colors/CustomColors.dart';
import 'package:mobile_tugas_akhir/app/modules/3_food_catalog/controllers/food_catalog_controller.dart';
import 'package:mobile_tugas_akhir/app/shared_widgets/Build_ProductItems.dart';

import '../controllers/favorite_controller.dart';

class FavoriteView extends GetView<FavoriteController> {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    // NOTE: Buat inisiasi sesuatu yg reactive antar class harus menggunakan Get.find() [ I N G A T !!! DIRIKU DI MASA DEPAN ]
    final FoodCatalogController fCC = Get.find<FoodCatalogController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: CustomColors.primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Favorite Product', 
          style: TextStyle(
            color: Colors.white
          )
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Obx(() { 
          final favProductLength = fCC.productClass.favProductIds.length;
          if(favProductLength == 0) {
            return Center(
              child: Text(
                "You haven't Pick Any Favorite Product ",
                style: TextStyle(fontSize: 20),
              ),
            );
          }

          // Get.log('Fav Product length: $favProductLength');
          return GridView.builder(
            primary: false,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: fCC.responsiveClass.gridCrossAxisCount.value,
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 15.0,
              childAspectRatio: 0.8
            ),
            itemCount: favProductLength, 
            itemBuilder: (BuildContext context, int gridViewIndex) {
              return buildProductItems(gridViewIndex, isFavProduct: true);
            }
          );
        })
      )
    );
  }
}
