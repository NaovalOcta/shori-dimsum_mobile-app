import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/modules/2_home/controllers/home_controller.dart';

class Product extends HomeController {
  String id;
  String name;
  List<String> imagePath;
  String description;
  String category;
  String unitPieces;
  int price;
  String rating;

  RxInt orderQuantity = 1.obs;
  RxBool isFavorite = false.obs;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.unitPieces,
    required this.price,
    required this.rating,
    required this.imagePath,
    required this.orderQuantity,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      unitPieces: map['unit_pieces'],
      price: map['price'],
      rating: map['rating'].toString(),
      imagePath: List<String>.from(map['image_url']),
      orderQuantity: map['order_quantity'] != null
          ? (map['order_quantity'] as int).obs
          : 1.obs,
    );
  }

  String getDeliveryInfo() {
    return "Delivered between monday aug and thursday 20 from 8pm to 91:32 pm";
  }

  String getReturnPolicy() {
    return "All our foods are double checked before leaving our stores so by any case you found a broken food please contact our hotline immediately.";
  }
}
