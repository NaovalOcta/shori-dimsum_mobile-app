import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile_tugas_akhir/app/models/OrderModel.dart';

class OrderDb {
  final SupabaseClient client = Supabase.instance.client;

  // Fetch Orders
  Future<List<OrderModel>> fetchOrders() async {
    // Mengambil data dari tabel 'orders' dan mengurutkan dari yang terbaru
    final response = await client
        .from('orders')
        .select()
        .order('created_at', ascending: false);

    final data = response as List<dynamic>;
    return data.map((e) => OrderModel.fromMap(e)).toList();
  }

  // Update Status
  Future<void> updateStatus(String orderId, String newStatus) async {
    await client.from('orders').update({'status': newStatus}).eq('id', orderId);
  }
}
