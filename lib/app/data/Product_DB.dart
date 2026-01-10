import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile_tugas_akhir/app/models/Product.dart';

class ProductDb {
  final SupabaseClient client = Supabase.instance.client;

  // --- READ ---
  Future<List<Product>> fetchProducts() async {
    final response = await client.from('products').select();
    final data = response as List<dynamic>;
    return data.map((e) => Product.fromMap(e)).toList();
  }

  // --- CREATE ---
  Future<void> addProduct(Product product) async {
    // Convert Product object back to Map for DB
    // Note: Pastikan field 'image_path' disimpan sebagai string path di DB
    // Jika Anda punya fitur upload gambar, logic uploadnya terpisah di Controller
    await client.from('products').insert({
      'name': product.name,
      'price': product.price,
      'description': product.description,
      'category': product.category,
      'unitPieces': product.unitPieces.replaceAll(
        ' pcs',
        '',
      ), // Simpan angka saja jika tipe DB smallint
      'image_path': product.imagePath.isNotEmpty ? product.imagePath[0] : null,
      'rating': '0.0', // Default rating
    });
  }

  // --- UPDATE ---
  Future<void> updateProduct(Product product) async {
    await client
        .from('products')
        .update({
          'name': product.name,
          'price': product.price,
          'description': product.description,
          'category': product.category,
          'unitPieces': product.unitPieces.replaceAll(' pcs', ''),
          'image_path': product.imagePath.isNotEmpty
              ? product.imagePath[0]
              : null,
        })
        .eq('id', product.id); // Update berdasarkan ID
  }

  // --- DELETE ---
  Future<void> deleteProduct(String id) async {
    await client.from('products').delete().eq('id', id);
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