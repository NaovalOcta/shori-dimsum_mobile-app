import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/models/Product.dart';
import 'package:mobile_tugas_akhir/app/modules/3_food_catalog/controllers/food_catalog_controller.dart';

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
}

class PaymentController extends GetxController {
  PaymentClass paymentClass = PaymentClass();
}
