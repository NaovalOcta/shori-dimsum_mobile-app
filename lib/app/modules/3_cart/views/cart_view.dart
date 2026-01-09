import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/designs/colors/CustomColors.dart';
import 'package:mobile_tugas_akhir/app/models/Product.dart';
import 'package:mobile_tugas_akhir/app/modules/3_food_catalog/controllers/food_catalog_controller.dart';
import 'package:mobile_tugas_akhir/app/modules/4_product_info/controllers/product_info_controller.dart';
import 'package:mobile_tugas_akhir/app/modules/5_payment/controllers/payment_controller.dart';
import 'package:mobile_tugas_akhir/app/routes/app_pages.dart';

import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});
  
  @override
  Widget build(BuildContext context) {
    final FoodCatalogController fCC = Get.find<FoodCatalogController>();
    final PaymentController pC = Get.find<PaymentController>();
    
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor_1,
      appBar: AppBar(
        backgroundColor: CustomColors.primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Product Cart',
          style: TextStyle(
            color: Colors.white
          )
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.HOME),
            icon: Icon(Icons.home_filled),
            color: Colors.white,
            iconSize: 20,
          )
        ]
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Obx(() {
                  int cartProductLength = fCC.productClass.cartProductsIds.length;
                  Get.log('cartProductsIds: ${fCC.productClass.cartProductsIds.length}');
                  
                  if(cartProductLength == 0) {
                    return Center(
                      child: Text(
                        "You Haven't Order Any Product",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18 
                        )
                      )
                    );
                  }
                  return GridView.builder(
                    primary: false,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 15.0,
                      mainAxisExtent: 130,
                    ),
                    itemCount: cartProductLength, 
                    itemBuilder: (BuildContext context, int gridViewIndex) {
                      return buildCartItems(fCC, gridViewIndex);
                    }
                  );  
                })
              ),
              
              Obx(() {
                if(fCC.productClass.cartProductsIds.isEmpty) {
                  return const SizedBox.shrink();
                }
                
                return SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 11, horizontal: 80),
                      backgroundColor: CustomColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      overlayColor: CustomColors.primaryColor_100.withAlpha(40)
                    ),
                    child: Text(
                      'Complete Order',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () {
                      pC.paymentClass.calculateTotalPrice();

                      Get.toNamed(Routes.PAYMENT); 
                    },
                  )
                );
              })
            ]
          )
        )
      ),
    );
  }
}

Widget buildCartItems(FoodCatalogController fCC, int gridViewIndex) {
  final ProductInfoController pIC = Get.find<ProductInfoController>();

  int cartProductId = fCC.productClass.cartProductsIds[gridViewIndex];
  Product cartProduct = fCC.productClass.products[cartProductId];

  return Container(
    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25)
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            SizedBox(
              width: 90,
              height: 90,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(80), 
                child: Image.asset(
                  cartProduct.imagePath[0],
                  fit: BoxFit.cover,
                ),
              )
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    cartProduct.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    fCC.productClass.getFormattedPrice(cartProduct),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 25,
                        decoration: BoxDecoration(
                          color: CustomColors.primaryColor,
                          borderRadius: BorderRadius.circular(40)
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 5),
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => fCC.productClass.lowerUnitQuantity(cartProductId),
                                  splashColor: CustomColors.primaryColor_100.withAlpha(40),
                                  borderRadius: BorderRadius.circular(80),
                                  child: Center( 
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              )
                            ),
                            Obx(()=>
                              SizedBox(
                                width: 20,
                                height: 25,
                                child: InkWell(
                                  onTap: () => null,
                                  child: Center( 
                                    child: Text(
                                      "${cartProduct.orderQuantity}",
                                      style: TextStyle(
                                        color: Colors.white, 
                                        fontSize: 16, 
                                        fontWeight: FontWeight.bold
                                      )
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => fCC.productClass.increaseUnitQuantity(cartProductId),
                                  splashColor: CustomColors.primaryColor_100.withAlpha(40),
                                  borderRadius: BorderRadius.circular(80),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                              )
                              
                            ),
                            const SizedBox(width: 5)
                          ],
                        )
                      ),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.all(0), 
                        ), 
                        icon: Icon(
                          Icons.delete,
                          color: Colors.black,
                          size: 20,
                        ),
                        onPressed: () => fCC.productClass.deleteCartProduct(cartProductId),
                      ),
                    ]
                  )
                ]
              )
            )
          ]
        ),
      ],
    )
  );
}