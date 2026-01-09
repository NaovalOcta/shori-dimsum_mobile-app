import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/models/Product.dart';
import 'package:mobile_tugas_akhir/app/modules/3_food_catalog/controllers/food_catalog_controller.dart';
import 'package:mobile_tugas_akhir/app/routes/app_pages.dart';

Widget buildProductItems(int gridViewIndex, {bool isFavProduct = false, bool isProductFiltered = false}) {
  final FoodCatalogController fCC = Get.find<FoodCatalogController>(); 
  
  Product product;
  int productIndex;

  if(isFavProduct) {
    int favProductId = fCC.productClass.favProductIds[gridViewIndex]; 
    product = fCC.productClass.products[favProductId];
    productIndex = favProductId;
  }
  else {
    if(isProductFiltered) {
      product = fCC.productClass.searchProducts[gridViewIndex];
      productIndex = fCC.productClass.products.indexOf(product);
    } else {
      product = fCC.productClass.products[gridViewIndex];
      productIndex = gridViewIndex;
    }
  }

  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20)
    ),
    child: Obx(
      () =>  GestureDetector(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded( 
              child: Center(
                child: Image.asset(
                  product.imagePath[0],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover, 
                ),
              )
            ),
            const SizedBox(height: 10),
            Text(
              product.name
            ),
            Text(
              product.unitPieces
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber, 
                      size: 20
                    ),
                    Text(
                      product.rating
                    )
                  ],
                ),
                IconButton(
                  onPressed: () => fCC.productClass.toggleFavProduct(productIndex),
                  icon: Icon(product.isFavorite.value ? Icons.favorite : Icons.favorite_border),
                  color: product.isFavorite.value ? Colors.red.shade700 : Colors.black87,
                  iconSize: 20,
                )
              ]
            )
          ]
        ),
        onTap: () { 
          fCC.productClass.setSelectedProductId(productIndex);
          Get.log('Product Index: $productIndex');
          
          Get.toNamed(Routes.PRODUCT_INFO);
        },
      )
    )
  );
}