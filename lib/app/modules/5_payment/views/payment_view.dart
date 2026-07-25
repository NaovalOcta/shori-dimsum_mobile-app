import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/designs/colors/CustomColors.dart';
import 'package:mobile_tugas_akhir/app/models/Product.dart';
import 'package:mobile_tugas_akhir/app/modules/3_food_catalog/controllers/food_catalog_controller.dart';
import 'package:mobile_tugas_akhir/app/routes/app_pages.dart';

import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final FoodCatalogController fCC = Get.find<FoodCatalogController>();
    
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor_1,
      appBar: AppBar(
        backgroundColor: CustomColors.primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            controller.paymentClass.resetOrderCalculation();
            Get.back();            
          }
        ),
        title: const Text(
          'Payment',
          style: TextStyle(
            color: Colors.white
          )
        ),
        actions: [
          IconButton(
            onPressed: () {
              controller.paymentClass.resetOrderCalculation();
              Get.toNamed(Routes.HOME);
            },
            icon: Icon(Icons.home_filled),
            color: Colors.white,
            iconSize: 20,
          )
        ]
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical, 
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      )
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )
                              ),
                              const SizedBox(height: 5),
                              ...List.generate(
                                fCC.productClass.cartProductsIds.length, 
                                (index) {
                                  return _buildCartProductPric(controller, index);
                                },
                              )
                            ]
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Taxes',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                )
                              ),
                              Text(
                                'Rp. ${controller.paymentClass.taxesFees}',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                )
                              ),
                            ]
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivery Fees',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                )
                              ),
                              Text(
                                'Rp. ${controller.paymentClass.deliveryFees}',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                )
                              ),
                            ]
                          ),
                          Divider(  
                            color: Colors.black54,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )
                              ),
                              Text(
                                'Rp. ${controller.paymentClass.totalPrice}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )
                              ),
                            ]
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivery Time',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                )
                              ),
                              Text(
                                'Rp. ${controller.paymentClass.deliveryTime}',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                )
                              ),
                            ]
                          ),
                        ]
                      ) 
                    ),
                    const SizedBox(height: 30),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        overlayColor: Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Payment Method',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            )
                          ),
                          Icon(
                            Icons.navigate_next_outlined,
                            color: Colors.black,
                            size: 30,
                          )
                        ]
                      ),
                      onPressed: () => null,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        overlayColor: Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivery Method',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            )
                          ),
                          Icon(
                            Icons.navigate_next_outlined,
                            color: Colors.black,
                            size: 30,
                          )
                        ]
                      ),
                      onPressed: () => null,
                    ),
                  ]
                ),
              )
            ),
            const SizedBox(height: 30),
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Price',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        )
                      ),
                      Text(
                        'Rp. ${controller.paymentClass.totalPrice}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        )
                      ),
                    ]
                  ),
                  TextButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: CustomColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                      overlayColor: CustomColors.primaryColor_100.withAlpha(40),
                    ),
                    child: Text(
                      'Pay Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      )
                    ),
                    onPressed: () {
                      controller.paymentClass.submitOrder();
                    },
                  )
                ]
              )
            )
          ],
        )
      ), 
    );
  }
}

Widget _buildCartProductPric(PaymentController controller, int gridViewIndex) {
  final Product productInCart = controller.paymentClass.getProductInCart(gridViewIndex);

  return Padding(
    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${productInCart.name} (x${productInCart.orderQuantity})',
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          )
        ),
        Text(
          'Rp. ${controller.paymentClass.calculateProductPrice(productInCart)}',
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          )
        ),
      ]
    ),
  );
}