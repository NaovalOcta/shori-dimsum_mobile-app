class OrderItemModel {
  final String id;
  final String productId;
  final String productName;
  final int unitPrice;
  final int quantity;
  final int subtotal;

  OrderItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.subtotal,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      id: map['id']?.toString() ?? '',
      productId: map['product_id']?.toString() ?? '',
      productName: map['product_name'] ?? '',
      unitPrice: map['unit_price'] is int
          ? map['unit_price']
          : int.tryParse(map['unit_price']?.toString() ?? '0') ?? 0,
      quantity: map['quantity'] is int
          ? map['quantity']
          : int.tryParse(map['quantity']?.toString() ?? '1') ?? 1,
      subtotal: map['subtotal'] is int
          ? map['subtotal']
          : int.tryParse(map['subtotal']?.toString() ?? '0') ?? 0,
    );
  }
}

class OrderModel {
  String id;
  String userId;
  String status;
  int totalPrice;
  List<OrderItemModel> items;
  String createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.totalPrice,
    required this.items,
    required this.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? 'Guest',
      status: map['status'] ?? 'pending',
      totalPrice: map['total_price'] is int
          ? map['total_price']
          : int.tryParse(map['total_price']?.toString() ?? '0') ?? 0,
      items: (map['order_items'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: map['created_at'] ?? DateTime.now().toIso8601String(),
    );
  }
}
