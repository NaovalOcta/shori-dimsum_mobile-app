import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/designs/colors/CustomColors.dart';
import 'package:mobile_tugas_akhir/app/models/Product.dart';
import 'package:mobile_tugas_akhir/app/modules/3_food_catalog/controllers/food_catalog_controller.dart';
import 'package:mobile_tugas_akhir/app/routes/app_pages.dart';

import '../controllers/product_info_controller.dart';

class ProductInfoView extends GetView<ProductInfoController> {
  const ProductInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final FoodCatalogController fCC = Get.find<FoodCatalogController>();

    int selectedProductId = fCC.productClass.selectedProductId.value;
    Product selectedProduct = fCC.productClass.products[selectedProductId];

    return Scaffold(
      backgroundColor: CustomColors.backgroundColor_1,
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundColor_1,
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() =>
            IconButton(
              onPressed: () => fCC.productClass.toggleFavProduct(selectedProductId),
              icon: Icon(selectedProduct.isFavorite.value ? Icons.favorite : Icons.favorite_border),
              color: selectedProduct.isFavorite.value ? Colors.red.shade700 : Colors.black87,
              iconSize: 20,
            )
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.fromLTRB(50, 20, 50, 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: PageView.builder(
                        itemCount: selectedProduct.imagePath.length,
                        onPageChanged: controller.imageGalleryClass.updatePage, 
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(80), 
                            child: Image.asset(
                              selectedProduct.imagePath[index],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(selectedProduct.imagePath.length, (index) {
                          // Get.log('Index: $index');
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: controller.imageGalleryClass.currentPage.value == index 
                                    ? Colors.brown.shade800 
                                    : Colors.grey.shade400,
                            ),
                          );
                        }),
                      ),
                    ),
                  ]
                ),
                const SizedBox(height: 20),
                Text(
                  "${selectedProduct.name} ${selectedProduct.unitPieces}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w700
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  fCC.productClass.getFormattedPrice(selectedProduct),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivery Info",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      "Delivered between monday aug and thursday 20 from 8pm to 19:32 pm",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Return Policy",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      "All our foods are double checked before leaving our stores so by any case you found a broken food please contact our hotline immediately.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 11, horizontal: 80),
                      backgroundColor: CustomColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      overlayColor: CustomColors.primaryColor_100
                    ),
                    child: Text(
                      'Add to Cart',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () {
                      fCC.productClass.addCartProduct(selectedProductId);
                    },
                  )
                )
              ]
            )
          )
        )
      )
    );
  }
}


/*
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/designs/colors/CustomColors.dart';
import 'package:mobile_tugas_akhir/app/models/Product.dart';
import 'package:mobile_tugas_akhir/app/modules/2_food_catalog/controllers/food_catalog_controller.dart';
import 'package:mobile_tugas_akhir/app/routes/app_pages.dart';

import '../controllers/product_info_controller.dart';

class ProductInfoView extends GetView<ProductInfoController> {
  const ProductInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final FoodCatalogController fCC = Get.find<FoodCatalogController>();

    int selectedProductId = fCC.productClass.selectedProductId.value;
    Product selectedProduct = fCC.productClass.products[selectedProductId];

    return Scaffold(
      backgroundColor: CustomColors.backgroundColor_1,
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundColor_1,
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() =>
            IconButton(
              onPressed: () => fCC.productClass.toggleFavProduct(selectedProductId),
              icon: Icon(selectedProduct.isFavorite.value ? Icons.favorite : Icons.favorite_border),
              color: selectedProduct.isFavorite.value ? Colors.red.shade700 : Colors.black87,
              iconSize: 20,
            )
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.fromLTRB(50, 20, 50, 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: PageView.builder(
                        itemCount: selectedProduct.imagePath.length,
                        onPageChanged: controller.imageGalleryClass.updatePage, 
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(80), 
                            child: Image.asset(
                              selectedProduct.imagePath[index],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(selectedProduct.imagePath.length, (index) {
                          // Get.log('Index: $index');
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: controller.imageGalleryClass.currentPage.value == index 
                                    ? Colors.brown.shade800 
                                    : Colors.grey.shade400,
                            ),
                          );
                        }),
                      ),
                    ),
                  ]
                ),
                const SizedBox(height: 20),
                Text(
                  "${selectedProduct.name} ${selectedProduct.unitPieces}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w700
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  fCC.productClass.getFormattedPrice(selectedProduct),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivery Info",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      "Delivered between monday aug and thursday 20 from 8pm to 19:32 pm",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Return Policy",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      "All our foods are double checked before leaving our stores so by any case you found a broken food please contact our hotline immediately.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 11, horizontal: 80),
                      backgroundColor: CustomColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      overlayColor: CustomColors.primaryColor_100
                    ),
                    child: Text(
                      'Add to Cart',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () {
                      fCC.productClass.addCartProduct(selectedProductId);
                      
                      if(!fCC.productClass.isProductInCart(selectedProductId)) Get.toNamed(Routes.CART);
                    },
                  )
                )
              ]
            )
          )
        )
      )
    );
  }
}

*/