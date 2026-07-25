import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Add intl package for formatting currency
import 'package:mobile_tugas_akhir/app/designs/colors/CustomColors.dart';
import '../controllers/admin_orders_controller.dart';
import 'package:mobile_tugas_akhir/app/models/OrderModel.dart';

class AdminOrdersView extends GetView<AdminOrdersController> {
  const AdminOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor_1, // Cream Background
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundColor_1,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF3E2723),
              size: 24,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Management Order",
          style: TextStyle(
            fontFamily: 'Serif',
            color: Color(0xFF3E2723),
            fontWeight: FontWeight.w900,
            fontSize: 24,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: CustomColors.primaryColor),
          );
        }

        if (controller.orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  size: 80,
                  color: Colors.brown.withOpacity(0.3),
                ),
                const SizedBox(height: 10),
                Text(
                  "No orders yet",
                  style: TextStyle(
                    color: Colors.brown.withOpacity(0.5),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchOrders,
          color: CustomColors.primaryColor,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            itemCount: controller.orders.length,
            itemBuilder: (context, index) {
              final order = controller.orders[index];
              return _buildOrderCard(order);
            },
          ),
        );
      }),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    // Format Currency
    final currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25), // Rounded 25
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Card (ID & Date)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "#${order.id.substring(0, 8).toUpperCase()}", // Short ID
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF3E2723),
                ),
              ),
              Text(
                // Format tanggal sederhana, bisa disesuaikan
                order.createdAt.substring(0, 10),
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const Divider(height: 25, color: Color(0xFFF0F0F0)),

          // 2. Items Summary
          Text(
            order.items.isNotEmpty
                ? order.items.map((item) => '${item.productName} (x${item.quantity})').join(', ')
                : 'Detail pesanan...',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          // 3. Footer (Price & Status Button)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Total Price
              Text(
                currencyFormatter.format(order.totalPrice),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: CustomColors.primaryColor, // Maroon
                ),
              ),

              // Status Change Button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => controller.showStatusSelector(order),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: controller
                          .getStatusColor(order.status)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: controller
                            .getStatusColor(order.status)
                            .withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: controller.getStatusColor(order.status),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          order.status.toUpperCase(),
                          style: TextStyle(
                            color: controller.getStatusColor(order.status),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 16,
                          color: controller.getStatusColor(order.status),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
