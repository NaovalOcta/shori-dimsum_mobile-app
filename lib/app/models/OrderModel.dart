class OrderModel {
  String id;
  String userId; // Atau nama user jika di-join
  String status; // pending, process, completed, cancelled
  int totalPrice;
  String itemsSummary; // Contoh: "Siomay (2), Hakau (1)"
  String createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.totalPrice,
    required this.itemsSummary,
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
      // Asumsi ada kolom items_summary atau kita mock dulu
      itemsSummary: map['items_summary'] ?? 'Detail pesanan...',
      createdAt: map['created_at'] ?? DateTime.now().toIso8601String(),
    );
  }
}
