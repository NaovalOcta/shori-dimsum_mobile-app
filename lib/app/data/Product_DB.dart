import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile_tugas_akhir/app/models/Product.dart';

class ProductDb {
  final _supabase = Supabase.instance.client;

  static final ProductDb _instance = ProductDb._internal();
  factory ProductDb() {
    return _instance;
  }
  ProductDb._internal();

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _supabase.from('products').select();

      final data = response as List<dynamic>;
      return data.map((item) => Product.fromMap(item)).toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }
}





// import 'package:get/get.dart';
// import 'package:mobile_tugas_akhir/app/models/Product.dart';

// class ProductDb {
//   final List<Product> productDataList = <Product>[
//     Product(
//       id: 0,
//       name: 'Dimsum Mental', 
//       unitPieces: '16pcs', 
//       rating: '4.9',
//       imagePath: [
//         'assets/products_placeholder.jpg', 
//         'assets/products_placeholder.jpg', 
//         'assets/products_placeholder.jpg'
//       ],
//       price: 10000,
//       orderQuantity: 1.obs,
//     ),
//     Product(
//       id: 1,
//       name: 'Siomay Premium', 
//       unitPieces: '10pcs', 
//       rating: '4.7',
//       imagePath: [
//         'assets/products_placeholder.jpg'
//       ],
//       price: 11000,
//       orderQuantity: 1.obs,
//     ),
//     Product(
//       id: 2,
//       name: 'Bakpao Ayam', 
//       unitPieces: '5pcs', 
//       rating: '4.5',
//       imagePath: [
//         'assets/products_placeholder.jpg', 
//         'assets/products_placeholder.jpg'
//       ],
//       price: 12000,
//       orderQuantity: 1.obs,
//     ),
//     Product(
//       id: 3,
//       name: 'Ayam Special', 
//       unitPieces: '2pcs', 
//       rating: '5.0',
//       imagePath: [
//         'assets/products_placeholder.jpg', 
//         'assets/products_placeholder.jpg'
//       ],
//       price: 13000,
//       orderQuantity: 1.obs,
//     ),
//     Product(
//       id: 4,
//       name: 'Mie Ayam', 
//       unitPieces: '5pcs', 
//       rating: '4.5',
//       imagePath: [
//         'assets/products_placeholder.jpg', 
//         'assets/products_placeholder.jpg'
//       ],
//       price: 14000,
//       orderQuantity: 1.obs,
//     ),
//   ];
// }