import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_tugas_akhir/app/models/Product.dart';
import 'package:mobile_tugas_akhir/app/modules/3_food_catalog/controllers/food_catalog_controller.dart';
import 'package:mobile_tugas_akhir/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentClass {
  final FoodCatalogController fCC = Get.find<FoodCatalogController>();

  int orderPrice = 0;
  int taxesFees = 0;
  int deliveryFees = 0;
  int totalPrice = 0;
  int deliveryTime = 0;

  void calculateTotalPrice() {
    for(int cartId in fCC.productClass.cartProductsIds) {
      Product product = fCC.productClass.products[cartId];
      totalPrice += product.orderQuantity.value * product.price;
    }

    totalPrice += taxesFees + deliveryFees;
  }

  int calculateProductPrice(Product productInCart) {
    return productInCart.price * productInCart.orderQuantity.value; 
  }

  Product getProductInCart(int index) {
    int productInCartIndex = fCC.productClass.cartProductsIds[index];
    Product productInCart = fCC.productClass.products[productInCartIndex];
    
    return productInCart;
  }

  void resetOrderCalculation() {
    orderPrice = 0;
    taxesFees = 0;
    deliveryFees = 0;
    totalPrice = 0;
    deliveryTime = 0;
  }

  Future<void> submitOrder() async {
    final supabase = Supabase.instance.client;

    final items = fCC.productClass.cartProductsIds.map((cartId) {
      final product = fCC.productClass.products[cartId];
      return {
        'product_id': product.id,
        'quantity': product.orderQuantity.value,
      };
    }).toList();

    try {
      final response = await supabase.rpc('create_order', params: {
        'p_items': items,
      });

      if (response != null) {
        final orderId = response['order_id'];
        final totalPrice = response['total_price'];

        Get.snackbar(
          'Success',
          'Order created! Total: Rp ${NumberFormat.decimalPattern('id').format(totalPrice)}',
          backgroundColor: Colors.white,
        );

        fCC.productClass.cartProductsIds.clear();
        resetOrderCalculation();

        Get.offNamed(Routes.PAYMENT_COMPLETE, arguments: {
          'order_id': orderId,
          'total_price': totalPrice,
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal membuat pesanan: $e',
        backgroundColor: Colors.white,
      );
    }
  }
}

class PaymentController extends GetxController {
  PaymentClass paymentClass = PaymentClass();
}
