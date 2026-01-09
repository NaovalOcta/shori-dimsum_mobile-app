import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/designs/colors/CustomColors.dart';
import 'package:mobile_tugas_akhir/app/modules/3_food_catalog/controllers/food_catalog_controller.dart';
import 'package:mobile_tugas_akhir/app/modules/5_payment/controllers/payment_controller.dart';
import 'package:mobile_tugas_akhir/app/routes/app_pages.dart';

import '../controllers/payment_complete_controller.dart';

class PaymentCompleteView extends GetView<PaymentCompleteController> {
  const PaymentCompleteView({super.key});
  
  @override
  Widget build(BuildContext context) {
    final FoodCatalogController fCC = Get.find<FoodCatalogController>();
    final PaymentController pC = Get.find<PaymentController>();

    return Scaffold(
      backgroundColor: CustomColors.backgroundColor_1,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 60),
          child: Container(
            height: 350,
            padding: EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset(
                    'assets/success_icon.png',
                    width: 80,
                    height: 80
                  )
                ),
                const SizedBox(height: 20),
                Text(
                  'Success !',
                  style: TextStyle(
                    color: CustomColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Text(
                  'Your payment was successful. A receipt for this purchase has been sent to your email.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 40),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: CustomColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  ),
                  child: Text(
                    'Go Back',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  onPressed: () {
                    fCC.productClass.resetCart();
                    pC.paymentClass.resetOrderCalculation();

                    Get.toNamed(Routes.HOME);
                  },
                )
              ],
            )
          )
        )
      )
    );
  }
}
