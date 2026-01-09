import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/designs/colors/CustomColors.dart';
import 'package:mobile_tugas_akhir/app/models/Product.dart';
import 'package:mobile_tugas_akhir/app/shared_widgets/Build_ProductItems.dart';

import '../controllers/food_catalog_controller.dart';

class FoodCatalogView extends GetView<FoodCatalogController> {
  const FoodCatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    controller.responsiveClass.updateWidgetOnRotation(orientation);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 50, 15, 0), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => SizedBox(height: controller.responsiveClass.topMargin.value),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.productClass.searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.black38),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.blue, width: 3)
                      ),
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search',
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    ),
                    style: const TextStyle(color: Colors.black87),
                    onChanged: (String newValue) => controller.productClass.searchFilteredProducts(newValue),
                  ),
                ),
                Obx(
                  () => PopupMenuButton<String>(
                    icon: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/filter_btn.jpg',
                        width: 50,
                        height: 50
                      ), 
                    ),
                    onSelected: (String selectedValue) {
                      controller.filterClass.handleFilterSelection(selectedValue, controller);
                    },
                    itemBuilder: (BuildContext context) => controller.filterClass.filterOptionsList.map((String value) {
                      return PopupMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            color: controller.filterClass.changeTextColor(value),
                          ),
                        ),
                      );
                    }).toList(),
                    color: controller.filterClass.changeIconColor
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(
                () => Row( 
                  children: controller.categoryClass.categoryNameList.asMap().entries.map((entry) {
                    int index = entry.key;
                    bool isLast = index == controller.categoryClass.categoryNameList.length - 1;
                    return _buildCategoryItem(controller, index, isLastChild: isLast);
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() { 
                List productList = <Product>[];
                bool isProductFiltered = false;

                if(controller.productClass.searchProducts.isEmpty) {
                  productList = controller.productClass.products;
                  isProductFiltered = false;
                } else {
                  productList = controller.productClass.searchProducts;
                  isProductFiltered = true;
                }
                // Get.log('productList length: ${productList.length}');

                if (productList.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: CustomColors.primaryColor)
                  ); 
                }
                
                return GridView.builder(
                  primary: false,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: controller.responsiveClass.gridCrossAxisCount.value,
                    mainAxisSpacing: 15.0,
                    crossAxisSpacing: 15.0,
                    childAspectRatio: 0.8
                  ),
                  itemCount: productList.length, 
                  itemBuilder: (BuildContext context, int gridViewIndex) {
                    return buildProductItems(gridViewIndex, isProductFiltered: isProductFiltered);
                  }
                );
              })
            ),
          ]
        )
      ),
    );
  }
}

Widget _buildCategoryItem(FoodCatalogController controller, int index, {bool isLastChild = false}) {
  return Padding(
    padding: EdgeInsets.only(right: isLastChild ? 0 : 10),
    child: Material(
      color: controller.categoryClass.changeBgColor(index), 
      borderRadius: BorderRadius.circular(20), 
      child: InkWell(
        borderRadius: BorderRadius.circular(20), 
        splashColor: CustomColors.primaryColor_100.withAlpha(40),
        onTap: () => controller.categoryClass.toggleCategory(index),
        child: Container(
          width: 100,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: BoxBorder.all(color: controller.categoryClass.changeBorderColor(index)),
            borderRadius: BorderRadius.circular(20)
          ),
          child: Text(
            controller.categoryClass.categoryNameList[index],
            style: TextStyle(
              color: controller.categoryClass.changeTextColor(index), 
              fontSize: 14 
            ),
          ),
        ),
      ),
    ),
  );
}