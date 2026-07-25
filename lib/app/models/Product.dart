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
  double rating;

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
    // 1. Ambil data unitPieces (format angka di DB -> "16 pcs" di UI)
    // Catatan: Postgres biasanya mengubah unitPieces menjadi 'unitpieces' (lowercase).
    // Kita gunakan fallback agar aman.
    var pcsData = map['unitPieces'] ?? map['unitpieces'] ?? map['unit_pieces']; 
    String formattedPcs = '1 pcs'; // Default
    
    if (pcsData != null) {
      formattedPcs = "$pcsData pcs"; // Mengubah angka 16 menjadi "16 pcs"
    }

    // 2. Ambil image_path (format text di DB -> List<String> di UI)
    List<String> images = [];
    if (map['image_path'] != null) {
      images = [map['image_path'].toString()];
    } else if (map['imagePath'] != null) {
      images = [map['imagePath'].toString()];
    }

    return Product(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? 'Tanpa Nama',
      description: map['description'] ?? '',
      category: map['category'] ?? 'General',
      
      // Hasil konversi angka ke string "XX pcs"
      unitPieces: formattedPcs, 
      
      // Supabase mengembalikan BigInt untuk harga, kita ubah ke int
      price: map['price'] is int 
          ? map['price'] 
          : int.tryParse(map['price']?.toString() ?? '0') ?? 0,
      
      rating: map['rating'] is String
          ? double.tryParse(map['rating']) ?? 0.0
          : (map['rating'] as num?)?.toDouble() ?? 0.0,
      
      // Hasil konversi single path ke List
      imagePath: images,
          
      orderQuantity: 1.obs,
    );
  }

  String getDeliveryInfo() {
    return "Delivered between monday aug and thursday 20 from 8pm to 91:32 pm";
  }

  String getReturnPolicy() {
    return "All our foods are double checked before leaving our stores so by any case you found a broken food please contact our hotline immediately.";
  }
}
