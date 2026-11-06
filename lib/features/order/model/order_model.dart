import 'package:cloud_firestore/cloud_firestore.dart';
class OrderModel {
  final String id;
  final String userId;
  final String address;
  final String status;
  final String paymentMethod;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final DateTime? createdAt;
  final List<Map<String, dynamic>> items;

  OrderModel({
    required this.id,
    required this.userId,
    required this.address,
    required this.status,
    required this.paymentMethod,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.createdAt,
    required this.items,
  });

  factory OrderModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data() ?? {};
    return OrderModel(
      id: doc.id,
      userId: data['userId']?.toString() ?? '',
      address: data['address']?.toString() ?? '',
      status: data['status']?.toString() ?? 'unknown',
      paymentMethod:
      data['paymentMethod']?.toString() ?? 'unknown',
      subtotal: (data['subtotal'] as num?)?.toDouble() ?? 0,
      deliveryFee:
      (data['deliveryFee'] as num?)?.toDouble() ?? 0,
      total: (data['total'] as num?)?.toDouble() ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      items: (data['items'] as List? ?? [])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList(),
    );
  }
}