import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/data/Order_DB.dart';
import 'package:mobile_tugas_akhir/app/models/OrderModel.dart';

class AdminOrdersController extends GetxController {
  RxList<OrderModel> orders = <OrderModel>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      List<OrderModel> data = await OrderDb().fetchOrders();
      orders.assignAll(data);
    } catch (e) {
      print("Error fetching orders: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi mengubah status via BottomSheet
  void showStatusSelector(OrderModel order) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Update Status",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Serif',
              ),
            ),
            const SizedBox(height: 20),
            _buildStatusOption(order, "Pending", Colors.orange),
            _buildStatusOption(order, "Process", Colors.blue),
            _buildStatusOption(order, "Completed", Colors.green),
            _buildStatusOption(order, "Cancelled", Colors.red),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOption(OrderModel order, String status, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.circle, color: color, size: 14),
      ),
      title: Text(status, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: () {
        updateOrderStatus(order.id, status.toLowerCase());
        Get.back(); // Tutup bottom sheet
      },
      trailing: order.status.toLowerCase() == status.toLowerCase()
          ? const Icon(Icons.check, color: Colors.black)
          : null,
    );
  }

  Future<void> updateOrderStatus(String id, String status) async {
    try {
      // Optimistic Update (Ubah UI dulu biar cepat)
      int index = orders.indexWhere((o) => o.id == id);
      if (index != -1) {
        OrderModel old = orders[index];
        orders[index] = OrderModel(
          id: old.id,
          userId: old.userId,
          status: status,
          totalPrice: old.totalPrice,
          itemsSummary: old.itemsSummary,
          createdAt: old.createdAt,
        );
        orders.refresh(); // Refresh UI list
      }

      await OrderDb().updateStatus(id, status);
      Get.snackbar(
        "Sukses",
        "Status pesanan diperbarui",
        duration: const Duration(seconds: 1),
      );
    } catch (e) {
      Get.snackbar("Error", "Gagal update status");
      fetchOrders(); // Revert jika gagal
    }
  }

  // Helper Warna Status
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'process':
        return Colors.blue;
      case 'completed':
        return const Color(0xFF52D726);
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
  